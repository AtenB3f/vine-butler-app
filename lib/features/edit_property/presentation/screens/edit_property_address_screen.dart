import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/features/edit_property/edit_property_address_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_address_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class EditPropertyAddressScreen extends ConsumerStatefulWidget {
  final String id;

  const EditPropertyAddressScreen({super.key, required this.id});

  @override
  ConsumerState<EditPropertyAddressScreen> createState() => _EditPropertyAddressScreenState();
}

class _EditPropertyAddressScreenState extends ConsumerState<EditPropertyAddressScreen> {
  late final TextEditingController _detailController;
  final TextEditingController _queryController = TextEditingController();
  final GlobalKey _detailKey = GlobalKey();
  GlobalKey? _focusedKey;

  EditPropertyAddressVM get _viewModel => ref.read(editPropertyAddressVMProvider(widget.id).notifier);

  @override
  void initState() {
    super.initState();
    _detailController = TextEditingController(text: ref.read(editPropertyAddressVMProvider(widget.id)).detailAddress);
  }

  @override
  void dispose() {
    _detailController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = editPropertyAddressVMProvider(widget.id);
    final state = ref.watch(provider);

    ref.handleEvent(
      provider.select((state) => state.isCompleted ? true : null),
      consume: _viewModel.consumeCompleted,
      onEvent: (_) => context.pop(),
    );

    ref.handleEvent(
      provider.select((state) => state.errorMessage),
      consume: () => _viewModel.action(const EditPropertyAddressAction.clearError()),
      onEvent: (message) => showAppToast(
        context,
        AppToastViewState(type: AppToastType.warning, text: message, hasLink: false),
      ),
    );

    ref.listen(provider.select((state) => state.step), (_, step) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _focusedKey = null);

      if (step == EditPropertyAddressStep.confirm) { _detailController.clear(); }
    });

    return AppScaffold(
      title: '매물 정보 수정',
      leftIcon: AppIcons.closeLG,
      onLeftTap: () => context.pop(),
      rightIcon: state.step == EditPropertyAddressStep.detail ? AppIcons.checkLG : null,
      onRightTap: () => _viewModel.action(const EditPropertyAddressAction.saveDetail()),
      body: switch (state.step) {
        EditPropertyAddressStep.detail => _detailStep(state),
        EditPropertyAddressStep.search => _searchStep(state),
        EditPropertyAddressStep.confirm => Column(
            children: [
              Expanded(child: _confirmStep(state)),
              _confirmButtons(state),
            ],
          ),
      },
    );
  }

  Widget _address(EditPropertyAddressViewState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        AppFontStyle.header1.text(state.unitAddress, TextColor.dark),
        AppFontStyle.sub1.text(state.regionAddress, TextColor.dark),
      ],
    );
  }

  Widget _detailField() {
    return AppTextField(
      key: _detailKey,
      viewState: const AppTextFieldViewState(
        status: AppTextFieldStatus.normal,
        title: '상세 주소',
        placeholder: 'ex) 101호',
      ),
      controller: _detailController,
      onChange: (detailAddress) => _viewModel.action(EditPropertyAddressAction.inputDetail(detailAddress)),
      onFocus: (hasFocus) => setState(() => _focusedKey = hasFocus ? _detailKey : null),
    );
  }

  Widget _detailStep(EditPropertyAddressViewState state) {
    return AppKeyboardScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      focusedKey: _focusedKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          _address(state),
          Column(
            spacing: 10,
            children: [
              _detailField(),
              FillButton(
                type: FillButtonType.gray,
                size: BoxButtonSize.large,
                text: '주소 재설정',
                onTap: () => _viewModel.action(const EditPropertyAddressAction.resetAddress()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchStep(EditPropertyAddressViewState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _address(state),
          const SizedBox(height: 40),
          AppTextField(
            viewState: const AppTextFieldViewState(
              status: AppTextFieldStatus.normal,
              title: '주소',
              placeholder: '주소를 검색하세요.',
            ),
            controller: _queryController,
            onChange: (query) => _viewModel.action(EditPropertyAddressAction.search(query)),
          ),
          const SizedBox(height: 10),
          Expanded(child: _results(state)),
        ],
      ),
    );
  }

  Widget _results(EditPropertyAddressViewState state) {
    if (state.isNotFound) {
      return Center(
        child: Text(
          '검색 결과가 없습니다.\n입력한 주소를 확인해 주세요.',
          style: AppFontStyle.body3.style(TextColor.light),
          textAlign: TextAlign.center,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 200) { _viewModel.action(const EditPropertyAddressAction.loadMore()); }

        return false;
      },
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 40),
        itemCount: state.results.length + (state.isLoading ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) => index < state.results.length
            ? _resultItem(state.results[index])
            : const Center(
                child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.small)),
              ),
      ),
    );
  }

  Widget _resultItem(AddressResultViewState result) {
    return Pressable(
      onTap: () => _viewModel.action(EditPropertyAddressAction.select(result)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4),
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

  Widget _confirmStep(EditPropertyAddressViewState state) {
    final located = state.located;

    return AppKeyboardScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      focusedKey: _focusedKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 40,
        children: [
          _address(state),
          _detailField(),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AspectRatio(
              aspectRatio: 1,
              child: located == null
                  ? const ColoredBox(color: BaseColor.light)
                  : _map(located.latitude, located.longitude),
            ),
          ),
        ],
      ),
    );
  }

  Widget _map(double latitude, double longitude) {
    final viewState = NaverMapViewState(
      latitude: latitude,
      longitude: longitude,
      clientId: ApiEnv.naverMapsClientId,
      webServiceUrl: ApiEnv.naverMapsWebServiceUrl,
    );

    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => NativeMap(viewState: viewState),
      TargetPlatform.macOS => MacMap(viewState: viewState),
      TargetPlatform.windows => WindowsMap(viewState: viewState),
      _ => const ColoredBox(color: BaseColor.light),
    };
  }

  Widget _confirmButtons(EditPropertyAddressViewState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        color: StateColor.white,
        boxShadow: [AppShadow.top],
      ),
      child: Column(
        spacing: 6,
        children: [
          FillButton(
            type: FillButtonType.gray,
            size: BoxButtonSize.large,
            text: '다시 입력',
            onTap: () => _viewModel.action(const EditPropertyAddressAction.retry()),
          ),
          FillButton(
            type: state.canSaveAddress ? FillButtonType.medium : FillButtonType.gray,
            size: BoxButtonSize.large,
            text: '저장',
            onTap: () => _viewModel.action(const EditPropertyAddressAction.saveAddress()),
          ),
        ],
      ),
    );
  }
}
