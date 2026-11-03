import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';
import 'package:vine_butler/features/apply_property/presentation/screens/apply_property_content.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class ApplyPropertyTypeScreen extends ConsumerStatefulWidget {
  const ApplyPropertyTypeScreen({super.key});

  @override
  ConsumerState<ApplyPropertyTypeScreen> createState() => _ApplyPropertyTypeScreenState();
}

class _ApplyPropertyTypeScreenState extends ConsumerState<ApplyPropertyTypeScreen> {
  GlobalKey? _focusedKey;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyTypeVMProvider);
    final viewModel = ref.read(applyPropertyTypeVMProvider.notifier);

    ref.handleEvent(
      applyPropertyTypeVMProvider.select((state) => state.navigateTo),
      consume: viewModel.popNavigation,
      onEvent: (location) => context.push(location),
    );

    return AppScaffold(
      title: '매물 등록',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: Column(
        children: [
          Expanded(
            child: AppKeyboardScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              focusedKey: _focusedKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 40,
                children: [
                  _title(),
                  ApplyPropertyContent(onFocusedKeyChange: (key) => setState(() => _focusedKey = key)),
                ],
              ),
            ),
          ),
          PriceKeypad.animated(
            keypad: ApplyPropertyContent.keypad(state, viewModel),
            placeholder: _nextButton(state, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: AppFontStyle.header1.text('이 집을 맡길게요.', TextColor.dark),
    );
  }

  Widget _nextButton(ApplyPropertyTypeViewState state, ApplyPropertyTypeVM viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: FillButton(
        type: state.isCompleted ? FillButtonType.medium : FillButtonType.gray,
        size: BoxButtonSize.large,
        text: '다음',
        onTap: () => viewModel.action(const ApplyPropertyTypeAction.next()),
      ),
    );
  }
}
