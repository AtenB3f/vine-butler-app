class PriceFieldViewState {
  final String text;
  final String? subText;
  final bool isFocused;

  const PriceFieldViewState({
    required this.text,
    this.subText,
    this.isFocused = false,
  });
}
