import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';
import 'package:vine_butler/features/map/presentation/map_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

final mapVMProvider = NotifierProvider<MapVM, MapViewState>(MapVM.new);

sealed class MapAction {
  const MapAction();

  const factory MapAction.select(String id) = _Select;
  const factory MapAction.clear() = _Clear;
}

class _Select extends MapAction {
  final String id;

  const _Select(this.id);
}

class _Clear extends MapAction {
  const _Clear();
}

class MapVM extends Notifier<MapViewState> {
  List<Property> _properties = const [];

  @override
  MapViewState build() {
    final subscription = ref.read(propertyUseCaseProvider).watchList().listen(_update);

    ref.onDispose(subscription.cancel);
    return const MapViewState();
  }

  void action(MapAction action) {
    switch (action) {
      case _Select(:final id):
        state = state.copyWith(selected: () => _card(id));

      case _Clear():
        state = state.copyWith(selected: () => null);
    }
  }

  void _update(List<Property> properties) {
    final selectedId = state.selected?.id;

    _properties = properties;
    state = state.copyWith(
      markers: properties.map(_marker).toList(),
      selected: () => selectedId == null ? null : _card(selectedId),
    );
  }

  MapPropertyCardViewState? _card(String id) {
    final property = _properties.where((property) => property.id == id).firstOrNull;

    return property == null ? null : MapPropertyCardViewState.fromDomain(property);
  }

  NaverMarkerViewState _marker(Property property) {
    final deal = property.deal;
    final monthlyRent = deal.monthlyRent;

    return NaverMarkerViewState(
      id: property.id,
      latitude: property.address.latitude,
      longitude: property.address.longitude,
      label: monthlyRent == null ? deal.price.formattedKRW : '${deal.price.formattedKRW} | ${monthlyRent.formattedKRW}',
      backgroundColor: switch (deal.transactionType) {
        PropertyTransactionType.rent => PrimaryColor.light,
        PropertyTransactionType.depositOnly => SecondaryColor.light,
        PropertyTransactionType.buy => TertiaryColor.light,
      },
      borderColor: switch (deal.transactionType) {
        PropertyTransactionType.rent => PrimaryColor.dark,
        PropertyTransactionType.depositOnly => SecondaryColor.dark,
        PropertyTransactionType.buy => TertiaryColor.dark,
      },
    );
  }
}
