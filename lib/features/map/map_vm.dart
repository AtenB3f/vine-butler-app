import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';
import 'package:vine_butler/features/map/presentation/map_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_item_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

final mapVMProvider = NotifierProvider<MapVM, MapViewState>(MapVM.new);

sealed class MapAction {
  const MapAction();

  const factory MapAction.select(String id) = _Select;
  const factory MapAction.clear() = _Clear;
  const factory MapAction.search(String query) = _Search;
  const factory MapAction.panel(bool isPresented) = _Panel;
  const factory MapAction.filtering(PropertyFilterData data) = _Filtering;
}

class _Select extends MapAction {
  final String id;

  const _Select(this.id);
}

class _Clear extends MapAction {
  const _Clear();
}

class _Search extends MapAction {
  final String query;

  const _Search(this.query);
}

class _Panel extends MapAction {
  final bool isPresented;

  const _Panel(this.isPresented);
}

class _Filtering extends MapAction {
  final PropertyFilterData data;

  const _Filtering(this.data);
}

class MapVM extends Notifier<MapViewState> {
  List<Property> _properties = const [];
  StreamSubscription<List<Property>>? _subscription;

  @override
  MapViewState build() {
    const initial = MapViewState();

    ref.onDispose(() => _subscription?.cancel());
    _filtering(initial);
    return initial;
  }

  void action(MapAction action) {
    switch (action) {
      case _Select(:final id):
        state = state.copyWith(
          selected: () => _card(id),
          status: PropertySearchStatus.select,
        );

      case _Clear():
        state = state.copyWith(selected: () => null);

      case _Search(:final query):
        state = state.copyWith(
          query: query,
          status: state.status == PropertySearchStatus.select ? PropertySearchStatus.close : null,
        );
        _filtering(state);

      case _Panel(:final isPresented):
        state = state.copyWith(status: isPresented ? PropertySearchStatus.open : PropertySearchStatus.close);

      case _Filtering(:final data):
        state = state.copyWith(filter: data);
        _filtering(state);
    }
  }

  void _filtering(MapViewState target) {
    final condition = target.filter.toCondition(target.query);

    _subscription?.cancel();
    _subscription = ref.read(propertyUseCaseProvider).watchFilter(condition).listen(_update);
  }

  void _update(List<Property> properties) {
    final selectedId = state.selected?.id;

    _properties = properties;
    state = state.copyWith(
      markers: properties.map(_marker).toList(),
      selected: () => selectedId == null ? null : _card(selectedId),
      searchResults: state.query.isEmpty
          ? const []
          : properties.take(MapViewState.maxPanelResultCount).map(PropertyListItemViewState.fromDomain).toList(),
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
