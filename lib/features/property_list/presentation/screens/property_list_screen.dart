import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_panel.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_list_item.dart';
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
    return _HomeBanner(status: state.bndStatus, isOpen: state.status == PropertySearchStatus.open);
  }

  Widget _contents(BuildContext context, WidgetRef ref, PropertyListViewState state) {
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
