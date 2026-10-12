import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_owner_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_owner_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class ApplyPropertyOwnerScreen extends ConsumerStatefulWidget {
  const ApplyPropertyOwnerScreen({super.key});

  @override
  ConsumerState<ApplyPropertyOwnerScreen> createState() => _ApplyPropertyOwnerScreenState();
}

class _ApplyPropertyOwnerScreenState extends ConsumerState<ApplyPropertyOwnerScreen> {
  late final TextEditingController _nameController =
      TextEditingController(text: ref.read(applyPropertyOwnerVMProvider).name);
  late final PhoneNumberEditingController _phoneController =
      PhoneNumberEditingController(text: ref.read(applyPropertyOwnerVMProvider).phone);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyOwnerVMProvider);
    final viewModel = ref.read(applyPropertyOwnerVMProvider.notifier);

    ref.handleEvent(
      applyPropertyOwnerVMProvider.select((state) => state.navigateTo),
      consume: () => viewModel.action(const ApplyPropertyOwnerAction.popNavigation()),
      onEvent: (location) => context.push(location),
    );

    return AppScaffold(
      title: '매물 등록',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 40,
                children: [
                  _title(),
                  _fields(viewModel),
                ],
              ),
            ),
          ),
          _nextButton(state, viewModel),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 16),
      child: AppFontStyle.header1.text('성함과 휴대폰 번호를\n알려주세요.', TextColor.dark),
    );
  }

  Widget _fields(ApplyPropertyOwnerVM viewModel) {
    return Column(
      spacing: 16,
      children: [
        AppTextField(
          viewState: const AppTextFieldViewState(
            status: AppTextFieldStatus.normal,
            title: '이름',
            placeholder: '이름을 입력하세요.',
          ),
          controller: _nameController,
          onChanged: (name) => viewModel.action(ApplyPropertyOwnerAction.changeName(name)),
        ),
        AppTextField(
          viewState: const AppTextFieldViewState(
            status: AppTextFieldStatus.normal,
            title: '전화번호',
            placeholder: '숫자만 입력해주세요.',
            keyboardType: AppTextFieldKeyboardType.number,
          ),
          controller: _phoneController,
          onChanged: (phone) => viewModel.action(ApplyPropertyOwnerAction.changePhone(phone)),
        ),
      ],
    );
  }

  Widget _nextButton(ApplyPropertyOwnerViewState state, ApplyPropertyOwnerVM viewModel) {
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
        onTap: () => viewModel.action(const ApplyPropertyOwnerAction.next()),
      ),
    );
  }
}
