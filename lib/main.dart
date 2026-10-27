import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/core/shared/app_manager.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    await FlutterNaverMap().init(
      clientId: ApiEnv.naverMapsClientId,
      onAuthFailed: (exception) {
        if (kDebugMode) { debugPrint('[MAP] auth failed ${exception.code} ${exception.message}'); }
      },
    );
    AppManager.shared.mapImagesReady = NativeMap.prepareImages(WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio);
  }

  final supportDirectory = await getApplicationSupportDirectory();
  final imageDirectory = Directory('${supportDirectory.path}${Platform.pathSeparator}property_images');

  final container = ProviderContainer(overrides: [imageDirectoryProvider.overrideWithValue(imageDirectory)]);

  runApp(UncontrolledProviderScope(container: container, child: const VineButlerApp()));
  _preloadPropertyList(container);
}

/// 매물 목록 미리 불러오기
///
/// - 첫 DB 접근(백그라운드 isolate 생성·DB 열기)이 매물 탭을 처음 누르는 순간에 몰리지 않도록 앱 시작 직후 뒷단에서 시작
/// - 지도 탭 VM은 만들면 위치 권한 창이 먼저 뜨므로 미리 만들지 않음
void _preloadPropertyList(ProviderContainer container) => container.read(propertyListVMProvider);

class VineButlerApp extends StatelessWidget {
  const VineButlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: MainColor.medium, primary: MainColor.medium),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: MainColor.medium,
          selectionColor: MainColor.light,
          selectionHandleColor: MainColor.medium,
        ),
        datePickerTheme: AppPickerTheme.date,
      ),
      routerConfig: appRouter,
    );
  }
}
