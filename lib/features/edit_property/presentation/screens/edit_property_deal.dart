import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class EditPropertyDeal extends ConsumerStatefulWidget {
  final String id;
  final void Function(GlobalKey key, bool hasFocus) onFocus;

  const EditPropertyDeal({super.key, required this.id, required this.onFocus});

  @override
  ConsumerState<EditPropertyDeal> createState() => _EditPropertyDealState();
}

class _EditPropertyDealState extends ConsumerState<EditPropertyDeal> {
  final Map<EditPropertyPriceField, FocusNode> _focusNodes = {
    for (final field in EditPropertyPriceField.values) field: FocusNode(),
  };
  final Map<EditPropertyPriceField, GlobalKey> _fieldKeys = {
    for (final field in EditPropertyPriceField.values) field: GlobalKey(),
  };

  EditPropertyVM get _viewModel => ref.read(editPropertyVMProvider(widget.id).notifier);

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

  void _onFocus(EditPropertyPriceField field, bool hasFocus) {
    widget.onFocus(_fieldKeys[field]!, hasFocus);

    if (hasFocus) { return _viewModel.action(EditPropertyAction.edit(field)); }
    if (_focusNodes.values.any((node) => node.hasFocus)) { return; }

    _viewModel.action(const EditPropertyAction.edit(null));
  }

  @override
  Widget build(BuildContext context) {
    final provider = editPropertyVMProvider(widget.id);
    final state = ref.watch(provider);

    ref.listen(provider.select((state) => state.editingField), (_, field) {
      for (final MapEntry(key: nodeField, value: node) in _focusNodes.entries) {
        if (nodeField == field && !node.hasFocus) { node.requestFocus(); }
        if (field == null && node.hasFocus) { node.unfocus(); }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        _group('거래 유형', _transaction(state)),
        _prices(state),
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

  Widget _transaction(EditPropertyViewState state) {
    return Row(
      spacing: 6,
      children: [
        for (final type in const [PropertyTransactionType.buy, PropertyTransactionType.depositOnly, PropertyTransactionType.rent])
          Expanded(
            child: OutlineButton(
              type: state.transactionType == type ? type.buttonType : OutlineButtonType.gray,
              size: BoxButtonSize.large,
              text: type.label,
              onTap: () => _viewModel.action(EditPropertyAction.selectTransactionType(type)),
            ),
          ),
      ],
    );
  }

  Widget _prices(EditPropertyViewState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        _amountField(
          state: state,
          field: EditPropertyPriceField.price,
          title: state.priceLabel,
          amount: state.price,
          onClear: () => _viewModel.action(const EditPropertyAction.changePrice(0)),
        ),
        if (state.isMonthlyRentVisible)
          _amountField(
            state: state,
            field: EditPropertyPriceField.monthlyRent,
            title: '월세',
            amount: state.monthlyRent,
            onClear: () => _viewModel.action(const EditPropertyAction.changeMonthlyRent(0)),
          ),
        _amountField(
          state: state,
          field: EditPropertyPriceField.maintenanceCost,
          title: '관리비',
          amount: state.maintenanceCost,
          zeroText: '관리비 없음',
          onClear: () => _viewModel.action(const EditPropertyAction.changeMaintenanceCost(0)),
        ),
      ],
    );
  }

  Widget _amountField({
    required EditPropertyViewState state,
    required EditPropertyPriceField field,
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
