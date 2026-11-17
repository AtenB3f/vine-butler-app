package com.atenb.vinebutler

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.job.JobParameters
import android.app.job.JobService
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.net.HttpURLConnection
import java.net.SocketTimeoutException
import java.net.URL
import java.util.concurrent.ConcurrentHashMap

/**
 * UIDT Job으로 HTTP 요청을 보내고 결과를 Dart 채널로 돌려주는 JobService
 *
 * - returns: `statusCode`, `headers`, `body` / errors: `TIMEOUT`, `NETWORK`, `STOPPED`
 * - 시스템 중지 `onStopJob`의 경우 재예약하지 않음
 * - `content-length` 헤더는 HttpURLConnection이 본문 크기로 직접 계산하므로 제외
 */
class BackgroundTransferJobService : JobService() {
    private val mainHandler = Handler(Looper.getMainLooper())
    private val running = ConcurrentHashMap<Int, BackgroundTransfer.Transfer>()

    override fun onStartJob(params: JobParameters): Boolean {
        val transfer = BackgroundTransfer.take(params.jobId) ?: return false

        running[params.jobId] = transfer
        setNotification(params, params.jobId, notification(), JOB_END_NOTIFICATION_POLICY_REMOVE)
        Thread {
            val deliver = send(transfer)

            mainHandler.post {
                running.remove(params.jobId)?.let {
                    deliver(it.result)
                    jobFinished(params, false)
                }
            }
        }.start()
        return true
    }

    override fun onStopJob(params: JobParameters): Boolean {
        running.remove(params.jobId)?.let {
            it.connection?.disconnect()
            it.result.error("STOPPED", "시스템이 전송 작업을 중지함 (사유 코드 ${params.stopReason})", null)
        }
        return false
    }

    private fun send(transfer: BackgroundTransfer.Transfer): (MethodChannel.Result) -> Unit {
        return try {
            val connection = URL(transfer.url).openConnection() as HttpURLConnection

            transfer.connection = connection
            connection.requestMethod = transfer.method
            connection.connectTimeout = transfer.connectTimeoutMs ?: 0
            connection.readTimeout = transfer.receiveTimeoutMs ?: 0
            transfer.headers.filterKeys { !it.equals("content-length", ignoreCase = true) }.forEach { (key, value) -> connection.setRequestProperty(key, value) }

            if (transfer.body.isNotEmpty()) {
                connection.doOutput = true
                connection.setFixedLengthStreamingMode(transfer.body.size)
                connection.outputStream.use { it.write(transfer.body) }
            }

            val statusCode = connection.responseCode
            val stream = if (statusCode >= 400) connection.errorStream else connection.inputStream
            val body = stream?.use { it.readBytes() } ?: ByteArray(0)
            val headers = connection.headerFields.filterKeys { it != null }.mapValues { it.value.joinToString(", ") }

            connection.disconnect()
            return { it.success(mapOf("statusCode" to statusCode, "headers" to headers, "body" to body)) }
        } catch (e: SocketTimeoutException) {
            { it.error("TIMEOUT", e.message, null) }
        } catch (e: IOException) {
            { it.error("NETWORK", e.message, null) }
        }
    }

    private fun notification(): Notification {
        val channel = NotificationChannel(CHANNEL_ID, "백그라운드 작업", NotificationManager.IMPORTANCE_LOW)
        val openApp = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        return Notification.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("요청한 작업을 처리하고 있습니다.")
            .setContentText("완료 후 앱에서 확인할 수 있습니다.")
            .setContentIntent(openApp)
            .setOngoing(true)
            .build()
    }

    companion object {
        private const val CHANNEL_ID = "background_transfer"
    }
}
