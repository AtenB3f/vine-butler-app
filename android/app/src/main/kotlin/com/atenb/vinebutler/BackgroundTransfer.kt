package com.atenb.vinebutler

import android.app.job.JobInfo
import android.app.job.JobScheduler
import android.content.ComponentName
import android.content.Context
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.net.HttpURLConnection
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger

/**
 * `vine_butler/background_transfer` 채널의 요청을 UIDT Job(사용자 시작 데이터 전송)으로 예약
 *
 * - Android 14(API 34) 미만이거나 예약에 실패하면 `UNAVAILABLE` (Dart가 기본 전송으로 대체)
 * - 요청 본문(사진 포함 수 MB)은 Job extras 크기 제한 때문에 메모리에 보관하고 jobId로 전달
 * - 같은 프로세스 안에서만 전달하므로 프로세스가 종료되면 요청도 사라짐 (Job은 재예약하지 않음)
 */
object BackgroundTransfer {
    const val CHANNEL = "vine_butler/background_transfer"

    /** 응답 크기 추정치 (블로그 글 JSON, 시스템이 실행 시간 판단에 사용) */
    private const val ESTIMATED_RESPONSE_BYTES = 64L * 1024

    private val nextJobId = AtomicInteger(1000)
    private val pending = ConcurrentHashMap<Int, Transfer>()

    class Transfer(
        val url: String,
        val method: String,
        val headers: Map<String, String>,
        val body: ByteArray,
        val connectTimeoutMs: Int?,
        val receiveTimeoutMs: Int?,
        val result: MethodChannel.Result,
    ) {
        @Volatile
        var connection: HttpURLConnection? = null
    }

    fun schedule(context: Context, call: MethodCall, result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            result.error("UNAVAILABLE", "UIDT Job은 Android 14 이상만 지원", null)
            return
        }

        val transfer = Transfer(
            url = call.argument<String>("url") ?: "",
            method = call.argument<String>("method") ?: "GET",
            headers = call.argument<Map<String, String>>("headers") ?: emptyMap(),
            body = call.argument<ByteArray>("body") ?: ByteArray(0),
            connectTimeoutMs = call.argument<Int>("connectTimeoutMs"),
            receiveTimeoutMs = call.argument<Int>("receiveTimeoutMs"),
            result = result,
        )
        val jobId = nextJobId.getAndIncrement()
        val job = JobInfo.Builder(jobId, ComponentName(context, BackgroundTransferJobService::class.java))
            .setUserInitiated(true)
            .setRequiredNetworkType(JobInfo.NETWORK_TYPE_ANY)
            .setEstimatedNetworkBytes(transfer.body.size.toLong(), ESTIMATED_RESPONSE_BYTES)
            .build()

        pending[jobId] = transfer

        if (context.getSystemService(JobScheduler::class.java).schedule(job) != JobScheduler.RESULT_SUCCESS) {
            pending.remove(jobId)
            result.error("UNAVAILABLE", "UIDT Job 예약 실패", null)
        }
    }

    fun take(jobId: Int): Transfer? = pending.remove(jobId)
}
