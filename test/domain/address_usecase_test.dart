import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';
import 'package:vine_butler/domain/usecase/address_usecase.dart';

class _FakeAddressRepository implements AddressRepository {
  final List<String> queries = [];
  final List<String> locatedAddresses = [];
  int? lastPage;
  ({double latitude, double longitude})? coordinate = (latitude: 37.3595033, longitude: 127.105216);

  @override
  Future<AddressPage> search(String query, {int page = 1}) async {
    queries.add(query);
    lastPage = page;
    return const AddressPage(addresses: [], totalCount: 0);
  }

  @override
  Future<({double latitude, double longitude})?> locate(String roadAddress) async {
    locatedAddresses.add(roadAddress);
    return coordinate;
  }
}

const _candidate = AddressCandidate(
  zipCode: '13561',
  roadAddress: '경기도 성남시 분당구 불정로 6 (정자동)',
  baseRoadAddress: '경기도 성남시 분당구 불정로 6',
  lotAddress: '경기도 성남시 분당구 정자동 178-1',
  sido: '경기도',
  sigungu: '성남시 분당구',
  dongMyeon: '정자동',
);

void main() {
  late _FakeAddressRepository repository;
  late AddressUseCase useCase;

  setUp(() {
    repository = _FakeAddressRepository();
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

    expect(repository.lastPage, 3);
  });

  test('참고항목을 뺀 도로명주소로 좌표를 찾아 Address로 합친다', () async {
    final address = await useCase.locate(_candidate);

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
    repository.coordinate = null;

    expect(await useCase.locate(_candidate), isNull);
  });
}
