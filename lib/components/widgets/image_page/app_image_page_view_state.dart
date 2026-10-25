import 'package:flutter/widgets.dart';

class AppImagePageViewState {
  final List<ImageProvider> images;
  final BoxFit fit;
  final int index;

  const AppImagePageViewState({
    required this.images,
    this.fit = BoxFit.cover,
    this.index = 0,
  });

  AppImagePageViewState.urls(List<String> urls)
      : images = urls.map(NetworkImage.new).toList(),
        fit = BoxFit.cover,
        index = 0;
}
