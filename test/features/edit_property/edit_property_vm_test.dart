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
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_view_state.dart';

class _FakePropertyRepository implements PropertyRepository {
  Property? property;
  final List<Property> saved = [];
  bool shouldFailSave = false;

  @override
  Future<Property?> getById(String id) async => property?.id == id ? property : null;

  @override
  Future<void> save(Property property) async {
    if (shouldFailSave) { throw Exception('save failed'); }

    saved.add(property);
  }

  @override
  Stream<List<Property>> watchList() => const Stream.empty();

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) => const Stream.empty();

  @override
  Future<void> delete(String id) async {}
}

const _address = Address(
  zipCode: '06236',
  roadAddress: '서울 강남구 테헤란로 1',
  lotAddress: '서울특별시 강남구 역삼동 1-1',
  sido: '서울특별시',
  sigungu: '강남구',
  dongMyeon: '역삼동',
  detailAddress: '202호',
  latitude: 37.5006,
  longitude: 127.0364,
);

Property _property() {
  return Property(
    id: 'a',
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.villa,
    deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
    maintenanceCost: 70000,
    address: _address,
    hasLoan: false,
    isParkingAvailable: true,
    roomCount: 1,
    furnitureOptions: const ['냉장고'],
    memo: '메모',
    updatedAt: DateTime(2020),
  );
}

void main() {
  late _FakePropertyRepository repository;
  late ProviderContainer container;

  EditPropertyViewState state() => container.read(editPropertyVMProvider('a'));
  void action(EditPropertyAction action) => container.read(editPropertyVMProvider('a').notifier).action(action);

  Future<void> load() async {
    container.listen(editPropertyVMProvider('a'), (_, _) {});
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> save() async {
    action(const EditPropertyAction.save());
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = _FakePropertyRepository()..property = _property();
    container = ProviderContainer(overrides: [propertyRepositoryProvider.overrideWithValue(repository)]);
  });

  tearDown(() => container.dispose());

  test('불러온 매물 값으로 수정 화면을 채운다', () async {
    await load();

    expect(state().status, EditPropertyStatus.loaded);
    expect(state().unitAddress, '역삼동 1-1 202호');
    expect(state().regionAddress, '서울특별시 강남구');
    expect(state().transactionType, PropertyTransactionType.rent);
    expect(state().price, 10000000);
    expect(state().monthlyRent, 500000);
    expect(state().maintenanceCost, 70000);
    expect(state().ownerName, '홍길동');
    expect(state().ownerPhone, '010-1234-5678');
    expect(state().hasLoan, isFalse);
    expect(state().isParkingAvailable, isTrue);
    expect(state().roomCount, 1);
    expect(state().furnitureOptions, {'냉장고'});
    expect(state().memo, '메모');
  });

  test('매물이 없으면 찾을 수 없음 상태다', () async {
    repository.property = null;

    await load();

    expect(state().status, EditPropertyStatus.notFound);
  });

  test('거래 유형을 바꿀 때 금액이 새 범위 밖이면 중간값으로 바꾼다', () async {
    await load();

    action(const EditPropertyAction.selectTransactionType(PropertyTransactionType.buy));

    expect(state().price, state().midPrice);
  });

  test('바꾼 값으로 저장하고 저장 완료 이벤트를 보낸다', () async {
    await load();
    action(const EditPropertyAction.changeOwnerName(' 김철수 '));
    action(const EditPropertyAction.changeMaintenanceCost(0));
    action(const EditPropertyAction.selectLoan(true));
    action(const EditPropertyAction.toggleFurniture('세탁기'));
    action(const EditPropertyAction.changeMemo(' 새 메모 '));

    await save();

    final property = repository.saved.single;

    expect(property.id, 'a');
    expect(property.propertyType, PropertyType.villa);
    expect(property.owner, const Owner(name: '김철수', phone: '010-1234-5678'));
    expect(property.deal, const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000));
    expect(property.maintenanceCost, 0);
    expect(property.hasLoan, isTrue);
    expect(property.furnitureOptions, unorderedEquals(['냉장고', '세탁기']));
    expect(property.memo, '새 메모');
    expect(property.address, _address);
    expect(state().event, EditPropertyEvent.save);
  });

  test('주소를 바로 저장하면 주소만 바뀐 매물을 저장하고 이후 저장에도 새 주소를 쓴다', () async {
    await load();
    action(const EditPropertyAction.changeMemo('저장 전 메모'));
    const newAddress = Address(
      zipCode: '13561',
      roadAddress: '경기도 성남시 분당구 불정로 6',
      lotAddress: '경기도 성남시 분당구 정자동 178-1',
      sido: '경기도',
      sigungu: '성남시 분당구',
      dongMyeon: '정자동',
      detailAddress: '101호',
      latitude: 37.3595,
      longitude: 127.1052,
    );

    final isSaved = await container.read(editPropertyVMProvider('a').notifier).saveAddress(newAddress);

    expect(isSaved, isTrue);
    expect(repository.saved.single.address, newAddress);
    expect(repository.saved.single.memo, '메모');
    expect(state().address, newAddress);
    expect(state().unitAddress, '정자동 178-1 101호');
    expect(state().memo, '저장 전 메모');

    await save();

    expect(repository.saved.last.address, newAddress);
    expect(repository.saved.last.memo, '저장 전 메모');
  });

  test('주소 저장에 실패하면 false를 돌려주고 주소를 바꾸지 않는다', () async {
    await load();
    repository.shouldFailSave = true;

    final isSaved = await container.read(editPropertyVMProvider('a').notifier).saveAddress(_address.copyWith(detailAddress: '303호'));

    expect(isSaved, isFalse);
    expect(state().address, _address);
  });

  test('월세가 아니면 월세 금액을 저장하지 않는다', () async {
    await load();
    action(const EditPropertyAction.selectTransactionType(PropertyTransactionType.depositOnly));

    await save();

    expect(repository.saved.single.deal.monthlyRent, isNull);
  });

  test('임대인 이름이 비었거나 전화번호 형식이 틀리면 저장하지 않는다', () async {
    await load();
    action(const EditPropertyAction.changeOwnerPhone('010-1234'));

    await save();

    expect(repository.saved, isEmpty);
    expect(state().event, EditPropertyEvent.invalidOwner);

    container.read(editPropertyVMProvider('a').notifier).sendEvent();
    action(const EditPropertyAction.changeOwnerPhone('010-1234-5678'));
    action(const EditPropertyAction.changeOwnerName(' '));

    await save();

    expect(repository.saved, isEmpty);
    expect(state().event, EditPropertyEvent.invalidOwner);
  });

  test('저장에 실패하면 저장 실패 이벤트를 보낸다', () async {
    repository.shouldFailSave = true;
    await load();

    await save();

    expect(state().event, EditPropertyEvent.failSave);
  });
}
