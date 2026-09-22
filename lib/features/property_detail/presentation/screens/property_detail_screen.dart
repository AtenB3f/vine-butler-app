import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';

class PropertyDetailScreen extends ConsumerWidget {
  final int id;

  const PropertyDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PropertyDetailViewState>(propertyDetailVMProvider, (previous, next) {
      final navigateTo = next.navigateTo;
      if (navigateTo != null) {
        context.push(navigateTo);
        ref.read(propertyDetailVMProvider.notifier).popNavigation();
      }
    });

    if (context.isMobile) {
      return _mobileScreen(context, ref);
    } else {
      return _desktopScreen(context, ref);
    }
  }

  AppScaffold _mobileScreen(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.editMD,
      onLeftTap: () => context.pop(),
      onRightTap: () => context.pop(),
      body: const Center(
        child: Text('FindProperty'),
      ),
    );
  }

  AppScaffold _desktopScreen(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: '매물 찾기',
      leftIcon: AppIcons.chevronLeftMD,
      rightIcon: AppIcons.editMD,
      onLeftTap: () => context.pop(),
      onRightTap: () => context.pop(),
      body: const Center(
        child: Text('FindProperty'),
      ),
    );
  }
}