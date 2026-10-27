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
  final FocusNode _priceFocusNode = FocusNode();
  final GlobalKey _priceKey = GlobalKey();
  GlobalKey? _focusedKey;

  FindPropertyVM get _viewModel => ref.read(findPropertyVMProvider.notifier);

  @override
  void initState() {
    super.initState();
    _priceFocusNode.addListener(_onPriceFocus);
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreFocus());
  }

  /// provider가 화면보다 오래 유지되므로 다시 들어왔을 때 입력 중이던 칸에 포커스를 되돌림
  void _restoreFocus() {
    if (ref.read(findPropertyVMProvider).editingField != null) { _priceFocusNode.requestFocus(); }
  }

  @override
  void dispose() {
    _priceFocusNode.removeListener(_onPriceFocus);
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _onPriceFocus() {
    setState(() => _focusedKey = _priceFocusNode.hasFocus ? _priceKey : null);

    if (_priceFocusNode.hasFocus) {
      _viewModel.action(const FindPropertyAction.edit(FindPropertyPriceField.price));
    } else if (ref.read(findPropertyVMProvider).editingField != null) {
      _viewModel.action(const FindPropertyAction.edit(null));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findPropertyVMProvider);
    final viewModel = _viewModel;

    ref.handleEvent(
      findPropertyVMProvider.select((state) => state.navigateTo),
      consume: viewModel.navigate,
      onEvent: (location) => context.go(location),
    );

    ref.listen(findPropertyVMProvider.select((state) => state.editingField), (_, field) {
      if (field == null && _priceFocusNode.hasFocus) { _priceFocusNode.unfocus(); }
      if (field != null && !_priceFocusNode.hasFocus) { _priceFocusNode.requestFocus(); }
    });

    return AppScaffold(
      title: '매물 찾기',
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
                  _transaction(state, viewModel),
                  _propertyType(state, viewModel),
                  _price(state, viewModel),
                ],
              ),
            ),
          ),
          PriceKeypad.animated(
            keypad: state.editingField == null ? null : _keypad(state, viewModel),
            placeholder: _nextButton(viewModel),
          ),
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
                  onTap: () => viewModel.action(FindPropertyAction.selectTransactionType(type)),
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
                        onTap: () => viewModel.action(FindPropertyAction.togglePropertyType(option)),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _price(FindPropertyViewState state, FindPropertyVM viewModel) {
    return Column(
      key: _priceKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.bold1.text('금액', TextColor.medium),
        Focus(
          focusNode: _priceFocusNode,
          child: PriceField(
            viewState: PriceFieldViewState(
              text: state.price.formattedKRW,
              subText: state.price == 0 ? null : '${state.price.formattedNumber}원',
              isFocused: state.editingField == FindPropertyPriceField.price,
            ),
            onTap: _priceFocusNode.requestFocus,
            onClear: () => viewModel.action(const FindPropertyAction.changePrice(0)),
          ),
        ),
      ],
    );
  }

  PriceKeypad _keypad(FindPropertyViewState state, FindPropertyVM viewModel) {
    return PriceKeypad(
      key: const ValueKey(FindPropertyPriceField.price),
      viewState: PriceKeypadViewState(value: state.price.toInt()),
      onChanged: (value) => viewModel.action(FindPropertyAction.changePrice(value.toDouble())),
      onConfirm: () => viewModel.action(const FindPropertyAction.nextField()),
    );
  }

  Widget _nextButton(FindPropertyVM viewModel) {
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
        onTap: () => viewModel.action(const FindPropertyAction.next()),
      ),
    );
  }
}
