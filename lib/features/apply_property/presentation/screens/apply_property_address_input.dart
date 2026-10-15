import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';

class ApplyPropertyAddressInput extends ConsumerStatefulWidget {
  const ApplyPropertyAddressInput({super.key});

  @override
  ConsumerState<ApplyPropertyAddressInput> createState() => _ApplyPropertyAddressInputState();
}

class _ApplyPropertyAddressInputState extends ConsumerState<ApplyPropertyAddressInput> {
  static const _focusDuration = Duration(milliseconds: 500);
  static const _focusCurve = Curves.easeOutCubic;

  late final TextEditingController _controller =
      TextEditingController(text: ref.read(applyPropertyAddressVMProvider).query);
  bool _isFocus = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyAddressVMProvider);
    final viewModel = ref.read(applyPropertyAddressVMProvider.notifier);

    return Column(
      children: [
        _header(state, viewModel),
        Expanded(child: _results(state, viewModel)),
      ],
    );
  }

  Widget _header(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    return AnimatedPadding(
      duration: _focusDuration,
      curve: _focusCurve,
      padding: EdgeInsets.fromLTRB(20, _isFocus ? 16 : 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            duration: _focusDuration,
            curve: _focusCurve,
            tween: Tween(end: _isFocus ? 0 : 1),
            builder: (context, progress, child) => ClipRect(
              child: Align(
                alignment: Alignment.bottomLeft,
                heightFactor: progress,
                child: Opacity(opacity: progress, child: child),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 64, bottom: 40),
              child: AppFontStyle.header1.text(
                state.isNotFound ? '주소를 찾을 수 없어요.' : '주소지가 어디인가요?',
                TextColor.dark,
              ),
            ),
          ),
          Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onFocusChange: (hasFocus) => setState(() => _isFocus = hasFocus),
            child: AppTextField(
              viewState: const AppTextFieldViewState(
                status: AppTextFieldStatus.normal,
                title: '주소',
                placeholder: '주소를 검색하세요.',
              ),
              controller: _controller,
              onChange: (query) => viewModel.action(ApplyPropertyAddressAction.search(query)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _results(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    if (state.isNotFound) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text(
              '검색 결과가 없습니다.\n입력한 주소를 확인해 주세요.',
              style: AppFontStyle.body3.style(TextColor.light),
              textAlign: TextAlign.center,
            ),
            // IntrinsicWidth(
            //   child: OutlineButton(
            //     type: OutlineButtonType.gray,
            //     size: BoxButtonSize.small,
            //     text: '직접 입력하기',
            //     onTap: () {},
            //   ),
            // ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 200) { viewModel.action(const ApplyPropertyAddressAction.loadMore()); }

        return false;
      },
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        itemCount: state.results.length + (state.isLoading ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, index) => index < state.results.length
            ? _resultItem(state.results[index], viewModel)
            : const Center(
                child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.small)),
              ),
      ),
    );
  }

  Widget _resultItem(AddressResultViewState result, ApplyPropertyAddressVM viewModel) {
    return Pressable(
      onTap: () => viewModel.action(ApplyPropertyAddressAction.select(result)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            AppFontStyle.bold1.text(result.zipCode, TextColor.light),
            AppFontStyle.body3.text(result.address, TextColor.dark),
          ],
        ),
      ),
    );
  }
}
