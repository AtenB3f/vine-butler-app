enum AppBndSearchStatus {
  disable,
  enable,
  search,
  filter
}

class AppBndSearchViewState {
  final AppBndSearchStatus status;
  final String placeholder;

  const AppBndSearchViewState({
    required this.status,
    required this.placeholder,
  });
}
