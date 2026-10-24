import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

enum _PriceKey {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  zero,
  doubleZero,
  thousand,
  man,
  eok,
  remove,
  confirm,
}

/// 금액 입력 키패드
///
/// - `만`·`억` 입력 시 앞서 입력된 값에 단위를 곱하고 이후 입력되는 값을 더함
/// - remove 시 입력된 가장 마지막 숫자를 지움
class PriceKeypad extends StatefulWidget {
  /// 입력할 수 있는 최대 금액 (10,000억)
  static const int maxValue = 1000000000000;

  final PriceKeypadViewState viewState;
  final ValueChanged<int> onChanged;
  final VoidCallback onConfirm;

  const PriceKeypad({
    super.key,
    required this.viewState,
    required this.onChanged,
    required this.onConfirm,
  });

  static Widget animated({PriceKeypad? keypad, Widget placeholder = const SizedBox.shrink()}) {
    const keypadKey = ValueKey('keypad');

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.bottomCenter,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) {
        if (child.key != keypadKey) { return child; }

        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
          child: child,
        );
      },
      child: keypad == null
          ? KeyedSubtree(key: const ValueKey('placeholder'), child: placeholder)
          : KeyedSubtree(key: keypadKey, child: keypad),
    );
  }

  @override
  State<PriceKeypad> createState() => _PriceKeypadState();
}

class _PriceKeypadState extends State<PriceKeypad> {
  static const List<List<_PriceKey>> _rows = [
    [_PriceKey.seven, _PriceKey.eight, _PriceKey.nine, _PriceKey.remove],
    [_PriceKey.four, _PriceKey.five, _PriceKey.six, _PriceKey.man],
    [_PriceKey.one, _PriceKey.two, _PriceKey.three, _PriceKey.eok],
    [_PriceKey.zero, _PriceKey.doubleZero, _PriceKey.thousand, _PriceKey.confirm],
  ];

  late int _committed = widget.viewState.value;
  int _pending = 0;

  @override
  void didUpdateWidget(covariant PriceKeypad oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewState.value != _committed + _pending) {
      _committed = widget.viewState.value;
      _pending = 0;
    }
  }

  /// 키패드 본체
  ///
  /// - 키 사이 빈 곳을 눌러도 바깥 탭(`AppScaffold`의 포커스 해제)으로 전달되지 않게 탭을 막음
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
          color: StateColor.white,
          border: Border(top: BorderSide(color: BaseColor.medium)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [for (final row in _rows) _row(row)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<_PriceKey> keys) {
    return Row(
      children: [for (final key in keys) Expanded(child: _key(key))],
    );
  }

  Widget _key(_PriceKey key) {
    final isAction = key == _PriceKey.remove || key == _PriceKey.confirm;

    return Pressable(
      onTap: () => _onTap(key),
      child: Container(
        height: 54,
        color: isAction ? BaseColor.light : StateColor.white,
        alignment: Alignment.center,
        child: _label(key),
      ),
    );
  }

  Widget _label(_PriceKey key) {
    return switch (key) {
      _PriceKey.remove => AppIcons.removeLG(TextColor.dark),
      _PriceKey.confirm => AppIcons.chevronRightMD(TextColor.dark),
      _PriceKey.one => AppFontStyle.sub2.text('1', TextColor.dark),
      _PriceKey.two => AppFontStyle.sub2.text('2', TextColor.dark),
      _PriceKey.three => AppFontStyle.sub2.text('3', TextColor.dark),
      _PriceKey.four => AppFontStyle.sub2.text('4', TextColor.dark),
      _PriceKey.five => AppFontStyle.sub2.text('5', TextColor.dark),
      _PriceKey.six => AppFontStyle.sub2.text('6', TextColor.dark),
      _PriceKey.seven => AppFontStyle.sub2.text('7', TextColor.dark),
      _PriceKey.eight => AppFontStyle.sub2.text('8', TextColor.dark),
      _PriceKey.nine => AppFontStyle.sub2.text('9', TextColor.dark),
      _PriceKey.zero => AppFontStyle.sub2.text('0', TextColor.dark),
      _PriceKey.doubleZero => AppFontStyle.sub2.text('00', TextColor.dark),
      _PriceKey.thousand => AppFontStyle.sub2.text(',000', TextColor.dark),
      _PriceKey.man => AppFontStyle.sub2.text('만', TextColor.dark),
      _PriceKey.eok => AppFontStyle.sub2.text('억', TextColor.dark),
    };
  }

  void _onTap(_PriceKey key) {
    if (key == _PriceKey.confirm) { return widget.onConfirm(); }

    final value = _committed + _pending;
    final next = switch (key) {
      _PriceKey.remove => _pending > 0 ? (_committed, _pending ~/ 10) : (_committed ~/ 10, 0),
      _PriceKey.one => _append(10, 1),
      _PriceKey.two => _append(10, 2),
      _PriceKey.three => _append(10, 3),
      _PriceKey.four => _append(10, 4),
      _PriceKey.five => _append(10, 5),
      _PriceKey.six => _append(10, 6),
      _PriceKey.seven => _append(10, 7),
      _PriceKey.eight => _append(10, 8),
      _PriceKey.nine => _append(10, 9),
      _PriceKey.zero => _append(10, 0),
      _PriceKey.doubleZero => _append(100, 0),
      _PriceKey.thousand => _append(1000, 0),
      _PriceKey.man => _addUnit(10000),
      _PriceKey.eok => _addUnit(100000000),
      _PriceKey.confirm => (_committed, _pending),
    };

    if (next == null) { return; }

    _committed = next.$1;
    _pending = next.$2;
    final nextValue = _committed + _pending;

    if (nextValue != value) { widget.onChanged(nextValue); }
  }

  (int, int)? _append(int multiplier, int digit) {
    if (_pending > (PriceKeypad.maxValue - _committed) ~/ multiplier) { return null; }

    final pending = _pending * multiplier + digit;

    if (_committed + pending > PriceKeypad.maxValue) { return null; }

    return (_committed, pending);
  }

  (int, int)? _addUnit(int unit) {
    if (_pending > (PriceKeypad.maxValue - _committed) ~/ unit) { return null; }

    return (_committed + _pending * unit, 0);
  }
}
