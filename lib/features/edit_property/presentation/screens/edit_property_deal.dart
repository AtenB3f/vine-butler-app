import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class EditPropertyDeal extends ConsumerStatefulWidget {
  final String id;

  const EditPropertyDeal({super.key, required this.id});

  @override
  ConsumerState<EditPropertyDeal> createState() => _EditPropertyDealState();
}

class _EditPropertyDealState extends ConsumerState<EditPropertyDeal> {
  late final ValueNotifier<double> _priceController;
  late final ValueNotifier<double> _monthlyRentController;
  late final ValueNotifier<double> _maintenanceCostController;
  late final TextEditingController _priceTextController;
  late final TextEditingController _monthlyRentTextController;
  late final TextEditingController _maintenanceCostTextController;
  bool _isPriceEditing = false;
  bool _isMonthlyRentEditing = false;
  bool _isMaintenanceCostEditing = false;

  EditPropertyVM get _viewModel => ref.read(editPropertyVMProvider(widget.id).notifier);

  @override
  void initState() {
    super.initState();
    final state = ref.read(editPropertyVMProvider(widget.id));

    _priceController = ValueNotifier(state.price)
      ..addListener(() => _viewModel.action(EditPropertyAction.changePrice(_priceController.value)));
    _monthlyRentController = ValueNotifier(state.monthlyRent)
      ..addListener(() => _viewModel.action(EditPropertyAction.changeMonthlyRent(_monthlyRentController.value)));
    _maintenanceCostController = ValueNotifier(state.maintenanceCost)
      ..addListener(() => _viewModel.action(EditPropertyAction.changeMaintenanceCost(_maintenanceCostController.value)));
    _priceTextController = TextEditingController(text: state.price.formattedKRW);
    _monthlyRentTextController = TextEditingController(text: state.monthlyRent.formattedKRW);
    _maintenanceCostTextController = TextEditingController(text: _maintenanceCostText(state.maintenanceCost));
  }

  @override
  void dispose() {
    _priceController.dispose();
    _monthlyRentController.dispose();
    _maintenanceCostController.dispose();
    _priceTextController.dispose();
    _monthlyRentTextController.dispose();
    _maintenanceCostTextController.dispose();
    super.dispose();
  }

  String _maintenanceCostText(double value) => value == 0 ? '관리비 없음' : value.formattedKRW;

  @override
  Widget build(BuildContext context) {
    final provider = editPropertyVMProvider(widget.id);
    final state = ref.watch(provider);

    ref.listen(provider.select((state) => state.price), (_, price) {
      if (_priceController.value != price) { _priceController.value = price; }
      if (!_isPriceEditing) { _priceTextController.text = price.formattedKRW; }
    });

    ref.listen(provider.select((state) => state.monthlyRent), (_, monthlyRent) {
      if (_monthlyRentController.value != monthlyRent) { _monthlyRentController.value = monthlyRent; }
      if (!_isMonthlyRentEditing) { _monthlyRentTextController.text = monthlyRent.formattedKRW; }
    });

    ref.listen(provider.select((state) => state.maintenanceCost), (_, maintenanceCost) {
      if (_maintenanceCostController.value != maintenanceCost) { _maintenanceCostController.value = maintenanceCost; }
      if (!_isMaintenanceCostEditing) { _maintenanceCostTextController.text = _maintenanceCostText(maintenanceCost); }
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
      spacing: 16,
      children: [
        _slider(
          label: state.priceLabel,
          viewState: AppSliderViewState(
            size: AppSliderSize.medium,
            min: state.minPrice,
            max: state.maxPrice,
            distance: EditPropertyViewState.priceDistance,
          ),
          controller: _priceController,
          textController: _priceTextController,
          onFocus: (hasFocus) {
            _isPriceEditing = hasFocus;
            _onAmountFocus(
              hasFocus: hasFocus,
              textController: _priceTextController,
              value: () => ref.read(editPropertyVMProvider(widget.id)).price,
              apply: (amount) => _viewModel.action(EditPropertyAction.changePrice(amount)),
              format: (value) => value.formattedKRW,
            );
          },
        ),
        if (state.isMonthlyRentVisible)
          _slider(
            label: '월세',
            viewState: const AppSliderViewState(
              size: AppSliderSize.medium,
              min: EditPropertyViewState.minMonthlyRent,
              max: EditPropertyViewState.maxMonthlyRent,
              distance: EditPropertyViewState.monthlyRentDistance,
            ),
            controller: _monthlyRentController,
            textController: _monthlyRentTextController,
            onFocus: (hasFocus) {
              _isMonthlyRentEditing = hasFocus;
              _onAmountFocus(
                hasFocus: hasFocus,
                textController: _monthlyRentTextController,
                value: () => ref.read(editPropertyVMProvider(widget.id)).monthlyRent,
                apply: (amount) => _viewModel.action(EditPropertyAction.changeMonthlyRent(amount)),
                format: (value) => value.formattedKRW,
              );
            },
          ),
        _slider(
          label: '관리비',
          viewState: const AppSliderViewState(
            size: AppSliderSize.medium,
            min: EditPropertyViewState.minMaintenanceCost,
            max: EditPropertyViewState.maxMaintenanceCost,
            distance: EditPropertyViewState.maintenanceCostDistance,
          ),
          controller: _maintenanceCostController,
          textController: _maintenanceCostTextController,
          onFocus: (hasFocus) {
            _isMaintenanceCostEditing = hasFocus;
            _onAmountFocus(
              hasFocus: hasFocus,
              textController: _maintenanceCostTextController,
              value: () => ref.read(editPropertyVMProvider(widget.id)).maintenanceCost,
              apply: (amount) => _viewModel.action(EditPropertyAction.changeMaintenanceCost(amount)),
              format: _maintenanceCostText,
            );
          },
        ),
      ],
    );
  }

  /// 금액 입력란 포커스 처리
  ///
  /// - 포커스를 얻으면 원 단위 숫자로 바꾸고 전체 선택
  /// - 포커스가 풀리면 숫자를 반영하고 `format` 형식으로 표시 (숫자가 아니면 원래 금액으로 되돌림)
  void _onAmountFocus({
    required bool hasFocus,
    required TextEditingController textController,
    required double Function() value,
    required void Function(double amount) apply,
    required String Function(double value) format,
  }) {
    if (hasFocus) {
      final digits = '${value().toInt()}';

      textController.value = TextEditingValue(
        text: digits,
        selection: TextSelection(baseOffset: 0, extentOffset: digits.length),
      );
      return;
    }

    final amount = double.tryParse(textController.text);

    if (amount != null) { apply(amount); }

    textController.text = format(value());
  }

  Widget _slider({
    required String label,
    required AppSliderViewState viewState,
    required ValueNotifier<double> controller,
    required TextEditingController textController,
    required ValueChanged<bool> onFocus,
  }) {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 6,
          children: [
            AppFontStyle.bold1.text(label, TextColor.medium),
            Expanded(
              child: BasicTextField(
                viewState: BasicTextFieldViewState(
                  style: AppFontStyle.sub3.style(TextColor.dark),
                  textAlign: TextAlign.right,
                  keyboardType: AppTextFieldKeyboardType.number,
                ),
                controller: textController,
                onFocus: onFocus,
              ),
            ),
          ],
        ),
        AppSlider(viewState: viewState, controller: controller),
      ],
    );
  }
}
