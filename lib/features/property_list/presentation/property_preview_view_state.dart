import 'package:vine_butler/domain/model/property.dart';

enum PropertyPreviewMedia {
  map,
  image,
}

class PropertyPreviewViewState {
  final List<String> imagePaths;
  final double latitude;
  final double longitude;

  const PropertyPreviewViewState({
    required this.imagePaths,
    required this.latitude,
    required this.longitude,
  });

  bool get hasImages => imagePaths.isNotEmpty;

  factory PropertyPreviewViewState.fromDomain(Property property, {required String Function(String fileName) imagePath}) {
    return PropertyPreviewViewState(
      imagePaths: [for (final image in property.images) imagePath(image.fileName)],
      latitude: property.address.latitude,
      longitude: property.address.longitude,
    );
  }
}
