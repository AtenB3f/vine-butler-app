import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';

class _FakePropertyRepository implements PropertyRepository {
  Property? property;
  final List<String> deletedIds = [];
  bool shouldFailDelete = false;

  @override
  Future<Property?> getById(String id) async => property?.id == id ? property : null;

  @override
  Stream<List<Property>> watchList() => const Stream.empty();

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) => const Stream.empty();

  @override
  Future<void> save(Property property) async {}

  @override
  Future<void> delete(String id) async {
    if (shouldFailDelete) { throw Exception('delete failed'); }

    deletedIds.add(id);
  }
}

Property _property({
  bool? hasLoan,
  String memo = '',
  String lotAddress = '서울특별시 강남구 역삼동 1-1 역삼빌딩',
  String sido = '서울특별시',
  String sigungu = '강남구',
  String detailAddress = '202호',
}) {
  return Property(
    id: 'a',
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.villa,
    deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
    maintenanceCost: 120000,
    address: Address(
      zipCode: '06236',
      roadAddress: '서울 강남구 테헤란로 1',
      lotAddress: lotAddress,
      sido: sido,
      sigungu: sigungu,
      dongMyeon: '역삼동',
      detailAddress: detailAddress,
      latitude: 37.5006,
      longitude: 127.0364,
    ),
    isParkingAvailable: true,
    isSuretyInsuranceAvailable: false,
    hasLoan: hasLoan,
    moveInDate: DateTime(2026, 11, 1),
    isFlexibleMoveInDate: true,
    furnitureOptions: const ['냉장고'],
    memo: memo,
    updatedAt: DateTime(2020),
  );
}

void main() {
  late _FakePropertyRepository repository;
  late ProviderContainer container;

  PropertyDetailViewState state() => container.read(propertyDetailVMProvider('a'));

  Future<void> load() async {
    container.listen(propertyDetailVMProvider('a'), (_, _) {});
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = _FakePropertyRepository();
    container = ProviderContainer(overrides: [propertyRepositoryProvider.overrideWithValue(repository)]);
  });

  tearDown(() => container.dispose());

  test('불러오기 전에는 로딩 상태다', () {
    repository.property = _property();

    expect(state().status, PropertyDetailStatus.loading);
    expect(state().data, isNull);
  });

  test('매물이 있으면 상세 데이터로 바꿔 보여준다', () async {
    repository.property = _property(hasLoan: true, memo: '메모');

    await load();

    final data = state().data!;

    expect(state().status, PropertyDetailStatus.loaded);
    expect(data.unitAddress, '역삼동 1-1 202호');
    expect(data.address, '서울특별시 강남구');
    expect(data.hasImages, isFalse);
    expect(data.transactionType, PropertyTransactionType.rent);
    expect(data.amount, 10000000);
    expect(data.monthlyAmount, 500000);
    expect(data.maintenanceCost, 120000);
    expect(data.ownerPhone, '010-1234-5678');
    expect(data.isAvailableParking, isTrue);
    expect(data.isAvailableSuretyInsurance, isFalse);
    expect(data.isAvailableLoan, isTrue);
    expect(data.moveInDate, DateTime(2026, 11, 1));
    expect(data.isAvailableMoveInDate, isTrue);
    expect(data.furnitureOptions, ['냉장고']);
    expect(data.memo, '메모');
    expect(data.latitude, 37.5006);
    expect(data.longitude, 127.0364);
    expect(data.areaExclusive, isNull);
  });

  test('융자를 선택하지 않았으면 융자 값이 없고 빈 메모는 null이다', () async {
    repository.property = _property();

    await load();

    expect(state().data!.isAvailableLoan, isNull);
    expect(state().data!.memo, isNull);
  });

  test('매물이 없으면 찾을 수 없음 상태다', () async {
    await load();

    expect(state().status, PropertyDetailStatus.notFound);
    expect(state().data, isNull);
  });

  group('주소 표기', () {
    Future<PropertyDetailData> loadWith(Property property) async {
      repository.property = property;
      await load();
      return state().data!;
    }

    test('상세 주소가 없으면 읍면동과 번지만 쓴다', () async {
      final data = await loadWith(_property(detailAddress: ''));

      expect(data.unitAddress, '역삼동 1-1');
    });

    test('리와 산 번지를 함께 남긴다', () async {
      final data = await loadWith(
        _property(lotAddress: '경기도 가평군 가평읍 읍내리 산12-3', sido: '경기도', sigungu: '가평군', detailAddress: ''),
      );

      expect(data.unitAddress, '가평읍 읍내리 산12-3');
      expect(data.address, '경기도 가평군');
    });

    test('동 이름에 붙은 숫자는 번지로 보지 않는다', () async {
      final data = await loadWith(
        _property(lotAddress: '서울특별시 중구 을지로3가 12-1 을지빌딩', sido: '서울특별시', sigungu: '중구', detailAddress: ''),
      );

      expect(data.unitAddress, '을지로3가 12-1');
    });

    test('시/군/구가 없으면 시/도만 쓴다', () async {
      final data = await loadWith(
        _property(lotAddress: '세종특별자치시 어진동 573 정부세종청사', sido: '세종특별자치시', sigungu: '', detailAddress: '101호'),
      );

      expect(data.unitAddress, '어진동 573 101호');
      expect(data.address, '세종특별자치시');
    });
  });

  group('삭제', () {
    void delete() => container.read(propertyDetailVMProvider('a').notifier).action(PropertyDetailAction.delete);

    test('삭제하면 매물을 지우고 삭제 이벤트를 보낸다', () async {
      repository.property = _property();
      await load();

      delete();
      await Future<void>.delayed(Duration.zero);

      expect(repository.deletedIds, ['a']);
      expect(state().event, PropertyDetailEvent.delete);
    });

    test('삭제에 실패하면 삭제 실패 이벤트를 보낸다', () async {
      repository
        ..property = _property()
        ..shouldFailDelete = true;
      await load();

      delete();
      await Future<void>.delayed(Duration.zero);

      expect(repository.deletedIds, isEmpty);
      expect(state().event, PropertyDetailEvent.failDelete);
    });
  });
}
