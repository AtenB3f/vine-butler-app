class PropertyWriteViewState {
  final PropertyWriteStatus status;
  final String title;
  final String body;
  final List<String> imagePaths;
  final String? errorDetail;
  final PropertyWriteEvent? copyType;

  const PropertyWriteViewState({
    this.status = PropertyWriteStatus.loading,
    this.title = '',
    this.body = '',
    this.imagePaths = const [],
    this.errorDetail,
    this.copyType,
  });

  PropertyWriteViewState copyWith({
    PropertyWriteStatus? status,
    String? title,
    String? body,
    List<String>? imagePaths,
    String? Function()? errorDetail,
    PropertyWriteEvent? Function()? copyType,
  }) {
    return PropertyWriteViewState(
      status: status ?? this.status,
      title: title ?? this.title,
      body: body ?? this.body,
      imagePaths: imagePaths ?? this.imagePaths,
      errorDetail: errorDetail != null ? errorDetail() : this.errorDetail,
      copyType: copyType != null ? copyType() : this.copyType,
    );
  }
}

enum PropertyWriteStatus {
  loading,
  fail,
  complete,
}

enum PropertyWriteEvent {
  copyTitle,
  copyBody,
  copyAll,
  copyImage,
  copyImages,
}

/// 텍스트 복사 대상
///
/// - `title`: 제목
/// - `body`: 본문
/// - `all`: 제목 + 본문
enum PostContentType {
  title,
  body,
  all,
}
