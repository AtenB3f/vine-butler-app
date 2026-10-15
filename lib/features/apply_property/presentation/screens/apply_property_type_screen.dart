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
  late final ValueNotifier<double> _priceController =
      ValueNotifier(ref.read(applyPropertyTypeVMProvider).price);
  late final ValueNotifier<double> _monthlyRentController =
      ValueNotifier(ref.read(applyPropertyTypeVMProvider).monthlyRent);

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_onPriceChange);
    _monthlyRentController.addListener(_onMonthlyRentChange);
  }

  @override
  void dispose() {
    _priceController.removeListener(_onPriceChange);
    _monthlyRentController.removeListener(_onMonthlyRentChange);
    _priceController.dispose();
    _monthlyRentController.dispose();
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
                  _price(state),
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

  Widget _price(ApplyPropertyTypeViewState state) {
    return Column(
      spacing: 16,
      children: [
        _slider(
          label: state.priceLabel,
          value: state.price,
          viewState: AppSliderViewState(
            size: AppSliderSize.medium,
            min: state.minPrice,
            max: state.maxPrice,
            distance: ApplyPropertyTypeViewState.priceDistance,
          ),
          controller: _priceController,
        ),
        if (state.isMonthlyRentVisible)
          _slider(
            label: '월세',
            value: state.monthlyRent,
            viewState: const AppSliderViewState(
              size: AppSliderSize.medium,
              min: ApplyPropertyTypeViewState.minMonthlyRent,
              max: ApplyPropertyTypeViewState.maxMonthlyRent,
              distance: ApplyPropertyTypeViewState.monthlyRentDistance,
            ),
            controller: _monthlyRentController,
          ),
      ],
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required AppSliderViewState viewState,
    required ValueNotifier<double> controller,
  }) {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 6,
          children: [
            AppFontStyle.bold1.text(label, TextColor.medium),
            Expanded(
              child: Text(
                value.formattedKRW,
                style: AppFontStyle.sub3.style(TextColor.dark),
                textAlign: TextAlign.right,
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
