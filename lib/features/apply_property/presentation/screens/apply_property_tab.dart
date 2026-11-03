import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_type_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/screens/apply_property_content.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class ApplyPropertyTab extends ConsumerStatefulWidget {
  const ApplyPropertyTab({super.key});

  @override
  ConsumerState<ApplyPropertyTab> createState() => _ApplyPropertyTabState();
}

class _ApplyPropertyTabState extends ConsumerState<ApplyPropertyTab> {
  GlobalKey? _focusedKey;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyTypeVMProvider);
    final viewModel = ref.read(applyPropertyTypeVMProvider.notifier);

    ref.handleEvent(
      applyPropertyTypeVMProvider.select((state) => state.navigateTo),
      consume: viewModel.popNavigation,
      onEvent: (location) => context.push(location),
    );

    return ColoredBox(
      color: StateColor.white,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(),
                  Expanded(
                    child: AppKeyboardScrollView(
                      padding: const EdgeInsets.all(40),
                      focusedKey: _focusedKey,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 40,
                          children: [
                            ApplyPropertyContent(onFocusedKeyChange: (key) => setState(() => _focusedKey = key)),
                            FillButton(
                              type: state.isCompleted ? FillButtonType.medium : FillButtonType.gray,
                              size: BoxButtonSize.large,
                              text: '다음',
                              onTap: () => viewModel.action(const ApplyPropertyTypeAction.next()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PriceKeypad.animated(keypad: ApplyPropertyContent.keypad(state, viewModel)),
        ],
      ),
    );
  }

  Widget _title() {
    return SizedBox(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          spacing: 10,
          children: [
            SvgPicture.asset('assets/icons/Property_Apply.svg', width: 240, height: 120, fit: BoxFit.contain),
            AppFontStyle.header1.text('이 집을 맡길게요.', TextColor.dark),
          ],
        ),
      ),
    );
  }
}
