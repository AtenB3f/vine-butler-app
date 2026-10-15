import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class ApplyPropertyAddressScreen extends ConsumerStatefulWidget {
  const ApplyPropertyAddressScreen({super.key});

  @override
  ConsumerState<ApplyPropertyAddressScreen> createState() => _ApplyPropertyAddressScreenState();
}

class _ApplyPropertyAddressScreenState extends ConsumerState<ApplyPropertyAddressScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyAddressVMProvider);
    final viewModel = ref.read(applyPropertyAddressVMProvider.notifier);

    // 네비게이션
    ref.handleEvent(
      applyPropertyAddressVMProvider.select((state) => state.navigateTo),
      consume: viewModel.popNavigation,
      onEvent: (location) => context.push(location),
    );

    // 에러 토스트
    ref.handleEvent(
      applyPropertyAddressVMProvider.select((state) => state.errorMessage),
      consume: () => viewModel.action(const ApplyPropertyAddressAction.clearError()),
      onEvent: (message) => showAppToast(
        context,
        AppToastViewState(type: AppToastType.warning, text: message, hasLink: false),
      ),
    );

    ref.listen(applyPropertyAddressVMProvider.select((state) => state.selected), (_, selected) {
      if (selected == null) {
        _controller.clear();
        _detailController.clear();
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
            child: state.isMapVisible ? _mapPage(state, viewModel) : _inputPage(state, viewModel),
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

  Widget _mapPage(ApplyPropertyAddressViewState state, ApplyPropertyAddressVM viewModel) {
    final address = state.selected!;
    final located = state.located;
    final detail = state.hasDetailAddress ? ', ${state.detailAddress.trim()}' : '';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 16),
            child: AppFontStyle.header1.text(
              state.hasDetailAddress ? '이 주소가 맞으신가요?' : '상세 주소를 입력해주세요.',
              TextColor.dark,
            ),
          ),
          AppTextField(
            viewState: const AppTextFieldViewState(
              status: AppTextFieldStatus.normal,
              title: '상세 주소',
              placeholder: 'ex) 101호',
            ),
            controller: _detailController,
            onChanged: (detailAddress) =>
                viewModel.action(ApplyPropertyAddressAction.inputDetail(detailAddress)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: located == null
                      ? const ColoredBox(color: BaseColor.light)
                      : AppMapView(
                          viewState: AppMapViewViewState(
                            latitude: located.latitude,
                            longitude: located.longitude,
                            clientId: ApiEnv.naverMapsClientId,
                            webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              AppFontStyle.sub2.text('${address.address}$detail', TextColor.dark),
              const SizedBox(height: 4),
              AppFontStyle.body2.text('${address.lotAddress}$detail', TextColor.medium),
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
            onChanged: (query) => viewModel.action(ApplyPropertyAddressAction.search(query)),
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
              text: '다시 입력',
              onTap: () => viewModel.action(const ApplyPropertyAddressAction.reset()),
            ),
          FillButton(
            type: state.canProceed ? FillButtonType.medium : FillButtonType.gray,
            size: BoxButtonSize.large,
            text: '다음',
            onTap: () => viewModel.action(const ApplyPropertyAddressAction.next()),
          ),
        ],
      ),
    );
  }
}
