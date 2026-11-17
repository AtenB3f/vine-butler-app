import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';

enum PropertyPreviewMedia {
  map,
  image,
}

class PropertyPreviewViewState {
  final List<String> imagePaths;
  final double latitude;
  final double longitude;
  final MapPropertyCardViewState card;

  const PropertyPreviewViewState({
    required this.imagePaths,
    required this.latitude,
    required this.longitude,
    required this.card,
  });

  bool get hasImages => imagePaths.isNotEmpty;

  factory PropertyPreviewViewState.fromDomain(Property property, {required String Function(String fileName) imagePath}) {
    return PropertyPreviewViewState(
      imagePaths: [for (final image in property.images) imagePath(image.fileName)],
      latitude: property.address.latitude,
      longitude: property.address.longitude,
      card: MapPropertyCardViewState.fromDomain(property),
    );
  }
}
