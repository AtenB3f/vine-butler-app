import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/shared/app_manager.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

class PropertyDetailMap extends StatelessWidget {
  final PropertyDetailData? data;

  const PropertyDetailMap({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final data = this.data;

    if (data == null) { return const ColoredBox(color: BaseColor.light); }

    final viewState = NaverMapViewState(
      cameraLocation: (latitude: data.latitude, longitude: data.longitude),
      markers: [NaverMarkerViewState(id: 'position', latitude: data.latitude, longitude: data.longitude)],
      selectedMarkerId: 'position',
      clientId: ApiEnv.naverMapsClientId,
      webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
    );

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => NativeMap(viewState: viewState, onInit: () => AppManager.shared.mapImagesReady),
      TargetPlatform.macOS => MacMap(viewState: viewState),
      TargetPlatform.windows => WindowsMap(viewState: viewState),
      _ => const ColoredBox(color: BaseColor.light),
    };
  }
}
