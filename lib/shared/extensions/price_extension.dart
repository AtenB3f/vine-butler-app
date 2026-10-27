extension PriceExtension on num {
  /// 함축형 금액 표기 (`1억 2,345만 6,000원`)
  String get formattedKRW {
    final amount = toInt();

    if (amount == 0) { return '0원'; }

    final eok = amount ~/ 100000000;
    final remainder = amount % 100000000;
    final man = remainder ~/ 10000;
    final won = remainder % 10000;

    final parts = <String>[];

    if (eok > 0) { parts.add('${_withComma(eok)}억'); }
    if (man > 0) { parts.add('${_withComma(man)}만'); }
    if (won > 0) { parts.add('${_withComma(won)}원'); }

    final joined = parts.join(' ');

    return joined.endsWith('원') ? joined : '$joined원';
  }

  /// 숫자형 금액 표기 (`1,230,000`)
  String get formattedNumber => _withComma(toInt());

  static String _withComma(int value) {
    final thousands = RegExp(r'\B(?=(\d{3})+(?!\d))');

    return '$value'.replaceAll(thousands, ',');
  }
}
