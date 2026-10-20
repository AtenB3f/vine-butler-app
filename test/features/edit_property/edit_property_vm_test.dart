import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/image_storage.dart';
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

class _FakeImageStorage implements ImageStorage {
  final List<String> deleted = [];
  int _count = 0;

  @override
  Future<String> save(String sourcePath) async => 'new-${_count++}.jpg';

  @override
  Future<void> delete(String fileName) async => deleted.add(fileName);

  @override
  String path(String fileName) => 'images/$fileName';
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
    images: [
      PropertyImage(id: 'img-0', fileName: 'old-0.jpg', order: 0, createdAt: DateTime(2020)),
      PropertyImage(id: 'img-1', fileName: 'old-1.jpg', order: 1, createdAt: DateTime(2020)),
    ],
    updatedAt: DateTime(2020),
  );
}

void main() {
  late _FakePropertyRepository repository;
  late _FakeImageStorage imageStorage;
  late ProviderContainer container;

  EditPropertyViewState state() => container.read(editPropertyVMProvider('a'));
  void action(EditPropertyAction action) => container.read(editPropertyVMProvider('a').notifier).action(action);

  Future<ProviderSubscription<EditPropertyViewState>> load() async {
    final subscription = container.listen(editPropertyVMProvider('a'), (_, _) {});

    await Future<void>.delayed(Duration.zero);
    return subscription;
  }

  Future<void> save() async {
    action(const EditPropertyAction.save());
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() {
    repository = _FakePropertyRepository()..property = _property();
    imageStorage = _FakeImageStorage();
    container = ProviderContainer(
      overrides: [
        propertyRepositoryProvider.overrideWithValue(repository),
        imageStorageProvider.overrideWithValue(imageStorage),
      ],
    );
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

  test('추가한 이미지는 뒤에 붙고 저장 시 순서대로 번호를 매긴다', () async {
    await load();
    action(const EditPropertyAction.addImages(['/picked/a.jpg', '/picked/b.png']));
    await Future<void>.delayed(Duration.zero);
    action(const EditPropertyAction.removeImage('img-0'));

    await save();

    final images = repository.saved.single.images;

    expect([for (final image in images) image.fileName], ['old-1.jpg', 'new-0.jpg', 'new-1.jpg']);
    expect([for (final image in images) image.order], [0, 1, 2]);
  });

  test('저장하면 뺀 이미지 파일만 지운다', () async {
    await load();
    action(const EditPropertyAction.addImages(['/picked/a.jpg', '/picked/b.jpg']));
    await Future<void>.delayed(Duration.zero);
    action(const EditPropertyAction.removeImage('img-1'));
    action(EditPropertyAction.removeImage(state().images.last.id));

    await save();

    expect(imageStorage.deleted, unorderedEquals(['old-1.jpg', 'new-1.jpg']));
  });

  test('저장하지 않고 나가면 새로 추가한 이미지 파일을 지운다', () async {
    final subscription = await load();

    action(const EditPropertyAction.addImages(['/picked/a.jpg']));
    await Future<void>.delayed(Duration.zero);
    subscription.close();
    await Future<void>.delayed(Duration.zero);

    expect(imageStorage.deleted, ['new-0.jpg']);
  });

  test('저장한 뒤 나가면 이미지 파일을 지우지 않는다', () async {
    final subscription = await load();

    action(const EditPropertyAction.addImages(['/picked/a.jpg']));
    await Future<void>.delayed(Duration.zero);
    await save();
    subscription.close();
    await Future<void>.delayed(Duration.zero);

    expect(imageStorage.deleted, isEmpty);
  });
}
