import 'package:flutter/widgets.dart';

class AppImagePageViewState {
  final List<ImageProvider> images;

  const AppImagePageViewState({
    required this.images,
  });

  AppImagePageViewState.urls(List<String> urls) : images = urls.map(NetworkImage.new).toList();
}
