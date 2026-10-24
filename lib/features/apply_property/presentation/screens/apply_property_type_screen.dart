import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_type_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class ApplyPropertyTypeScreen extends ConsumerStatefulWidget {
  const ApplyPropertyTypeScreen({super.key});

  @override
  ConsumerState<ApplyPropertyTypeScreen> createState() => _ApplyPropertyTypeScreenState();
}

class _ApplyPropertyTypeScreenState extends ConsumerState<ApplyPropertyTypeScreen> {
  final Map<ApplyPropertyPriceField, FocusNode> _focusNodes = {
    for (final field in ApplyPropertyPriceField.values) field: FocusNode(),
  };

  ApplyPropertyTypeVM get _viewModel => ref.read(applyPropertyTypeVMProvider.notifier);

  @override
  void initState() {
    super.initState();

    for (final MapEntry(key: field, value: node) in _focusNodes.entries) {
      node.addListener(() => _onFocus(field, node.hasFocus));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreFocus());
  }

  /// provider가 화면보다 오래 유지되므로 다시 들어왔을 때 입력 중이던 칸에 포커스를 되돌림
  void _restoreFocus() {
    final field = ref.read(applyPropertyTypeVMProvider).editingField;

    if (field != null) { _focusNodes[field]?.requestFocus(); }
  }

  @override
  void dispose() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _onFocus(ApplyPropertyPriceField field, bool hasFocus) {
    if (hasFocus) { return _viewModel.action(ApplyPropertyTypeAction.edit(field)); }
    if (_focusNodes.values.any((node) => node.hasFocus)) { return; }

    _viewModel.action(const ApplyPropertyTypeAction.edit(null));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyTypeVMProvider);
    final viewModel = ref.read(applyPropertyTypeVMProvider.notifier);
    final editingField = state.editingField;

    ref.handleEvent(
      applyPropertyTypeVMProvider.select((state) => state.navigateTo),
      consume: viewModel.popNavigation,
      onEvent: (location) => context.push(location),
    );

    ref.listen(applyPropertyTypeVMProvider.select((state) => state.editingField), (_, field) {
      for (final MapEntry(key: nodeField, value: node) in _focusNodes.entries) {
        if (nodeField == field && !node.hasFocus) { node.requestFocus(); }
        if (field == null && node.hasFocus) { node.unfocus(); }
      }
    });

    return AppScaffold(
      title: '매물 등록',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 40,
                children: [
                  _title(),
                  _transaction(state, viewModel),
                  _propertyType(state, viewModel),
                  _price(state, viewModel),
                ],
              ),
            ),
          ),
          PriceKeypad.animated(
            keypad: editingField == null ? null : _keypad(state, viewModel, editingField),
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

  PriceKeypad _keypad(ApplyPropertyTypeViewState state, ApplyPropertyTypeVM viewModel, ApplyPropertyPriceField field) {
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
