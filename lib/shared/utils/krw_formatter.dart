String formatKRW(int amount) {
  if (amount == 0) return '0원';

  final eok = amount ~/ 100000000;
  final remainder = amount % 100000000;
  final man = remainder ~/ 10000;
  final won = remainder % 10000;

  final parts = <String>[];
  if (eok > 0) parts.add('$eok억');
  if (man > 0) parts.add('$man만');
  if (won > 0) parts.add('$won원');

  final joined = parts.join(' ');
  return joined.endsWith('원') ? joined : '$joined원';
}
