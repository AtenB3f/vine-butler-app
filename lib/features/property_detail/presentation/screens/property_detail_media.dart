import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_map.dart';

class PropertyDetailMedia extends StatelessWidget {
  final PropertyDetailData data;
  final bool isMapVisible;
  final VoidCallback onToggleMap;

  const PropertyDetailMedia({
    super.key,
    required this.data,
    required this.isMapVisible,
    required this.onToggleMap,
  });

  @override
  Widget build(BuildContext context) {
    final height = context.isMobile ? 246.0 : 240.0;

    if (!data.hasImages) { return SizedBox(height: height, width: double.infinity, child: PropertyDetailMap(data: data)); }

    if (!context.isMobile) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: AppImagePage(
          viewState: _imagePageViewState(),
          onTap: (index) => _showImages(context, index),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 4,
      children: [
        _mediaButtons(),
        SizedBox(height: height, width: double.infinity, child: _imageMap(context)),
      ],
    );
  }

  Widget _mediaButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _mediaButton(icon: AppIcons.mapSM, text: '지도', isSelected: isMapVisible, onTap: onToggleMap),
        _mediaButton(icon: AppIcons.imageSM, text: '이미지', isSelected: !isMapVisible, onTap: onToggleMap),
      ],
    );
  }

  Widget _mediaButton({
    required Widget Function(Color color) icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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

    return Pressable(onTap: onTap, child: button);
  }

  AppImagePageViewState _imagePageViewState({BoxFit fit = BoxFit.cover, int index = 0}) {
    return AppImagePageViewState(
      images: [for (final path in data.imagePaths) FileImage(File(path))],
      fit: fit,
      index: index,
    );
  }

  Widget _imageMap(BuildContext context) {
    if (isMapVisible) { return PropertyDetailMap(data: data); }

    return AppImagePage(
      viewState: _imagePageViewState(),
      onTap: (index) => _showImages(context, index),
    );
  }

  void _showImages(BuildContext context, int index) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '사진 닫기',
      barrierColor: StateColor.dimmed,
      pageBuilder: (dialogContext, animation, secondaryAnimation) => _imageViewer(dialogContext, index),
    );
  }

  Widget _imageViewer(BuildContext dialogContext, int index) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            Pressable(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: AppIcons.closeLG(StateColor.white),
            ),
            Expanded(
              child: AppImagePage(viewState: _imagePageViewState(fit: BoxFit.contain, index: index)),
            ),
          ],
        ),
      ),
    );
  }
}
