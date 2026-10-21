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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    await FlutterNaverMap().init(
      clientId: ApiEnv.naverMapsClientId,
      onAuthFailed: (exception) {
        if (kDebugMode) { debugPrint('[MAP] auth failed ${exception.code} ${exception.message}'); }
      },
    );
  }

  final supportDirectory = await getApplicationSupportDirectory();
  final imageDirectory = Directory('${supportDirectory.path}${Platform.pathSeparator}property_images');

  runApp(
    ProviderScope(
      overrides: [imageDirectoryProvider.overrideWithValue(imageDirectory)],
      child: const VineButlerApp(),
    ),
  );
}

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
