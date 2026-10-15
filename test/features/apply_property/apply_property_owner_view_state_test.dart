import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_owner_view_state.dart';

void main() {
  test('전화번호가 비어 있으면 에러가 없다', () {
    expect(const ApplyPropertyOwnerViewState().hasPhoneError, isFalse);
  });

  test('입력 중인 전화번호는 형식이 맞지 않아 에러가 있다', () {
    expect(const ApplyPropertyOwnerViewState(phone: '010-12').hasPhoneError, isTrue);
  });

  test('010-0000-0000 형식이면 에러가 없다', () {
    expect(const ApplyPropertyOwnerViewState(phone: '010-1234-5678').hasPhoneError, isFalse);
  });

  test('010으로 시작하지 않으면 에러가 있다', () {
    expect(const ApplyPropertyOwnerViewState(phone: '011-1234-5678').hasPhoneError, isTrue);
  });
}
