import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/desktop_frame.dart';
import 'package:vine_butler/components/widgets/tab/desktop_tab_type.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/core/shared/app_manager.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';
import 'package:window_manager/window_manager.dart';

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

  if (Platform.isWindows) { _setUpWindowsWindow(); }

  final supportDirectory = await getApplicationSupportDirectory();
  final imageDirectory = Directory('${supportDirectory.path}${Platform.pathSeparator}property_images');

  final container = ProviderContainer(overrides: [imageDirectoryProvider.overrideWithValue(imageDirectory)]);

  runApp(UncontrolledProviderScope(container: container, child: const VineButlerApp()));
  _preloadPropertyList(container);
}

/// Windows 창 설정
///
/// - OS 타이틀바를 숨기고 `DesktopFrame` 상단 AppBar로 대신함
/// - 최소 사이즈 800×500 (macOS는 `MainFlutterWindow.swift`에서 지정)
void _setUpWindowsWindow() {
  final window = WindowManager.instance.getCurrent();

  if (window == null) { return; }

  window.titleBarStyle = TitleBarStyle.hidden;
  window.minimumSize = const Size(800, 500).toNative();
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
      builder: (context, child) {
        if (!context.isDesktop || child == null) { return child ?? const SizedBox.shrink(); }

        return _DesktopRouterFrame(child: child);
      },
    );
  }
}

/// 현재 경로에 맞춰 데스크톱 탭 선택 상태를 갱신하는 틀
///
/// - 라우터가 build 중에 변경 알림을 보내므로 다음 프레임에 다시 그림
class _DesktopRouterFrame extends StatefulWidget {
  const _DesktopRouterFrame({required this.child});

  final Widget child;

  @override
  State<_DesktopRouterFrame> createState() => _DesktopRouterFrameState();
}

class _DesktopRouterFrameState extends State<_DesktopRouterFrame> {
  @override
  void initState() {
    super.initState();
    appRouter.routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    appRouter.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { setState(() {}); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DesktopFrame(
      currentTab: _currentDesktopTab(),
      onTabTap: (tab) => appRouter.go(_desktopTabLocation(tab)),
      child: widget.child,
    );
  }

  DesktopTabType? _currentDesktopTab() {
    final path = appRouter.routerDelegate.currentConfiguration.uri.path;

    if (path.startsWith(const PropertyListRoute().location)) { return DesktopTabType.property; }
    if (path.startsWith(const FindPropertyRoute().location)) { return DesktopTabType.property; }
    if (path.startsWith(const MapRoute().location)) { return DesktopTabType.map; }
    if (path.startsWith(const ApplyPropertyRoute().location)) { return DesktopTabType.register; }

    return null;
  }

  String _desktopTabLocation(DesktopTabType tab) {
    switch (tab) {
      case DesktopTabType.property:
        return const PropertyListRoute().location;

      case DesktopTabType.map:
        return const MapRoute().location;

      case DesktopTabType.register:
        return const ApplyPropertyRoute().location;
    }
  }
}
