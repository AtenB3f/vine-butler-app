import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/find_property/find_property_vm.dart';
import 'package:vine_butler/features/find_property/presentation/find_property_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class FindPropertyScreen extends ConsumerStatefulWidget {
  const FindPropertyScreen({super.key});

  @override
  ConsumerState<FindPropertyScreen> createState() => _FindPropertyScreenState();
}

class _FindPropertyScreenState extends ConsumerState<FindPropertyScreen> {
  late final ValueNotifier<double> _priceController =
      ValueNotifier(ref.read(findPropertyVMProvider).price);

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_onPriceChange);
  }

  @override
  void dispose() {
    _priceController.removeListener(_onPriceChange);
    _priceController.dispose();
    super.dispose();
  }

  void _onPriceChange() => ref.read(findPropertyVMProvider.notifier).changePrice(_priceController.value);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findPropertyVMProvider);
    final viewModel = ref.read(findPropertyVMProvider.notifier);

    ref.listen(findPropertyVMProvider.select((state) => state.price), (_, price) {
      if (_priceController.value != price) {
        _priceController.value = price;
      }
    });

    return AppScaffold(
      title: '매물 찾기',
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
          _nextButton(),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 16),
      child: AppFontStyle.header1.text('이런 집을 찾고있어요.', TextColor.dark),
    );
  }

  Widget _transaction(FindPropertyViewState state, FindPropertyVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.bold1.text('거래 유형', TextColor.medium),
        Row(
          spacing: 6,
          children: [
            for (final type in FindPropertyVM.transactionTypeOptions)
              Expanded(
                child: OutlineButton(
                  type: state.transactionType == type ? type.buttonType : OutlineButtonType.gray,
                  size: BoxButtonSize.large,
                  text: type.label,
                  onTap: () => viewModel.selectTransactionType(type),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _propertyType(FindPropertyViewState state, FindPropertyVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 6,
          children: [
            AppFontStyle.bold1.text('건물 유형', TextColor.medium),
            AppFontStyle.body1.text('중복 선택 가능', TextColor.light),
          ],
        ),
        Column(
          spacing: 6,
          children: [
            for (final row in FindPropertyVM.propertyTypeOptions)
              Row(
                spacing: 6,
                children: [
                  for (final option in row)
                    Expanded(
                      child: FillButton(
                        type: state.propertyTypes.containsAll(option.types)
                            ? FillButtonType.light
                            : FillButtonType.gray,
                        size: BoxButtonSize.medium,
                        text: option.label,
                        onTap: () => viewModel.togglePropertyType(option),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _price(FindPropertyViewState state) {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 6,
          children: [
            AppFontStyle.body1.text('금액', TextColor.medium),
            Expanded(
              child: Text(
                state.price.formattedKRW,
                style: AppFontStyle.sub3.style(TextColor.dark),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        AppSlider(
          viewState: AppSliderViewState(
            size: AppSliderSize.medium,
            min: state.minPrice,
            max: state.maxPrice,
            distance: FindPropertyViewState.priceDistance,
          ),
          controller: _priceController,
        ),
      ],
    );
  }

  Widget _nextButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: FillButton(
        type: FillButtonType.medium,
        size: BoxButtonSize.large,
        text: '다음',
        onTap: () {},
      ),
    );
  }
}
