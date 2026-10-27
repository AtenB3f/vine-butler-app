import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/components/widgets/map/map_loading.dart';
import 'package:vine_butler/components/widgets/map/map_pin_spec.dart';

part 'native_map_images.dart';
part 'native_map_state.dart';

class NativeMap extends StatefulWidget {
  final NaverMapViewState viewState;
  final ValueChanged<String>? onMarkerTap;
  final VoidCallback? onMapTap;
  final ValueChanged<NaverMapCamera>? onStopCamera;

  /// 지도를 연결하고 이미지를 만들기 전에 기다릴 작업 (앱에서 지도 이미지 준비를 넘김)
  final Future<void> Function()? onInit;

  const NativeMap({
    super.key,
    required this.viewState,
    this.onMarkerTap,
    this.onMapTap,
    this.onStopCamera,
    this.onInit,
  });

  /// 지도 이미지 준비 (앱 시작 때 한 번)
  ///
  /// - 내 위치 아이콘을 미리 저장해 지도 플러그인 임시 폴더를 만들어 둠 (같은 cacheKey라 지도에서는 저장된 파일을 재사용)
  static Future<void> prepareImages(double pixelRatio) => _NativeMapImages.userLocation(pixelRatio);

  @override
  State<NativeMap> createState() => _NativeMapState();
}
