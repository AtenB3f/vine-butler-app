import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class ApplyPropertyContent extends ConsumerStatefulWidget {
  final ValueChanged<GlobalKey?> onFocusedKeyChange;

  const ApplyPropertyContent({super.key, required this.onFocusedKeyChange});

  static PriceKeypad? keypad(ApplyPropertyTypeViewState state, ApplyPropertyTypeVM viewModel) {
    final field = state.editingField;

    if (field == null) { return null; }

    final amount = switch (field) {
      ApplyPropertyPriceField.price => state.price,
      ApplyPropertyPriceField.monthlyRent => state.monthlyRent,
      ApplyPropertyPriceField.maintenanceCost => state.maintenanceCost,
    };

    return PriceKeypad(
      key: ValueKey(field),
      viewState: PriceKeypadViewState(value: amount.toInt()),
      onChanged: (value) => viewModel.action(switch (field) {
        ApplyPropertyPriceField.price => ApplyPropertyTypeAction.changePrice(value.toDouble()),
        ApplyPropertyPriceField.monthlyRent => ApplyPropertyTypeAction.changeMonthlyRent(value.toDouble()),
        ApplyPropertyPriceField.maintenanceCost => ApplyPropertyTypeAction.changeMaintenanceCost(value.toDouble()),
      }),
      onConfirm: () => viewModel.action(const ApplyPropertyTypeAction.nextField()),
    );
  }

  @override
  ConsumerState<ApplyPropertyContent> createState() => _ApplyPropertyContentState();
}

class _ApplyPropertyContentState extends ConsumerState<ApplyPropertyContent> {
  final Map<ApplyPropertyPriceField, FocusNode> _focusNodes = {
    for (final field in ApplyPropertyPriceField.values) field: FocusNode(),
  };
  final Map<ApplyPropertyPriceField, GlobalKey> _fieldKeys = {
    for (final field in ApplyPropertyPriceField.values) field: GlobalKey(),
  };

  ApplyPropertyTypeVM get _viewModel => ref.read(applyPropertyTypeVMProvider.notifier);

  @override
  void initState() {
    super.initState();

    for (final MapEntry(key: field, value: node) in _focusNodes.entries) {
      node.addListener(() => _onFocus(field, node.hasFocus));
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _onFocus(ApplyPropertyPriceField field, bool hasFocus) {
    if (hasFocus) {
      widget.onFocusedKeyChange(_fieldKeys[field]);
      _viewModel.action(ApplyPropertyTypeAction.edit(field));
      return;
    }
    if (_focusNodes.values.any((node) => node.hasFocus)) { return; }

    widget.onFocusedKeyChange(null);
    _viewModel.action(const ApplyPropertyTypeAction.edit(null));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyTypeVMProvider);
    final viewModel = ref.read(applyPropertyTypeVMProvider.notifier);

    ref.listen(applyPropertyTypeVMProvider.select((state) => state.editingField), (_, field) {
      for (final MapEntry(key: nodeField, value: node) in _focusNodes.entries) {
        if (nodeField == field && !node.hasFocus) { node.requestFocus(); }
        if (field == null && node.hasFocus) { node.unfocus(); }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        _transaction(state, viewModel),
        _propertyType(state, viewModel),
        _price(state, viewModel),
      ],
    );
  }

  Widget _transaction(ApplyPropertyTypeViewState state, ApplyPropertyTypeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.bold1.text('거래 유형', TextColor.medium),
        Row(
          spacing: 6,
          children: [
            for (final type in ApplyPropertyTypeVM.transactionTypeOptions)
              Expanded(
                child: OutlineButton(
                  type: state.transactionType == type ? type.buttonType : OutlineButtonType.gray,
                  size: BoxButtonSize.large,
                  text: type.label,
                  onTap: () => viewModel.action(ApplyPropertyTypeAction.selectTransactionType(type)),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _propertyType(ApplyPropertyTypeViewState state, ApplyPropertyTypeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.bold1.text('건물 유형', TextColor.medium),
        Column(
          spacing: 6,
          children: [
            for (final row in ApplyPropertyTypeVM.propertyTypeOptions)
              Row(
                spacing: 6,
                children: [
                  for (final option in row)
                    Expanded(
                      child: FillButton(
                        type: state.propertyType == option ? FillButtonType.light : FillButtonType.gray,
                        size: BoxButtonSize.medium,
                        text: option.label,
                        onTap: () => viewModel.action(ApplyPropertyTypeAction.selectPropertyType(option)),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _price(ApplyPropertyTypeViewState state, ApplyPropertyTypeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        _amountField(
          state: state,
          field: ApplyPropertyPriceField.price,
          title: state.priceLabel,
          amount: state.price,
          onClear: () => viewModel.action(const ApplyPropertyTypeAction.changePrice(0)),
        ),
        if (state.isMonthlyRentVisible)
          _amountField(
            state: state,
            field: ApplyPropertyPriceField.monthlyRent,
            title: '월세',
            amount: state.monthlyRent,
            onClear: () => viewModel.action(const ApplyPropertyTypeAction.changeMonthlyRent(0)),
          ),
        _amountField(
          state: state,
          field: ApplyPropertyPriceField.maintenanceCost,
          title: '관리비',
          amount: state.maintenanceCost,
          zeroText: '관리비 없음',
          onClear: () => viewModel.action(const ApplyPropertyTypeAction.changeMaintenanceCost(0)),
        ),
      ],
    );
  }

  Widget _amountField({
    required ApplyPropertyTypeViewState state,
    required ApplyPropertyPriceField field,
    required String title,
    required double amount,
    required VoidCallback onClear,
    String? zeroText,
  }) {
    final focusNode = _focusNodes[field]!;

    return Column(
      key: _fieldKeys[field],
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.bold1.text(title, TextColor.medium),
        Focus(
          focusNode: focusNode,
          child: PriceField(
            viewState: PriceFieldViewState(
              text: amount == 0 ? zeroText ?? amount.formattedKRW : amount.formattedKRW,
              subText: amount == 0 ? null : '${amount.formattedNumber}원',
              isFocused: state.editingField == field,
            ),
            onTap: focusNode.requestFocus,
            onClear: onClear,
          ),
        ),
      ],
    );
  }
}
