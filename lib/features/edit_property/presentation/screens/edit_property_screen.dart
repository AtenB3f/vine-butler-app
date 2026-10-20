import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/apply_property/apply_property_extra_vm.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class EditPropertyScreen extends ConsumerWidget {
  final String id;

  const EditPropertyScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editPropertyVMProvider(id));
    final viewModel = ref.read(editPropertyVMProvider(id).notifier);

    ref.handleEvent(
      editPropertyVMProvider(id).select((state) => state.event),
      consume: viewModel.sendEvent,
      onEvent: (event) => _onEvent(context, event),
    );

    return AppScaffold(
      title: '매물 정보 수정',
      leftIcon: AppIcons.closeLG,
      onLeftTap: () => context.pop(),
      rightIcon: AppIcons.checkLG,
      onRightTap: () => viewModel.action(const EditPropertyAction.save()),
      body: switch (state.status) {
        EditPropertyStatus.loading => const Center(
            child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
          ),
        EditPropertyStatus.notFound => Center(child: AppFontStyle.body3.text('매물을 찾을 수 없습니다.', TextColor.medium)),
        EditPropertyStatus.loaded => _EditPropertyForm(id: id),
      },
    );
  }

  void _onEvent(BuildContext context, EditPropertyEvent event) {
    switch (event) {
      case EditPropertyEvent.save:
        showAppToast(context, const AppToastViewState(type: AppToastType.check, text: '매물 정보가 수정되었습니다.', hasLink: false));
        context.pop();

      case EditPropertyEvent.failSave:
        showAppToast(
          context,
          const AppToastViewState(type: AppToastType.warning, text: '매물 정보를 수정하지 못했습니다. 다시 시도해주세요.', hasLink: false),
        );

      case EditPropertyEvent.invalidOwner:
        showAppToast(
          context,
          const AppToastViewState(type: AppToastType.warning, text: '임대인 이름과 휴대폰 번호를 확인해주세요.', hasLink: false),
        );
    }
  }
}

class _EditPropertyForm extends ConsumerStatefulWidget {
  final String id;

  const _EditPropertyForm({required this.id});

  @override
  ConsumerState<_EditPropertyForm> createState() => _EditPropertyFormState();
}

class _EditPropertyFormState extends ConsumerState<_EditPropertyForm> {
  late final ValueNotifier<double> _priceController;
  late final ValueNotifier<double> _monthlyRentController;
  late final ValueNotifier<double> _maintenanceCostController;
  late final TextEditingController _priceTextController;
  late final TextEditingController _monthlyRentTextController;
  late final TextEditingController _maintenanceCostTextController;
  late final TextEditingController _nameController;
  late final PhoneNumberEditingController _phoneController;
  late final TextEditingController _memoController;
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _phoneKey = GlobalKey();
  final GlobalKey _memoKey = GlobalKey();
  GlobalKey? _focusedKey;
  bool _isPriceEditing = false;
  bool _isMonthlyRentEditing = false;
  bool _isMaintenanceCostEditing = false;

  EditPropertyVM get _viewModel => ref.read(editPropertyVMProvider(widget.id).notifier);

  @override
  void initState() {
    super.initState();
    final state = ref.read(editPropertyVMProvider(widget.id));

    _priceController = ValueNotifier(state.price);
    _monthlyRentController = ValueNotifier(state.monthlyRent);
    _maintenanceCostController = ValueNotifier(state.maintenanceCost);
    _priceTextController = TextEditingController(text: state.price.formattedKRW);
    _monthlyRentTextController = TextEditingController(text: state.monthlyRent.formattedKRW);
    _maintenanceCostTextController = TextEditingController(text: _maintenanceCostText(state.maintenanceCost));
    _nameController = TextEditingController(text: state.ownerName);
    _phoneController = PhoneNumberEditingController(text: state.ownerPhone);
    _memoController = TextEditingController(text: state.memo);
    _priceController.addListener(_onPriceChange);
    _monthlyRentController.addListener(_onMonthlyRentChange);
    _maintenanceCostController.addListener(_onMaintenanceCostChange);
  }

  @override
  void dispose() {
    _priceController.removeListener(_onPriceChange);
    _monthlyRentController.removeListener(_onMonthlyRentChange);
    _maintenanceCostController.removeListener(_onMaintenanceCostChange);
    _priceController.dispose();
    _monthlyRentController.dispose();
    _maintenanceCostController.dispose();
    _priceTextController.dispose();
    _monthlyRentTextController.dispose();
    _maintenanceCostTextController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onPriceChange() => _viewModel.action(EditPropertyAction.changePrice(_priceController.value));

  void _onMonthlyRentChange() => _viewModel.action(EditPropertyAction.changeMonthlyRent(_monthlyRentController.value));

  void _onMaintenanceCostChange() =>
      _viewModel.action(EditPropertyAction.changeMaintenanceCost(_maintenanceCostController.value));

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

    return AppKeyboardScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      focusedKey: _focusedKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _address(state),
              _images(state),
            ],
          ),
          _group('거래 유형', _transaction(state)),
          _prices(state),
          _owner(state),
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
            onFocus: (hasFocus) => _focus(_memoKey, hasFocus),
          ),
        ],
      ),
    );
  }

  Widget _address(EditPropertyViewState state) {
    return Pressable(
      onTap: () => EditPropertyAddressRoute(id: widget.id).push(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Flexible(child: AppFontStyle.header1.text(state.unitAddress, TextColor.dark)),
              AppIcons.editLG(TextColor.dark),
            ],
          ),
          AppFontStyle.sub1.text(state.regionAddress, TextColor.dark),
        ],
      ),
    );
  }

  Widget _images(EditPropertyViewState state) {
    final images = state.property?.images ?? const [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        spacing: 6,
        children: [
          _imageTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                AppIcons.imageLG(TextColor.dark),
                AppFontStyle.body1.text('이미지 추가', GrayColor.dark),
              ],
            ),
          ),
          for (final _ in images)
            _imageTile(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: AppIcons.closeSM(GrayColor.dark),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _imageTile({required Widget child}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: BaseColor.light,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
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

  Widget _owner(EditPropertyViewState state) {
    return Column(
      spacing: 16,
      children: [
        AppTextField(
          key: _nameKey,
          viewState: const AppTextFieldViewState(
            status: AppTextFieldStatus.normal,
            title: '임대인',
            placeholder: '이름을 입력하세요.',
          ),
          controller: _nameController,
          onChange: (name) => _viewModel.action(EditPropertyAction.changeOwnerName(name)),
          onFocus: (hasFocus) => _focus(_nameKey, hasFocus),
        ),
        AppTextField(
          key: _phoneKey,
          viewState: AppTextFieldViewState(
            status: state.hasPhoneError ? AppTextFieldStatus.error : AppTextFieldStatus.normal,
            title: '임대인 휴대폰 번호',
            placeholder: '휴대폰 번호를 입력하세요.',
            keyboardType: AppTextFieldKeyboardType.number,
            errorText: '전화번호 형식이 올바르지 않습니다.',
          ),
          controller: _phoneController,
          onChange: (phone) => _viewModel.action(EditPropertyAction.changeOwnerPhone(phone)),
          onFocus: (hasFocus) => _focus(_phoneKey, hasFocus),
        ),
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
                    moveInDate == null ? '즉시 입주' : '${formatDate(moveInDate)} 이후',
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

  void _focus(GlobalKey key, bool hasFocus) {
    if (hasFocus) {
      setState(() => _focusedKey = key);
    } else if (_focusedKey == key) {
      setState(() => _focusedKey = null);
    }
  }
}
