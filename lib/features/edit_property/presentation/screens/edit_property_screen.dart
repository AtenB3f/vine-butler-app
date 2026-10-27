import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/features/edit_property/presentation/screens/edit_property_deal.dart';
import 'package:vine_butler/features/edit_property/presentation/screens/edit_property_images.dart';
import 'package:vine_butler/features/edit_property/presentation/screens/edit_property_options.dart';
import 'package:vine_butler/features/edit_property/presentation/screens/edit_property_owner.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

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

      case EditPropertyEvent.invalidPrice:
        showAppToast(
          context,
          const AppToastViewState(type: AppToastType.warning, text: '거래 금액을 입력해주세요.', hasLink: false),
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
  GlobalKey? _focusedKey;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editPropertyVMProvider(widget.id));
    final editingField = state.editingField;

    return Column(
      children: [
        Expanded(
          child: AppKeyboardScrollView(
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
                    EditPropertyImages(id: widget.id),
                  ],
                ),
                EditPropertyDeal(id: widget.id, onFocus: _focus),
                EditPropertyOwner(id: widget.id, onFocus: _focus),
                EditPropertyOptions(id: widget.id, onFocus: _focus),
              ],
            ),
          ),
        ),
        PriceKeypad.animated(keypad: editingField == null ? null : _keypad(state, editingField)),
      ],
    );
  }

  PriceKeypad _keypad(EditPropertyViewState state, EditPropertyPriceField field) {
    final viewModel = ref.read(editPropertyVMProvider(widget.id).notifier);
    final amount = switch (field) {
      EditPropertyPriceField.price => state.price,
      EditPropertyPriceField.monthlyRent => state.monthlyRent,
      EditPropertyPriceField.maintenanceCost => state.maintenanceCost,
    };

    return PriceKeypad(
      key: ValueKey(field),
      viewState: PriceKeypadViewState(value: amount.toInt()),
      onChanged: (value) => viewModel.action(switch (field) {
        EditPropertyPriceField.price => EditPropertyAction.changePrice(value.toDouble()),
        EditPropertyPriceField.monthlyRent => EditPropertyAction.changeMonthlyRent(value.toDouble()),
        EditPropertyPriceField.maintenanceCost => EditPropertyAction.changeMaintenanceCost(value.toDouble()),
      }),
      onConfirm: () => viewModel.action(const EditPropertyAction.nextField()),
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

  void _focus(GlobalKey key, bool hasFocus) {
    if (hasFocus) {
      setState(() => _focusedKey = key);
    } else if (_focusedKey == key) {
      setState(() => _focusedKey = null);
    }
  }
}
