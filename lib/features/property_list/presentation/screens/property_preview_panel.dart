import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/features/property_list/presentation/property_preview_view_state.dart';

class PropertyPreviewPanel extends StatelessWidget {
  final PropertyPreviewViewState viewState;
  final PropertyPreviewMedia media;
  final ValueChanged<PropertyPreviewMedia> onMediaChange;

  const PropertyPreviewPanel({
    super.key,
    required this.viewState,
    required this.media,
    required this.onMediaChange,
  });

  @override
  Widget build(BuildContext context) {
    if (!viewState.hasImages) { return _map(); }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _mediaButtons(),
        Expanded(child: media == PropertyPreviewMedia.map ? _map() : _images()),
      ],
    );
  }

  Widget _mediaButtons() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _mediaButton(icon: AppIcons.mapSM, text: '지도', value: PropertyPreviewMedia.map),
          _mediaButton(icon: AppIcons.imageSM, text: '이미지', value: PropertyPreviewMedia.image),
        ],
      ),
    );
  }

  Widget _mediaButton({
    required Widget Function(Color color) icon,
    required String text,
    required PropertyPreviewMedia value,
  }) {
    final isSelected = media == value;
    final color = isSelected ? TextColor.dark : GrayColor.light;
    final button = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: StateColor.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          icon(color),
          (isSelected ? AppFontStyle.bold2 : AppFontStyle.body2).text(text, color),
        ],
      ),
    );

    if (isSelected) { return button; }

    return Pressable(onTap: () => onMediaChange(value), child: button);
  }

  Widget _images() {
    return AppImagePage(
      viewState: AppImagePageViewState(
        images: [for (final path in viewState.imagePaths) FileImage(File(path))],
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _map() {
    final mapViewState = NaverMapViewState(
      cameraLocation: (latitude: viewState.latitude, longitude: viewState.longitude),
      markers: [NaverMarkerViewState(id: 'position', latitude: viewState.latitude, longitude: viewState.longitude)],
      selectedMarkerId: 'position',
      clientId: ApiEnv.naverMapsClientId,
      webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
    );

    return switch (defaultTargetPlatform) {
      TargetPlatform.macOS => MacMap(viewState: mapViewState),
      TargetPlatform.windows => WindowsMap(viewState: mapViewState),
      _ => const ColoredBox(color: BaseColor.light),
    };
  }
}
