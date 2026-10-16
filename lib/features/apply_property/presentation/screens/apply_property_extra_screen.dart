import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_extra_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_extra_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class ApplyPropertyExtraScreen extends ConsumerStatefulWidget {
  const ApplyPropertyExtraScreen({super.key});

  @override
  ConsumerState<ApplyPropertyExtraScreen> createState() => _ApplyPropertyExtraScreenState();
}

class _ApplyPropertyExtraScreenState extends ConsumerState<ApplyPropertyExtraScreen> {
  late final TextEditingController _memoController =
      TextEditingController(text: ref.read(applyPropertyExtraVMProvider).memo);
  final GlobalKey _memoKey = GlobalKey();
  GlobalKey? _focusedKey;

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickMoveInDate(ApplyPropertyExtraViewState state, ApplyPropertyExtraVM viewModel) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = await showDatePicker(
      context: context,
      initialDate: state.moveInDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 5, today.month, today.day),
    );

    if (date != null) { viewModel.action(ApplyPropertyExtraAction.changeMoveInDate(date)); }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyExtraVMProvider);
    final viewModel = ref.read(applyPropertyExtraVMProvider.notifier);

    ref.handleEvent(
      applyPropertyExtraVMProvider.select((state) => state.navigateTo),
      consume: () => viewModel.action(const ApplyPropertyExtraAction.popNavigation()),
      onEvent: (location) => context.go(location),
    );

    ref.handleEvent(
      applyPropertyExtraVMProvider.select((state) => state.errorMessage),
      consume: () => viewModel.action(const ApplyPropertyExtraAction.clearError()),
      onEvent: (message) => showAppToast(
        context,
        AppToastViewState(type: AppToastType.warning, text: message, hasLink: false),
      ),
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
                  _fields(state, viewModel),
                ],
              ),
            ),
          ),
          _saveButton(viewModel),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: AppFontStyle.header1.text('추가 정보를 입력해주세요.', TextColor.dark),
    );
  }

  Widget _fields(ApplyPropertyExtraViewState state, ApplyPropertyExtraVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            _group(
              '전세보증보험',
              _binaryButtons(
                trueText: '가입 가능',
                falseText: '가입 불가능',
                value: state.isAvailableSuretyInsurance,
                onSelect: (value) => viewModel.action(ApplyPropertyExtraAction.selectSuretyInsurance(value)),
              ),
            ),
            _group(
              '융자',
              _binaryButtons(
                trueText: '융자 있음',
                falseText: '융자 없음',
                value: state.hasLoan,
                onSelect: (value) => viewModel.action(ApplyPropertyExtraAction.selectLoan(value)),
              ),
            ),
            _group(
              '주차',
              _binaryButtons(
                trueText: '주차 가능',
                falseText: '주차 불가능',
                value: state.isAvailableParking,
                onSelect: (value) => viewModel.action(ApplyPropertyExtraAction.selectParking(value)),
              ),
            ),
          ],
        ),
        _group('입주 가능일', _moveInDate(state, viewModel)),
        _group('방 개수', _roomCount(state, viewModel)),
        _group('가구 옵션', _furnitures(state, viewModel)),
        AppTextField(
          key: _memoKey,
          viewState: const AppTextFieldViewState(
            status: AppTextFieldStatus.normal,
            title: '메모',
            placeholder: '추가 정보를 입력하세요.',
          ),
          controller: _memoController,
          onChange: (memo) => viewModel.action(ApplyPropertyExtraAction.changeMemo(memo)),
          onFocus: (hasFocus) => setState(() => _focusedKey = hasFocus ? _memoKey : null),
        ),
      ],
    );
  }

  Widget _group(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.bold1.text(title, TextColor.medium),
        SizedBox(width: double.infinity, child: child),
      ],
    );
  }

  Widget _binaryButtons({
    required String trueText,
    required String falseText,
    required bool? value,
    required ValueChanged<bool> onSelect,
  }) {
    return Row(
      spacing: 6,
      children: [
        Expanded(
          child: FillButton(
            type: value == true ? FillButtonType.medium : FillButtonType.gray,
            size: BoxButtonSize.small,
            text: trueText,
            onTap: () => onSelect(true),
          ),
        ),
        Expanded(
          child: FillButton(
            type: value == false ? FillButtonType.medium : FillButtonType.gray,
            size: BoxButtonSize.small,
            text: falseText,
            onTap: () => onSelect(false),
          ),
        ),
      ],
    );
  }

  Widget _moveInDate(ApplyPropertyExtraViewState state, ApplyPropertyExtraVM viewModel) {
    final moveInDate = state.moveInDate;

    return Row(
      spacing: 6,
      children: [
        Expanded(
          child: Pressable(
            onTap: () => _pickMoveInDate(state, viewModel),
            child: Row(
              spacing: 6,
              children: [
                AppIcons.calendarMD(TextColor.dark),
                Expanded(
                  child: AppFontStyle.bold3.text(
                    moveInDate == null ? '즉시 입주' : '${formatDate(moveInDate)} 이후',
                    TextColor.dark,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppToggleCheck(
          viewState: AppToggleCheckViewState(
            status: state.isMoveInDateNegotiable ? AppToggleCheckStatus.on : AppToggleCheckStatus.off,
            text: '협의 가능',
          ),
          onTap: () => viewModel.action(const ApplyPropertyExtraAction.toggleNegotiable()),
        ),
      ],
    );
  }

  Widget _roomCount(ApplyPropertyExtraViewState state, ApplyPropertyExtraVM viewModel) {
    return Row(
      spacing: 8,
      children: [
        for (final count in ApplyPropertyExtraVM.roomCountOptions)
          _chip(
            text: '$count개',
            isSelected: state.roomCount == count,
            onTap: () => viewModel.action(ApplyPropertyExtraAction.selectRoomCount(count)),
          ),
      ],
    );
  }

  Widget _furnitures(ApplyPropertyExtraViewState state, ApplyPropertyExtraVM viewModel) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: [
        for (final option in ApplyPropertyExtraVM.furnitureOptions)
          _chip(
            text: option,
            isSelected: state.furnitureOptions.contains(option),
            onTap: () => viewModel.action(ApplyPropertyExtraAction.toggleFurniture(option)),
          ),
      ],
    );
  }

  Widget _chip({required String text, required bool isSelected, required VoidCallback onTap}) {
    return IntrinsicWidth(
      child: OutlineButton(
        type: isSelected ? OutlineButtonType.main : OutlineButtonType.gray,
        size: BoxButtonSize.medium,
        text: text,
        onTap: onTap,
      ),
    );
  }

  Widget _saveButton(ApplyPropertyExtraVM viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: FillButton(
        type: FillButtonType.medium,
        size: BoxButtonSize.large,
        text: '저장',
        onTap: () => viewModel.action(const ApplyPropertyExtraAction.save()),
      ),
    );
  }
}
