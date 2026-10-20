import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/property_list_vm.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class PropertyFilterPanel extends ConsumerStatefulWidget {
  const PropertyFilterPanel({super.key});

  @override
  ConsumerState<PropertyFilterPanel> createState() => _PropertyFilterPanelState();
}

class _PropertyFilterPanelState extends ConsumerState<PropertyFilterPanel> {
  late final ValueNotifier<double> _priceController;

  PropertyListVM get _viewModel => ref.read(propertyListVMProvider.notifier);

  PropertyFilterData get _filter => ref.read(propertyListVMProvider).filter.data;

  @override
  void initState() {
    super.initState();
    _priceController = ValueNotifier(_filter.price)
      ..addListener(() => _applyFilter(_filter.copyWith(price: _priceController.value)));
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _applyFilter(PropertyFilterData filter) => _viewModel.action(PropertyListAction.filtering(filter));

  void _onCollapseTap() {
    FocusManager.instance.primaryFocus?.unfocus();
    _viewModel.action(const PropertyListAction.panel(false));
  }

  @override
  Widget build(BuildContext context) {
    return _contents();
  }

  Widget _contents() {
    final filter = ref.watch(propertyListVMProvider.select((state) => state.filter.data));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            spacing: 20,
            children: [
              _transaction(filter),
              _propertyType(filter),
              _price(filter),
            ],
          ),
        ),
        _collapseButton(),
      ],
    );
  }

  Widget _item({
    required String title,
    required List<Widget> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(
          width: 80,
          height: 30,
          child: AppFontStyle.bold1.text(title, TextColor.medium),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _propertyType(PropertyFilterData filter) {
    return _item(
      title: '구분',
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: [
            for (final row in PropertyListVM.propertyTypeOptions)
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  for (final option in row) _propertyTypeButton(filter, option),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _propertyTypeButton(PropertyFilterData filter, PropertyTypeFilterOption option) {
    final isSelected = filter.propertyTypes.containsAll(option.types);

    return OutlineButton(
      type: isSelected ? OutlineButtonType.main : OutlineButtonType.gray,
      size: BoxButtonSize.small,
      text: option.label,
      onTap: () => _applyFilter(filter.copyWith(
        propertyTypes: isSelected
            ? filter.propertyTypes.difference(option.types)
            : filter.propertyTypes.union(option.types),
      )),
    );
  }

  Widget _transaction(PropertyFilterData filter) {
    return _item(
      title: '거래',
      children: [
        for (final type in PropertyListVM.transactionTypeOptions)
          OutlineButton(
            type: filter.transactionType == type ? type.buttonType : OutlineButtonType.gray,
            size: BoxButtonSize.small,
            text: type.label,
            onTap: () => _applyFilter(filter.copyWith(transactionType: () => filter.transactionType == type ? null : type)),
          ),
      ],
    );
  }

  Widget _price(PropertyFilterData filter) {
    return Column(
      spacing: 10,
      children: [
        _item(
          title: '금액',
          children: [
            Text(
                filter.price.formattedKRW,
                style: AppFontStyle.sub3.style(TextColor.dark),
                textAlign: TextAlign.right,
              )
          ]
        ),
        AppSlider(
          viewState: const AppSliderViewState(
            size: AppSliderSize.small,
            min: PropertyFilterData.minPrice,
            max: PropertyFilterData.maxPrice,
            distance: PropertyFilterData.priceDistance,
          ),
          controller: _priceController,
        ),
      ],
    );
  }

  Widget _collapseButton() {
    return Pressable(
      onTap: _onCollapseTap,
      child: Container(
        height: 38,
        color: StateColor.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            AppFontStyle.body2.text('접기', TextColor.light),
            AppIcons.chevronUpSM(TextColor.light),
          ],
        ),
      ),
    );
  }
}
