import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/network/api_env.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';

class ApplyPropertyAddressDetail extends ConsumerStatefulWidget {
  const ApplyPropertyAddressDetail({super.key});

  @override
  ConsumerState<ApplyPropertyAddressDetail> createState() => _ApplyPropertyAddressDetailState();
}

class _ApplyPropertyAddressDetailState extends ConsumerState<ApplyPropertyAddressDetail> {
  late final TextEditingController _detailController =
      TextEditingController(text: ref.read(applyPropertyAddressVMProvider).detailAddress);
  final GlobalKey _detailKey = GlobalKey();
  GlobalKey? _focusedKey;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applyPropertyAddressVMProvider);
    final viewModel = ref.read(applyPropertyAddressVMProvider.notifier);
    final address = state.selected!;
    final located = state.located;
    final detail = state.hasDetailAddress ? ', ${state.detailAddress.trim()}' : '';

    return AppKeyboardScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      focusedKey: _focusedKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: AppFontStyle.header1.text(
              state.hasDetailAddress ? '이 주소가 맞으신가요?' : '상세 주소를 입력해주세요.',
              TextColor.dark,
            ),
          ),
          AppTextField(
            key: _detailKey,
            viewState: const AppTextFieldViewState(
              status: AppTextFieldStatus.normal,
              title: '상세 주소',
              placeholder: 'ex) 101호',
            ),
            controller: _detailController,
            onChange: (detailAddress) =>
                viewModel.action(ApplyPropertyAddressAction.inputDetail(detailAddress)),
            onFocus: (hasFocus) => setState(() => _focusedKey = hasFocus ? _detailKey : null),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              AppFontStyle.sub2.text('${address.address}$detail', TextColor.dark),
              AppFontStyle.body2.text('${address.lotAddress}$detail', TextColor.medium),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AspectRatio(
              aspectRatio: 1,
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
        ],
      ),
    );
  }
}
