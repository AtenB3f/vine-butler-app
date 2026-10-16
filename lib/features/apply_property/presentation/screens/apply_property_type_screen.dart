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
  late final ValueNotifier<double> _priceController;
  late final ValueNotifier<double> _monthlyRentController;
  late final TextEditingController _priceTextController;
  late final TextEditingController _monthlyRentTextController;
  bool _isPriceEditing = false;
  bool _isMonthlyRentEditing = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(applyPropertyTypeVMProvider);

    _priceController = ValueNotifier(state.price);
    _monthlyRentController = ValueNotifier(state.monthlyRent);
    _priceTextController = TextEditingController(text: state.price.formattedKRW);
    _monthlyRentTextController = TextEditingController(text: state.monthlyRent.formattedKRW);
    _priceController.addListener(_onPriceChange);
    _monthlyRentController.addListener(_onMonthlyRentChange);
  }

  @override
  void dispose() {
    _priceController.removeListener(_onPriceChange);
    _monthlyRentController.removeListener(_onMonthlyRentChange);
    _priceController.dispose();
    _monthlyRentController.dispose();
    _priceTextController.dispose();
    _monthlyRentTextController.dispose();
    super.dispose();
  }

  void _onPriceChange() => ref.read(applyPropertyTypeVMProvider.notifier).action(ApplyPropertyTypeAction.changePrice(_priceController.value));

  void _onMonthlyRentChange() =>
      ref.read(applyPropertyTypeVMProvider.notifier).action(ApplyPropertyTypeAction.changeMonthlyRent(_monthlyRentController.value));

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyTypeVMProvider);
    final viewModel = ref.read(applyPropertyTypeVMProvider.notifier);

    ref.handleEvent(
      applyPropertyTypeVMProvider.select((state) => state.navigateTo),
      consume: viewModel.popNavigation,
      onEvent: (location) => context.push(location),
    );

    ref.listen(applyPropertyTypeVMProvider.select((state) => state.price), (_, price) {
      if (_priceController.value != price) { _priceController.value = price; }
      if (!_isPriceEditing) { _priceTextController.text = price.formattedKRW; }
    });

    ref.listen(applyPropertyTypeVMProvider.select((state) => state.monthlyRent), (_, monthlyRent) {
      if (_monthlyRentController.value != monthlyRent) { _monthlyRentController.value = monthlyRent; }
      if (!_isMonthlyRentEditing) { _monthlyRentTextController.text = monthlyRent.formattedKRW; }
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
          _nextButton(state, viewModel),
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
      spacing: 16,
      children: [
        _slider(
          label: state.priceLabel,
          viewState: AppSliderViewState(
            size: AppSliderSize.medium,
            min: state.minPrice,
            max: state.maxPrice,
            distance: ApplyPropertyTypeViewState.priceDistance,
          ),
          controller: _priceController,
          textController: _priceTextController,
          onFocus: (hasFocus) {
            _isPriceEditing = hasFocus;
            _onAmountFocus(
              hasFocus: hasFocus,
              textController: _priceTextController,
              value: () => ref.read(applyPropertyTypeVMProvider).price,
              apply: (amount) => viewModel.action(ApplyPropertyTypeAction.changePrice(amount)),
            );
          },
        ),
        if (state.isMonthlyRentVisible)
          _slider(
            label: '월세',
            viewState: const AppSliderViewState(
              size: AppSliderSize.medium,
              min: ApplyPropertyTypeViewState.minMonthlyRent,
              max: ApplyPropertyTypeViewState.maxMonthlyRent,
              distance: ApplyPropertyTypeViewState.monthlyRentDistance,
            ),
            controller: _monthlyRentController,
            textController: _monthlyRentTextController,
            onFocus: (hasFocus) {
              _isMonthlyRentEditing = hasFocus;
              _onAmountFocus(
                hasFocus: hasFocus,
                textController: _monthlyRentTextController,
                value: () => ref.read(applyPropertyTypeVMProvider).monthlyRent,
                apply: (amount) => viewModel.action(ApplyPropertyTypeAction.changeMonthlyRent(amount)),
              );
            },
          ),
      ],
    );
  }

  /// 금액 입력란 포커스 처리
  ///
  /// - 포커스를 얻으면 원 단위 숫자로 바꾸고 전체 선택
  /// - 포커스가 풀리면 숫자를 반영하고 다시 `○억 ○만원` 형식으로 표시 (숫자가 아니면 원래 금액으로 되돌림)
  void _onAmountFocus({
    required bool hasFocus,
    required TextEditingController textController,
    required double Function() value,
    required void Function(double amount) apply,
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

    textController.text = value().formattedKRW;
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
