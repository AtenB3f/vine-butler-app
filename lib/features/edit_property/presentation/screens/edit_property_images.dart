import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';

class EditPropertyImages extends ConsumerStatefulWidget {
  final String id;

  const EditPropertyImages({super.key, required this.id});

  @override
  ConsumerState<EditPropertyImages> createState() => _EditPropertyImagesState();
}

class _EditPropertyImagesState extends ConsumerState<EditPropertyImages> {
  final ScrollController _imageScrollController = ScrollController();

  EditPropertyVM get _viewModel => ref.read(editPropertyVMProvider(widget.id).notifier);

  @override
  void dispose() {
    _imageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _images(ref.watch(editPropertyVMProvider(widget.id)));

  Widget _images(EditPropertyViewState state) {
    if (context.isMobile) { return _imageList(state); }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scrollbar(
        controller: _imageScrollController,
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _imageList(state),
        ),
      ),
    );
  }

  Widget _imageList(EditPropertyViewState state) {
    final imageStorage = ref.watch(imageStorageProvider);

    return SingleChildScrollView(
      controller: _imageScrollController,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        spacing: 6,
        children: [
          Pressable(
            onTap: _pickImages,
            child: _imageTile(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  AppIcons.imageLG(TextColor.dark),
                  AppFontStyle.body1.text('이미지 추가', GrayColor.dark),
                ],
              ),
            ),
          ),
          for (final image in state.images)
            _imageTile(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(imageStorage.path(image.fileName)), fit: BoxFit.cover),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 28,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Pressable(
                      onTap: () => _viewModel.action(EditPropertyAction.removeImage(image.id)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AppIcons.closeSM(StateColor.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final files = await ImagePicker().pickMultiImage();

    if (!mounted || files.isEmpty) { return; }

    _viewModel.action(EditPropertyAction.addImages([for (final file in files) file.path]));
  }

  Widget _imageTile({required Widget child}) {
    return Container(
      width: 100,
      height: 100,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: BaseColor.light,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}
