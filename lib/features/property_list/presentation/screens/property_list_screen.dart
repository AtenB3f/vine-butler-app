import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/property_preview_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_panel.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_tags.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_list_item.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_preview_panel.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_search_overlay.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_search_result_item.dart';
import 'package:vine_butler/features/property_list/property_list_event_vm.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class PropertyListScreen extends ConsumerWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.handleEvent(
      propertyListVMProvider.select((state) => state.navigateTo),
      consume: ref.read(propertyListVMProvider.notifier).popNavigation,
      onEvent: (location) => context.push(location),
    );

    ref.handleEvent(
      propertyListEventVMProvider.select((state) => state.registerId),
      consume: () => ref.read(propertyListEventVMProvider.notifier).action(
            const PropertyListEventAction.clearRegistration(),
          ),
      onEvent: (registerId) => showAppToast(
        context,
        const AppToastViewState(type: AppToastType.check, text: '매물이 등록되었습니다.'),
        onTap: () => PropertyDetailRoute(id: registerId).push(context),
      ),
    );

    final state = ref.watch(propertyListVMProvider);

    if (context.isMobile) {
      return _mobileScreen(context, ref, state);
    } else {
      return _desktopScreen(context, ref, state);
    }
  }

  Widget _mobileScreen(BuildContext context, WidgetRef ref, PropertyListViewState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 0,
      children: [
        _homeBanner(state),
        Expanded(
          child: _contents(
            ref,
            state,
            listTopPadding: 20,
            onItemTap: (id) => PropertyDetailRoute(id: id).push(context),
          ),
        ),
      ],
    );
  }

  Widget _desktopScreen(BuildContext context, WidgetRef ref, PropertyListViewState state) {
    final list = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 0,
      children: [
        _homeBanner(state),
        Expanded(
          child: _contents(
            ref,
            state,
            listTopPadding: 16,
            onItemTap: (id) => ref.read(propertyListVMProvider.notifier).action(PropertyListAction.selectItem(id)),
            onItemDetailTap: (id) => PropertyDetailRoute(id: id).push(context),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final panelWidth = constraints.maxWidth - 360;

        return TweenAnimationBuilder<double>(
          tween: Tween(end: state.selectId != null ? 1 : 0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: list,
          builder: (context, progress, child) => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: constraints.maxWidth - panelWidth * progress, child: child),
              if (progress > 0)
                Expanded(
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      minWidth: panelWidth,
                      maxWidth: panelWidth,
                      child: _previewPanel(ref, state),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _previewPanel(WidgetRef ref, PropertyListViewState state) {
    return _PreviewSlot(
      selectId: state.selectId,
      preview: state.preview,
      media: state.media,
      onMediaChange: (media) => ref.read(propertyListVMProvider.notifier).action(PropertyListAction.changeMedia(media)),
    );
  }

  Widget _homeBanner(PropertyListViewState state) {
    return _HomeBanner(status: state.bndStatus, isOpen: state.status == PropertySearchStatus.open);
  }

  Widget _contents(
    WidgetRef ref,
    PropertyListViewState state, {
    required double listTopPadding,
    required ValueChanged<String> onItemTap,
    ValueChanged<String>? onItemDetailTap,
  }) {
    final viewModel = ref.read(propertyListVMProvider.notifier);

    return PropertySearchOverlay(
      isVisible: state.status == PropertySearchStatus.open,
      onDismiss: () => viewModel.action(const PropertyListAction.panel(false)),
      searchResults: [
        for (final item in state.searchResults)
          PropertySearchResultItem(
            viewState: item,
            query: state.query,
            onTap: () => viewModel.action(PropertyListAction.select(item.id)),
          ),
      ],
      filterPanel: PropertyFilterPanel(
        data: state.filter,
        onFilter: (data) => viewModel.action(PropertyListAction.filtering(data)),
        onCollapse: () => viewModel.action(const PropertyListAction.panel(false)),
      ),
      child: Scaffold(
        primary: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            PropertyFilterTags(
              query: state.query,
              filter: state.filter,
              onFilter: (data) => viewModel.action(PropertyListAction.filtering(data)),
              onClearQuery: () => viewModel.action(const PropertyListAction.search('')),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: listTopPadding, bottom: 20),
                itemCount: state.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) => PropertyListItem(
                  viewState: state.items[index],
                  onTap: () => onItemTap(state.items[index].id),
                  onDetailTap: onItemDetailTap == null ? null : () => onItemDetailTap(state.items[index].id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _PreviewSlot extends StatefulWidget {
  final String? selectId;
  final PropertyPreviewViewState? preview;
  final PropertyPreviewMedia media;
  final ValueChanged<PropertyPreviewMedia> onMediaChange;

  const _PreviewSlot({
    required this.selectId,
    required this.preview,
    required this.media,
    required this.onMediaChange,
  });

  @override
  State<_PreviewSlot> createState() => _PreviewSlotState();
}

class _PreviewSlotState extends State<_PreviewSlot> {
  String? _selectId;
  PropertyPreviewViewState? _preview;

  @override
  void initState() {
    super.initState();
    _remember();
  }

  @override
  void didUpdateWidget(covariant _PreviewSlot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _remember();
  }

  void _remember() {
    if (widget.preview == null) { return; }

    _selectId = widget.selectId;
    _preview = widget.preview;
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;

    if (preview == null) { return const SizedBox.shrink(); }

    return PropertyPreviewPanel(
      key: ValueKey(_selectId),
      viewState: preview,
      media: widget.media,
      onMediaChange: widget.onMediaChange,
    );
  }
}

class _HomeBanner extends ConsumerStatefulWidget {
  final AppBndSearchStatus status;
  final bool isOpen;

  const _HomeBanner({required this.status, required this.isOpen});

  @override
  ConsumerState<_HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends ConsumerState<_HomeBanner> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(propertyListVMProvider.notifier);

    ref.listen(propertyListVMProvider.select((state) => state.query), (_, query) {
      if (_controller.text != query) { _controller.text = query; }
    });

    ref.listen(propertyListVMProvider.select((state) => state.status), (previous, status) {
      if (previous == PropertySearchStatus.open && status != PropertySearchStatus.open) { FocusManager.instance.primaryFocus?.unfocus(); }
    });

    return AppBndSearch(
      viewState: AppBndSearchViewState(status: widget.status, placeholder: '매물 찾기'),
      controller: _controller,
      onChange: (query) => vm.action(PropertyListAction.search(query)),
      onFocus: (hasFocus) {
        if (hasFocus) { vm.action(const PropertyListAction.panel(true)); }
      },
      onSearchTap: () => vm.action(PropertyListAction.panel(!widget.isOpen)),
    );
  }
}
