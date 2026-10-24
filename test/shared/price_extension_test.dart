import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

void main() {
  group('함축형', () {
    test('억·만·원 단위마다 쉼표를 넣고 0인 단위는 뺀다', () {
      expect(1230000.formattedKRW, '123만원');
      expect(12340000.formattedKRW, '1,234만원');
      expect(123450000.formattedKRW, '1억 2,345만원');
      expect(103450000.formattedKRW, '1억 345만원');
      expect(100050000.formattedKRW, '1억 5만원');
      expect(100006000.formattedKRW, '1억 6,000원');
      expect(120006000.formattedKRW, '1억 2,000만 6,000원');
      expect(123006000.formattedKRW, '1억 2,300만 6,000원');
      expect(123456000.formattedKRW, '1억 2,345만 6,000원');
      expect(1234560000.formattedKRW, '12억 3,456만원');
    });

    test('억 단위로 끝나도 원을 붙이고 억보다 큰 단위는 쓰지 않는다', () {
      expect(100000000.formattedKRW, '1억원');
      expect(1000000000000.formattedKRW, '10,000억원');
    });

    test('0은 0원이다', () {
      expect(0.formattedKRW, '0원');
    });
  });

  test('숫자형은 천 단위 쉼표만 넣는다', () {
    expect(1230000.formattedNumber, '1,230,000');
    expect(1000000000000.formattedNumber, '1,000,000,000,000');
    expect(0.formattedNumber, '0');
  });
}
