import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/usecase/address_usecase.dart';

import '../../helpers/fakes/fake_address_repository.dart';
import '../../helpers/fixtures.dart';

void main() {
  late FakeAddressRepository repository;
  late AddressUseCase useCase;

  setUp(() {
    repository = FakeAddressRepository();
    useCase = AddressUseCase(repository);
  });

  test('공백뿐인 검색어는 Repository를 호출하지 않는다', () async {
    expect((await useCase.search('   ')).addresses, isEmpty);
    expect(repository.queries, isEmpty);
  });

  test('검색어 앞뒤 공백을 제거해 검색한다', () async {
    await useCase.search('  불정로 6 ');

    expect(repository.queries, ['불정로 6']);
  });

  test('page를 Repository에 그대로 전달한다', () async {
    await useCase.search('불정로', page: 3);

    expect(repository.pages, [3]);
  });

  test('참고항목을 뺀 도로명주소로 좌표를 찾아 Address로 합친다', () async {
    final address = await useCase.locate(bundangCandidate);

    expect(repository.locatedAddresses, ['경기도 성남시 분당구 불정로 6']);
    expect(address!.roadAddress, '경기도 성남시 분당구 불정로 6 (정자동)');
    expect(address.lotAddress, '경기도 성남시 분당구 정자동 178-1');
    expect(address.zipCode, '13561');
    expect(address.sido, '경기도');
    expect(address.sigungu, '성남시 분당구');
    expect(address.dongMyeon, '정자동');
    expect(address.latitude, 37.3595033);
    expect(address.longitude, 127.105216);
  });

  test('좌표를 못 찾으면 null이다', () async {
    repository.respondLocate = (_) async => null;

    expect(await useCase.locate(bundangCandidate), isNull);
  });
}
