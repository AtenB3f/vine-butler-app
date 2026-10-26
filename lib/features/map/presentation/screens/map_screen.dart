import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/map/map_vm.dart';
import 'package:vine_butler/features/map/presentation/map_property_card_view_state.dart';
import 'package:vine_butler/features/map/presentation/map_view_state.dart';
import 'package:vine_butler/features/map/presentation/screens/map_property_card.dart';
import 'package:vine_butler/features/map/presentation/screens/map_top_section.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_panel.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_tags.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_search_overlay.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_search_result_item.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapVMProvider);
    final viewModel = ref.read(mapVMProvider.notifier);
    final selected = state.selected;

    ref.handleEvent(
      mapVMProvider.select((state) => state.event),
      consume: () => viewModel.action(const MapAction.consumeEvent()),
      onEvent: (event) => _onEvent(context, viewModel, event),
    );

    return Scaffold(
      backgroundColor: StateColor.white,
      body: Column(
        children: [
          _MapBanner(status: state.bndStatus, isOpen: state.status == PropertySearchStatus.open),
          Expanded(
            child: PropertySearchOverlay(
              isVisible: state.status == PropertySearchStatus.open,
              onDismiss: () => viewModel.action(const MapAction.panel(false)),
              searchResults: [
                for (final item in state.searchResults)
                  PropertySearchResultItem(
                    viewState: item,
                    query: state.query,
                    onTap: () => viewModel.action(MapAction.select(item.id)),
                  ),
              ],
              filterPanel: PropertyFilterPanel(
                data: state.filter,
                onFilter: (data) => viewModel.action(MapAction.filtering(data)),
                onCollapse: () => viewModel.action(const MapAction.panel(false)),
              ),
              child: Column(
                children: [
                  if (context.isMobile)
                    MapTopSection(
                      query: state.query,
                      filter: state.filter,
                      onFilter: (data) => viewModel.action(MapAction.filtering(data)),
                      onClearQuery: () => viewModel.action(const MapAction.search('')),
                      onMyLocationTap: () => viewModel.action(const MapAction.locate()),
                    )
                  else
                    PropertyFilterTags(
                      query: state.query,
                      filter: state.filter,
                      onFilter: (data) => viewModel.action(MapAction.filtering(data)),
                      onClearQuery: () => viewModel.action(const MapAction.search('')),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(child: _map(state, viewModel)),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _AnimatedCard(
                            selected: selected,
                            onTap: (id) => PropertyDetailRoute(id: id).push(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onEvent(BuildContext context, MapVM viewModel, MapEvent event) async {
    switch (event) {
      case MapEvent.locationPermission:
        final isConfirmed = await showAppAlertDialog(
          context,
          const AppAlertDialogViewState(
            title: '위치 접근 권한을 허용해 주세요.',
            message: '사용자의 위치를 기반으로\n지도를 표시하기 위해\n위치 권한 허용 설정이 필요합니다.',
            primaryText: '설정',
            secondaryText: '취소',
          ),
        );

        if (isConfirmed == true) { viewModel.action(const MapAction.openSettings()); }
    }
  }

  Widget _map(MapViewState state, MapVM viewModel) {
    final viewState = NaverMapViewState(
      cameraLocation: (latitude: MapViewState.defaultLatitude, longitude: MapViewState.defaultLongitude),
      userLocation: state.userLocation,
      nearbyLocation: state.nearbyLocation,
      zoom: state.userLocation == null ? MapViewState.defaultZoom : MapViewState.userLocationZoom,
      clientId: ApiEnv.naverMapsClientId,
      webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
      markers: state.markers,
      selectedMarkerId: state.selected?.id,
      isLoaded: state.isLoaded,
      cameraRequestId: state.cameraRequestId,
    );

    void onMarkerTap(String id) => viewModel.action(MapAction.select(id));
    void onMapTap() => viewModel.action(const MapAction.clear());

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => NativeMap(viewState: viewState, onMarkerTap: onMarkerTap, onMapTap: onMapTap),
      TargetPlatform.macOS => MacMap(viewState: viewState, onMarkerTap: onMarkerTap, onMapTap: onMapTap),
      TargetPlatform.windows => WindowsMap(viewState: viewState, onMarkerTap: onMarkerTap, onMapTap: onMapTap),
      _ => const ColoredBox(color: BaseColor.light),
    };
  }
}

class _MapBanner extends ConsumerStatefulWidget {
  final AppBndSearchStatus status;
  final bool isOpen;

  const _MapBanner({required this.status, required this.isOpen});

  @override
  ConsumerState<_MapBanner> createState() => _MapBannerState();
}

class _MapBannerState extends ConsumerState<_MapBanner> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(mapVMProvider.notifier);

    ref.listen(mapVMProvider.select((state) => state.query), (_, query) {
      if (_controller.text != query) { _controller.text = query; }
    });

    ref.listen(mapVMProvider.select((state) => state.status), (previous, status) {
      if (previous == PropertySearchStatus.open && status != PropertySearchStatus.open) { FocusManager.instance.primaryFocus?.unfocus(); }
    });

    return AppBndSearch(
      viewState: AppBndSearchViewState(status: widget.status, placeholder: '매물 찾기'),
      controller: _controller,
      onChange: (query) => viewModel.action(MapAction.search(query)),
      onFocus: (hasFocus) {
        if (hasFocus) { viewModel.action(const MapAction.panel(true)); }
      },
      onSearchTap: () => viewModel.action(MapAction.panel(!widget.isOpen)),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final MapPropertyCardViewState? selected;
  final ValueChanged<String> onTap;

  const _AnimatedCard({required this.selected, required this.onTap});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  static const Duration _duration = Duration(milliseconds: 250);

  late MapPropertyCardViewState? _card = widget.selected;

  @override
  void didUpdateWidget(covariant _AnimatedCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected != null) { _card = widget.selected; }
  }

  @override
  Widget build(BuildContext context) {
    final card = _card;
    final isVisible = widget.selected != null;

    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 1),
        duration: _duration,
        curve: Curves.easeOutCubic,
        child: card == null ? const SizedBox.shrink() : MapPropertyCard(viewState: card, onTap: () => widget.onTap(card.id)),
      ),
    );
  }
}
