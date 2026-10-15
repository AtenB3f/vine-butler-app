import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
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

  runApp(const ProviderScope(child: VineButlerApp()));
}

class VineButlerApp extends StatelessWidget {
  const VineButlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        datePickerTheme: AppPickerTheme.date,
      ),
      routerConfig: appRouter,
    );
  }
}
