import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';
import 'package:vine_butler/domain/usecase/address_usecase.dart';

class _FakeAddressRepository implements AddressRepository {
  final List<String> queries = [];
  ({double latitude, double longitude})? lastCoordinate;

  @override
  Future<List<Address>> search(String query, {({double latitude, double longitude})? coordinate}) async {
    queries.add(query);
    lastCoordinate = coordinate;
    return const [];
  }
}

void main() {
  late _FakeAddressRepository repository;
  late AddressUseCase useCase;

  setUp(() {
    repository = _FakeAddressRepository();
    useCase = AddressUseCase(repository);
  });

  test('공백뿐인 검색어는 Repository를 호출하지 않는다', () async {
    expect(await useCase.search('   '), isEmpty);
    expect(repository.queries, isEmpty);
  });

  test('검색어 앞뒤 공백을 제거해 검색한다', () async {
    await useCase.search('  불정로 6 ');

    expect(repository.queries, ['불정로 6']);
  });

  test('coordinate를 Repository에 그대로 전달한다', () async {
    await useCase.search('불정로 6', coordinate: (latitude: 37.3595963, longitude: 127.1054328));

    expect(repository.lastCoordinate, (latitude: 37.3595963, longitude: 127.1054328));
  });
}
