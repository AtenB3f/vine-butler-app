import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';
import 'package:vine_butler/shared/utils/utils.dart';

class EditPropertyOwner extends ConsumerStatefulWidget {
  final String id;
  final void Function(GlobalKey key, bool hasFocus) onFocus;

  const EditPropertyOwner({super.key, required this.id, required this.onFocus});

  @override
  ConsumerState<EditPropertyOwner> createState() => _EditPropertyOwnerState();
}

class _EditPropertyOwnerState extends ConsumerState<EditPropertyOwner> {
  late final TextEditingController _nameController;
  late final PhoneNumberEditingController _phoneController;
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _phoneKey = GlobalKey();

  EditPropertyVM get _viewModel => ref.read(editPropertyVMProvider(widget.id).notifier);

  @override
  void initState() {
    super.initState();
    final state = ref.read(editPropertyVMProvider(widget.id));

    _nameController = TextEditingController(text: state.ownerName);
    _phoneController = PhoneNumberEditingController(text: state.ownerPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _owner(ref.watch(editPropertyVMProvider(widget.id)));

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
          onFocus: (hasFocus) => widget.onFocus(_nameKey, hasFocus),
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
          onFocus: (hasFocus) => widget.onFocus(_phoneKey, hasFocus),
        ),
      ],
    );
  }
}
