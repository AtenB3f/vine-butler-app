import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/features/apply_property/presentation/screens/apply_property_address_detail.dart';
import 'package:vine_butler/features/apply_property/presentation/screens/apply_property_address_input.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class ApplyPropertyAddressScreen extends ConsumerWidget {
  const ApplyPropertyAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applyPropertyAddressVMProvider);
    final viewModel = ref.read(applyPropertyAddressVMProvider.notifier);

    // 네비게이션
    ref.handleEvent(
      applyPropertyAddressVMProvider.select((state) => state.navigateTo),
      consume: viewModel.popNavigation,
      onEvent: (location) => context.push(location),
    );

    // 에러 토스트
    ref.handleEvent(
      applyPropertyAddressVMProvider.select((state) => state.errorMessage),
      consume: () => viewModel.action(const ApplyPropertyAddressAction.clearError()),
      onEvent: (message) => showAppToast(
        context,
        AppToastViewState(type: AppToastType.warning, text: message, hasLink: false),
      ),
    );

    ref.listen(applyPropertyAddressVMProvider.select((state) => state.selected), (_, selected) {
      if (selected != null) { FocusManager.instance.primaryFocus?.unfocus(); }
    });

    return AppScaffold(
      title: '매물 등록',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: Column(
        children: [
          Expanded(
            child: state.isMapVisible ? const ApplyPropertyAddressDetail() : const ApplyPropertyAddressInput(),
          ),
          _buttons(state, viewModel),
        ],
      ),
    );
  }

  Widget _buttons(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: Column(
        spacing: 6,
        children: [
          if (state.isMapVisible)
            FillButton(
              type: FillButtonType.gray,
              size: BoxButtonSize.large,
              text: '다시 입력',
              onTap: () => viewModel.action(const ApplyPropertyAddressAction.reset()),
            ),
          FillButton(
            type: state.canProceed ? FillButtonType.medium : FillButtonType.gray,
            size: BoxButtonSize.large,
            text: '다음',
            onTap: () => viewModel.action(const ApplyPropertyAddressAction.next()),
          ),
        ],
      ),
    );
  }
}
