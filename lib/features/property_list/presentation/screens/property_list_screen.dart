import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_panel.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_list_item.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_search_result_item.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';

class PropertyListScreen extends ConsumerWidget {
  static const Duration _duration = Duration(milliseconds: 250);
  static const Curve _curve = Curves.easeInOut;

  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PropertyListViewState>(propertyListVMProvider, (previous, next) {
      final navigateTo = next.navigateTo;
      if (navigateTo != null) {
        context.push(navigateTo);
        ref.read(propertyListVMProvider.notifier).popNavigation();
      }
    });

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
        Expanded(child: _contents(context, ref, state)),
      ],
    );
  }

  Widget _desktopScreen(BuildContext context, WidgetRef ref, PropertyListViewState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 0,
      children: [
        _homeBanner(state),
        Expanded(child: _contents(context, ref, state)),
      ],
    );
  }

  Widget _homeBanner(PropertyListViewState state) {
    return _HomeBanner(status: state.bndStatus, isFilterOpen: state.filter.isFilterOpen);
  }

  Widget _contents(BuildContext context, WidgetRef ref, PropertyListViewState state) {
    return Stack(
      children: [
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView.separated(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: state.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => PropertyListItem(
                viewState: state.items[index],
                onTap: () => PropertyDetailRoute(id: state.items[index].id).push(context),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !state.isOverlayVisible,
            child: AnimatedOpacity(
              duration: _duration,
              curve: _curve,
              opacity: state.isOverlayVisible ? 1 : 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _dismissOverlay(ref),
                child: const ColoredBox(color: StateColor.overlay),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AnimatedSwitcher(
            duration: _duration,
            switchInCurve: _curve,
            switchOutCurve: _curve,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.topCenter,
              children: [...previousChildren, ?currentChild],
            ),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
            child: state.isOverlayVisible
                ? KeyedSubtree(key: const ValueKey('overlayPanel'), child: _overlayPanel(ref, state))
                : const SizedBox.shrink(key: ValueKey('emptyPanel')),
          ),
        ),
      ],
    );
  }

  Widget _overlayPanel(WidgetRef ref, PropertyListViewState state) {
    final vm = ref.read(propertyListVMProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.bottom],
      ),
      child: AnimatedSize(
        duration: _duration,
        curve: _curve,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isSearchResultVisible) _searchResults(ref, state),
            if (state.filter.isFilterOpen) PropertyFilterPanel(viewModel: vm),
          ],
        ),
      ),
    );
  }

  Widget _searchResults(WidgetRef ref, PropertyListViewState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: StateColor.white,
        border: Border(bottom: BorderSide(color: BaseColor.light)),
      ),
      child: Column(
        children: [
          for (final item in state.searchResults)
            PropertySearchResultItem(
              viewState: item,
              query: state.query,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                ref.read(propertyListVMProvider.notifier).action(SelectSearchResult(item.id));
              },
            ),
        ],
      ),
    );
  }

  void _dismissOverlay(WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();
    ref.read(propertyListVMProvider.notifier).action(const PushFilter(false));
  }
}

class _HomeBanner extends ConsumerStatefulWidget {
  final AppBndSearchStatus status;
  final bool isFilterOpen;

  const _HomeBanner({required this.status, required this.isFilterOpen});

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

    return AppBndSearch(
      viewState: AppBndSearchViewState(status: widget.status, placeholder: '매물 찾기'),
      controller: _controller,
      onChanged: (query) => vm.action(Search(query)),
      onFocusChanged: (hasFocus) => vm.action(ChangeFocus(hasFocus)),
      onSearchTap: () => vm.action(PushFilter(!widget.isFilterOpen)),
    );
  }
}
