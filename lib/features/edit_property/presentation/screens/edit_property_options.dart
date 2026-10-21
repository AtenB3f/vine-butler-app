import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_extra_vm.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class EditPropertyOptions extends ConsumerStatefulWidget {
  final String id;
  final void Function(GlobalKey key, bool hasFocus) onFocus;

  const EditPropertyOptions({super.key, required this.id, required this.onFocus});

  @override
  ConsumerState<EditPropertyOptions> createState() => _EditPropertyOptionsState();
}

class _EditPropertyOptionsState extends ConsumerState<EditPropertyOptions> {
  late final TextEditingController _memoController;
  final GlobalKey _memoKey = GlobalKey();

  EditPropertyVM get _viewModel => ref.read(editPropertyVMProvider(widget.id).notifier);

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: ref.read(editPropertyVMProvider(widget.id)).memo);
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editPropertyVMProvider(widget.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        _group('입주 가능일', _moveInDate(state)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            _group(
              '융자',
              _binaryButtons(
                trueText: '융자 있음',
                falseText: '융자 없음',
                value: state.hasLoan,
                onSelect: (value) => _viewModel.action(EditPropertyAction.selectLoan(value)),
              ),
            ),
            _group(
              '주차',
              _binaryButtons(
                trueText: '주차 가능',
                falseText: '주차 불가능',
                value: state.isParkingAvailable,
                onSelect: (value) => _viewModel.action(EditPropertyAction.selectParking(value)),
              ),
            ),
            _group(
              '전세보증보험',
              _binaryButtons(
                trueText: '가입 가능',
                falseText: '가입 불가능',
                value: state.isSuretyInsuranceAvailable,
                onSelect: (value) => _viewModel.action(EditPropertyAction.selectSuretyInsurance(value)),
              ),
            ),
          ],
        ),
        _group('방 개수', _roomCount(state)),
        _group('가구 옵션', _furnitures(state)),
        AppTextField(
          key: _memoKey,
          viewState: const AppTextFieldViewState(
            status: AppTextFieldStatus.normal,
            title: '메모',
            placeholder: '추가 정보를 입력하세요.',
          ),
          controller: _memoController,
          onChange: (memo) => _viewModel.action(EditPropertyAction.changeMemo(memo)),
          onFocus: (hasFocus) => widget.onFocus(_memoKey, hasFocus),
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

  Future<void> _pickMoveInDate(EditPropertyViewState state) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = state.moveInDate ?? today;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(today) ? today : initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 5, today.month, today.day),
    );

    if (date != null) { _viewModel.action(EditPropertyAction.changeMoveInDate(date)); }
  }

  Widget _moveInDate(EditPropertyViewState state) {
    final moveInDate = state.moveInDate;

    return Row(
      spacing: 6,
      children: [
        Expanded(
          child: Pressable(
            onTap: () => _pickMoveInDate(state),
            child: Row(
              spacing: 6,
              children: [
                AppIcons.calendarMD(TextColor.dark),
                Expanded(
                  child: AppFontStyle.bold3.text(
                    formatMoveInDate(moveInDate),
                    TextColor.dark,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppToggleCheck(
          viewState: AppToggleCheckViewState(
            status: state.isFlexibleMoveInDate ? AppToggleCheckStatus.on : AppToggleCheckStatus.off,
            text: '협의 가능',
          ),
          onTap: () => _viewModel.action(const EditPropertyAction.toggleFlexibleMoveInDate()),
        ),
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

  Widget _roomCount(EditPropertyViewState state) {
    return Row(
      spacing: 8,
      children: [
        for (final count in ApplyPropertyExtraVM.roomCountOptions)
          _chip(
            text: '$count개',
            isSelected: state.roomCount == count,
            onTap: () => _viewModel.action(EditPropertyAction.selectRoomCount(count)),
          ),
      ],
    );
  }

  Widget _furnitures(EditPropertyViewState state) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: [
        for (final option in ApplyPropertyExtraVM.furnitureOptions)
          _chip(
            text: option,
            isSelected: state.furnitureOptions.contains(option),
            onTap: () => _viewModel.action(EditPropertyAction.toggleFurniture(option)),
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
}
