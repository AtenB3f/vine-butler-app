import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';

class ApplyPropertyAddressScreen extends ConsumerStatefulWidget {
  const ApplyPropertyAddressScreen({super.key});

  @override
  ConsumerState<ApplyPropertyAddressScreen> createState() => _ApplyPropertyAddressScreenState();
}

class _ApplyPropertyAddressScreenState extends ConsumerState<ApplyPropertyAddressScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyAddressVMProvider);
    final viewModel = ref.read(applyPropertyAddressVMProvider.notifier);

    ref.listen(applyPropertyAddressVMProvider.select((state) => state.selected), (_, selected) {
      if (selected == null) {
        _controller.clear();
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    return AppScaffold(
      title: '매물 등록',
      leftIcon: AppIcons.chevronLeftMD,
      onLeftTap: () => context.pop(),
      body: Column(
        children: [
          Expanded(
            child: state.isMapVisible ? _mapPage(state.selected!) : _inputPage(state, viewModel),
          ),
          _buttons(state, viewModel),
        ],
      ),
    );
  }

  Widget _inputPage(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    return Column(
      children: [
        _header(state, viewModel),
        Expanded(child: _results(state, viewModel)),
      ],
    );
  }

  Widget _mapPage(AddressResultViewState address) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 16),
            child: AppFontStyle.header1.text('이 주소가 맞으신가요?', TextColor.dark),
          ),
          Container(
            width: double.infinity,
            height: 335,
            decoration: BoxDecoration(
              color: BaseColor.light,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              AppFontStyle.sub2.text(address.address, TextColor.dark),
              AppFontStyle.body2.text(address.lotAddress, TextColor.medium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 16),
            child: AppFontStyle.header1.text(
              state.isNotFound ? '주소를 찾을 수 없어요.' : '주소지가 어디인가요?',
              TextColor.dark,
            ),
          ),
          AppTextField(
            viewState: const AppTextFieldViewState(
              status: AppTextFieldStatus.normal,
              title: '주소',
              placeholder: '주소를 검색하세요.',
            ),
            controller: _controller,
            onChanged: viewModel.search,
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

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: state.results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, index) => _resultItem(state.results[index], viewModel),
    );
  }

  Widget _resultItem(AddressResultViewState result, ApplyPropertyAddressVM viewModel) {
    return Pressable(
      onTap: () => viewModel.select(result),
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

  Widget _buttons(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: Column(
        spacing: 6,
        children: [
          if (state.isMapVisible)
            FillButton(
              type: FillButtonType.gray,
              size: BoxButtonSize.large,
              text: '다시 입력하기',
              onTap: viewModel.reset,
            ),
          FillButton(
            type: state.isMapVisible ? FillButtonType.medium : FillButtonType.gray,
            size: BoxButtonSize.large,
            text: '다음',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
