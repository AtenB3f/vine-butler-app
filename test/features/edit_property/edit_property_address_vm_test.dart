import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/features/edit_property/edit_property_address_vm.dart';
import 'package:vine_butler/features/edit_property/edit_property_vm.dart';
import 'package:vine_butler/features/edit_property/presentation/edit_property_address_view_state.dart';

const _candidate = AddressCandidate(
  zipCode: '13561',
  roadAddress: '경기도 성남시 분당구 불정로 6 (정자동)',
  baseRoadAddress: '경기도 성남시 분당구 불정로 6',
  lotAddress: '경기도 성남시 분당구 정자동 178-1',
  sido: '경기도',
  sigungu: '성남시 분당구',
  dongMyeon: '정자동',
);

const _currentAddress = Address(
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

class _FakeAddressRepository implements AddressRepository {
  final List<String> queries = [];

  @override
  Future<AddressPage> search(String query, {int page = 1}) async {
    queries.add(query);
    return const AddressPage(addresses: [_candidate], totalCount: 1);
  }

  @override
  Future<({double latitude, double longitude})?> locate(String roadAddress) async =>
      (latitude: 37.3595033, longitude: 127.105216);
}

class _FakePropertyRepository implements PropertyRepository {
  final List<Property> saved = [];
  bool shouldFailSave = false;

  @override
  Future<Property?> getById(String id) async => Property(
        id: id,
        owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
        propertyType: PropertyType.villa,
        deal: const PropertyDeal(transactionType: PropertyTransactionType.buy, price: 300000000),
        address: _currentAddress,
        updatedAt: DateTime(2020),
      );

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

const _afterDebounce = Duration(milliseconds: 400);

void main() {
  late _FakeAddressRepository addressRepository;
  late _FakePropertyRepository propertyRepository;
  late ProviderContainer container;

  EditPropertyAddressViewState state() => container.read(editPropertyAddressVMProvider('a'));
  void action(EditPropertyAddressAction action) =>
      container.read(editPropertyAddressVMProvider('a').notifier).action(action);

  Future<void> selectCandidate() async {
    action(const EditPropertyAddressAction.resetAddress());
    action(const EditPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);
    action(EditPropertyAddressAction.select(AddressResultViewState.fromDomain(_candidate)));
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() async {
    addressRepository = _FakeAddressRepository();
    propertyRepository = _FakePropertyRepository();
    container = ProviderContainer(
      overrides: [
        addressRepositoryProvider.overrideWithValue(addressRepository),
        propertyRepositoryProvider.overrideWithValue(propertyRepository),
      ],
    );
    container.listen(editPropertyVMProvider('a'), (_, _) {});
    await Future<void>.delayed(Duration.zero);
    container.listen(editPropertyAddressVMProvider('a'), (_, _) {});
  });

  tearDown(() => container.dispose());

  test('처음에는 현재 주소와 상세 주소로 상세 주소 단계를 보여준다', () {
    expect(state().step, EditPropertyAddressStep.detail);
    expect(state().detailAddress, '202호');
    expect(state().unitAddress, '역삼동 1-1 202호');
    expect(state().regionAddress, '서울특별시 강남구');
  });

  test('상세 주소 단계에서 입력하면 큰 타이틀에 바로 반영하고 검색 단계에서는 저장된 주소를 보여준다', () {
    action(const EditPropertyAddressAction.inputDetail(' 303호 '));

    expect(state().unitAddress, '역삼동 1-1 303호');

    action(const EditPropertyAddressAction.inputDetail(''));

    expect(state().unitAddress, '역삼동 1-1');

    action(const EditPropertyAddressAction.resetAddress());

    expect(state().unitAddress, '역삼동 1-1 202호');
  });

  test('상세 주소만 바꿔 저장하면 DB와 수정 화면 주소를 바꾸고 닫는다', () async {
    action(const EditPropertyAddressAction.inputDetail(' 303호 '));

    action(const EditPropertyAddressAction.saveDetail());
    await Future<void>.delayed(Duration.zero);

    expect(propertyRepository.saved.single.address, _currentAddress.copyWith(detailAddress: '303호'));
    expect(container.read(editPropertyVMProvider('a')).address!.detailAddress, '303호');
    expect(state().isCompleted, isTrue);
  });

  test('주소 재설정을 누르면 검색 단계로 바뀌고 연속 입력은 마지막 입력으로 한 번만 검색한다', () async {
    action(const EditPropertyAddressAction.resetAddress());

    expect(state().step, EditPropertyAddressStep.search);

    action(const EditPropertyAddressAction.search('불'));
    action(const EditPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);

    expect(addressRepository.queries, ['불정로 6']);
    expect(state().results.single.zipCode, '13561');
  });

  test('주소를 고르면 지도 확인 단계로 바뀌고 새 주소를 보여준다', () async {
    await selectCandidate();

    expect(state().step, EditPropertyAddressStep.confirm);
    expect(state().located!.latitude, 37.3595033);
    expect(state().canSaveAddress, isTrue);
    expect(state().detailAddress, '');
    expect(state().unitAddress, '정자동 178-1');

    action(const EditPropertyAddressAction.inputDetail('101호'));

    expect(state().unitAddress, '정자동 178-1 101호');
    expect(state().regionAddress, '경기도 성남시 분당구');
  });

  test('다시 입력하면 이전 검색어와 결과로 검색 단계에 돌아간다', () async {
    await selectCandidate();

    action(const EditPropertyAddressAction.retry());

    expect(state().step, EditPropertyAddressStep.search);
    expect(state().query, '불정로 6');
    expect(state().results.single.zipCode, '13561');
    expect(state().located, isNull);
  });

  test('새 주소를 저장하면 상세 주소를 붙여 DB와 수정 화면에 반영하고 닫는다', () async {
    await selectCandidate();
    action(const EditPropertyAddressAction.inputDetail(' 101호 '));

    action(const EditPropertyAddressAction.saveAddress());
    await Future<void>.delayed(Duration.zero);

    final saved = propertyRepository.saved.single.address;

    expect(saved.roadAddress, _candidate.roadAddress);
    expect(saved.detailAddress, '101호');
    expect(saved.latitude, 37.3595033);
    expect(container.read(editPropertyVMProvider('a')).address, saved);
    expect(state().isCompleted, isTrue);
  });

  test('저장에 실패하면 오류 메시지를 보내고 닫지 않는다', () async {
    propertyRepository.shouldFailSave = true;

    action(const EditPropertyAddressAction.saveDetail());
    await Future<void>.delayed(Duration.zero);

    expect(state().errorMessage, isNotNull);
    expect(state().isCompleted, isFalse);
    expect(state().isSaving, isFalse);
  });
}
