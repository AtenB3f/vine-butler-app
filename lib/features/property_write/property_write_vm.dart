import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:pasteboard/pasteboard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/exception/api_exception.dart';
import 'package:vine_butler/domain/exception/permission_denied_exception.dart';
import 'package:vine_butler/features/property_write/presentation/property_write_view_state.dart';
import 'package:vine_butler/shared/utils/utils.dart';

typedef PropertyWriteArgs = ({String id, PostSource source});

final propertyWriteVMProvider =
    NotifierProvider.autoDispose.family<PropertyWriteVM, PropertyWriteViewState, PropertyWriteArgs>(PropertyWriteVM.new);

sealed class PropertyWriteAction {
  const PropertyWriteAction();

  const factory PropertyWriteAction.retry() = _Retry;
  const factory PropertyWriteAction.copy(PostContentType type) = _Copy;
  const factory PropertyWriteAction.copyImage(int? index) = _CopyImage;
  const factory PropertyWriteAction.share() = _Share;
  const factory PropertyWriteAction.sendEmail() = _SendEmail;
  const factory PropertyWriteAction.clearCopy() = _ClearCopy;
}

class _Retry extends PropertyWriteAction {
  const _Retry();
}

class _Copy extends PropertyWriteAction {
  final PostContentType type;

  const _Copy(this.type);
}

class _CopyImage extends PropertyWriteAction {
  final int? index;

  const _CopyImage(this.index);
}

class _Share extends PropertyWriteAction {
  const _Share();
}

class _SendEmail extends PropertyWriteAction {
  const _SendEmail();
}

class _ClearCopy extends PropertyWriteAction {
  const _ClearCopy();
}

class PropertyWriteVM extends Notifier<PropertyWriteViewState> {
  PropertyWriteVM(this.args);

  final PropertyWriteArgs args;

  String get id => args.id;

  @override
  PropertyWriteViewState build() {
    _load();
    return const PropertyWriteViewState();
  }

  void action(PropertyWriteAction action) {
    switch (action) {
      case _Retry():
        state = state.copyWith(status: PropertyWriteStatus.loading, errorDetail: () => null);
        _load();

      case _Copy(:final type):
        _copy(type);

      case _CopyImage(:final index):
        _copyImage(index);

      case _Share():
        _share();

      case _SendEmail():
        _sendEmail();

      case _ClearCopy():
        state = state.copyWith(copyType: () => null);
    }
  }

  void _load() {
    switch (args.source) {
      case PostSource.generate:
        _write();

      case PostSource.db:
        _loadSaved();
    }
  }

  /// 저장된 포스트 표시 (매물이 수정된 뒤 쓴 글이어도 그대로 표시)
  Future<void> _loadSaved() async {
    try {
      final property = await ref.read(propertyUseCaseProvider).get(id);
      final post = property?.blogPost;

      if (!ref.mounted) { return; }
      if (post == null) {
        _fail('저장된 포스트 없음');
        return;
      }

      final imagePaths = await _imagePaths();

      if (!ref.mounted) { return; }

      state = state.copyWith(status: PropertyWriteStatus.complete, title: post.title, body: post.body, imagePaths: imagePaths);
    } catch (e) {
      _fail(e.toString());
    }
  }

  Future<void> _write() async {
    try {
      final blogUseCase = ref.read(blogUseCaseProvider);
      final post = await blogUseCase.fetch(id) ?? await blogUseCase.write(id);

      if (!ref.mounted) { return; }
      if (post == null) {
        _fail('매물을 찾을 수 없음');
        return;
      }

      final imagePaths = await _imagePaths();

      if (!ref.mounted) { return; }

      state = state.copyWith(status: PropertyWriteStatus.complete, title: post.title, body: post.body, imagePaths: imagePaths);
    } on ApiException catch (e) {
      _fail('${e.runtimeType}: ${e.message ?? '-'}');
    } on PermissionDeniedException {
      _fail('AI 글쓰기 권한 없음');
    } catch (e) {
      _fail(e.toString());
    }
  }

  void _fail(String detail) {
    if (!ref.mounted) { return; }

    state = state.copyWith(status: PropertyWriteStatus.fail, errorDetail: () => detail);
  }

  /// AI에 보낸 사진과 같은 기준의 사진 경로 목록
  Future<List<String>> _imagePaths() async {
    // CLOVA Studio HCX-005 요청당 이미지 최대 개수
    const maxImageCount = 5;
    final property = await ref.read(propertyUseCaseProvider).get(id);
    final images = [...?property?.images]..sort((a, b) => a.order.compareTo(b.order));
    final imageStorage = ref.read(imageStorageProvider);

    return [for (final image in images.take(maxImageCount)) imageStorage.path(image.fileName)];
  }

  Future<void> _copy(PostContentType type) async {
    final (text, event) = switch (type) {
      PostContentType.title => (state.title, PropertyWriteEvent.copyTitle),
      PostContentType.body => (state.body, PropertyWriteEvent.copyBody),
      PostContentType.all => ('${state.title}\n\n${state.body}', PropertyWriteEvent.copyAll),
    };

    if (type == PostContentType.title || Platform.isIOS || Platform.isAndroid) {
      await Clipboard.setData(ClipboardData(text: text));
    } else {
      await RichClipboard.setRichText(text: text, html: md.markdownToHtml(text));
    }

    if (!ref.mounted) { return; }

    state = state.copyWith(copyType: () => event);
  }

  /// 사진 복사 함수
  ///
  /// index: null이면 전체 사진, 0 이상이면 해당 index의 사진
  Future<void> _copyImage(int? index) async {
    final paths = index == null ? state.imagePaths : [state.imagePaths[index]];

    if (paths.isEmpty) { return; }

    if (Platform.isIOS || Platform.isAndroid) {
      await Pasteboard.writeImage(await File(paths.first).readAsBytes());
    } else {
      await Pasteboard.writeFiles(paths);
    }

    if (!ref.mounted) { return; }

    state = state.copyWith(copyType: () => index == null ? PropertyWriteEvent.copyImages : PropertyWriteEvent.copyImage);
  }

  Future<void> _share() async {
    final files = [for (final path in state.imagePaths) XFile(path)];

    await SharePlus.instance.share(
      ShareParams(text: '${state.title}\n\n${state.body}', files: files.isEmpty ? null : files),
    );
  }

  Future<void> _sendEmail() async {
    const subject = '[넝쿨집사] AI 글쓰기 오류 문의';
    final body = '''
증상: AI 블로그 포스트 생성 실패
오류 내용: ${state.errorDetail ?? '-'}
문의 시각: ${DateTime.now().toString().substring(0, 19)}
OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}

추가로 전달할 내용이 있다면 아래에 적어 주세요.
''';

    await launchUrl(Uri.parse('mailto:${AppConfig.supportEmail}?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}'));
  }
}
