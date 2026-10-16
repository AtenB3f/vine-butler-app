import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/core/di/providers.dart';
import 'package:vine_butler/core/network/api_exception.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';
import 'package:vine_butler/domain/model/address_page.dart';
import 'package:vine_butler/domain/repository/address_repository.dart';
import 'package:vine_butler/features/apply_property/apply_property_address_vm.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';

const _address = AddressCandidate(
  zipCode: '13561',
  roadAddress: '경기도 성남시 분당구 불정로 6 (정자동)',
  baseRoadAddress: '경기도 성남시 분당구 불정로 6',
  lotAddress: '경기도 성남시 분당구 정자동 178-1 NAVER그린팩토리',
  sido: '경기도',
  sigungu: '성남시 분당구',
  dongMyeon: '정자동',
);

class _FakeAddressRepository implements AddressRepository {
  final List<String> queries = [];
  final List<int> pages = [];
  final List<String> locatedAddresses = [];
  int? totalCount;
  Future<List<AddressCandidate>> Function(String query, int page) respond = (_, _) async => const [_address];
  Future<({double latitude, double longitude})?> Function(String roadAddress) respondLocate = (_) async =>
      (latitude: 37.3595033, longitude: 127.105216);

  @override
  Future<AddressPage> search(String query, {int page = 1}) async {
    queries.add(query);
    pages.add(page);
    final addresses = await respond(query, page);

    return AddressPage(addresses: addresses, totalCount: totalCount ?? addresses.length);
  }

  @override
  Future<({double latitude, double longitude})?> locate(String roadAddress) {
    locatedAddresses.add(roadAddress);
    return respondLocate(roadAddress);
  }
}

const _afterDebounce = Duration(milliseconds: 500);

void main() {
  late _FakeAddressRepository repository;
  late ProviderContainer container;

  ApplyPropertyAddressViewState state() => container.read(applyPropertyAddressVMProvider);
  void action(ApplyPropertyAddressAction action) =>
      container.read(applyPropertyAddressVMProvider.notifier).action(action);

  setUp(() {
    repository = _FakeAddressRepository();
    container = ProviderContainer(overrides: [addressRepositoryProvider.overrideWithValue(repository)]);
    container.listen(applyPropertyAddressVMProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('연속으로 입력하면 마지막 입력으로 한 번만 검색한다', () async {
    action(const ApplyPropertyAddressAction.search('불'));
    action(const ApplyPropertyAddressAction.search('불정'));
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);

    expect(repository.queries, ['불정로 6']);
  });

  test('디바운스 시간 전에는 검색하지 않는다', () async {
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(const Duration(milliseconds: 200));

    expect(repository.queries, isEmpty);
  });

  test('검색 결과를 화면 값으로 매핑하고 도메인 주소를 보존한다', () async {
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);

    final result = state().results.single;

    expect(state().isSearching, isFalse);
    expect(result.zipCode, '13561');
    expect(result.address, _address.roadAddress);
    expect(result.lotAddress, _address.lotAddress);
    expect(result.source, _address);
  });

  test('검색 중에는 이전 결과를 유지하고 찾을 수 없음 상태가 아니다', () async {
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);
    repository.respond = (_, _) async => const [];

    action(const ApplyPropertyAddressAction.search('없는 주소'));

    expect(state().isSearching, isTrue);
    expect(state().isNotFound, isFalse);
    expect(state().results, hasLength(1));
  });

  test('첫 검색 응답 전에는 결과가 비어 있어도 찾을 수 없음 상태가 아니다', () {
    action(const ApplyPropertyAddressAction.search('불정로 6'));

    expect(state().results, isEmpty);
    expect(state().isNotFound, isFalse);
  });

  test('결과가 없으면 찾을 수 없음 상태가 된다', () async {
    repository.respond = (_, _) async => const [];

    action(const ApplyPropertyAddressAction.search('동작구청'));
    await Future<void>.delayed(_afterDebounce);

    expect(state().results, isEmpty);
    expect(state().isNotFound, isTrue);
  });

  test('공백만 입력하면 검색하지 않고 결과를 비운다', () async {
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);

    action(const ApplyPropertyAddressAction.search('  '));

    expect(state().results, isEmpty);
    expect(state().isSearching, isFalse);

    await Future<void>.delayed(_afterDebounce);

    expect(repository.queries, ['불정로 6']);
    expect(state().results, isEmpty);
    expect(state().isSearching, isFalse);
  });

  test('API 오류가 나면 오류 메시지를 세팅하고 clearError로 지운다', () async {
    repository.respond = (_, _) async => throw const ApiException.quotaExceeded();

    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);

    expect(state().errorMessage, isNotNull);
    expect(state().isSearching, isFalse);
    expect(state().results, isEmpty);

    action(const ApplyPropertyAddressAction.clearError());

    expect(state().errorMessage, isNull);
  });

  test('먼저 보낸 요청의 응답이 늦게 오면 무시한다', () async {
    final slow = Completer<List<AddressCandidate>>();

    repository.respond = (query, _) => query == '불정로' ? slow.future : Future.value(const [_address]);

    action(const ApplyPropertyAddressAction.search('불정로'));
    await Future<void>.delayed(_afterDebounce);
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);
    slow.complete(const []);
    await Future<void>.delayed(Duration.zero);

    expect(state().query, '불정로 6');
    expect(state().results, hasLength(1));
  });

  test('주소를 선택한 뒤 도착한 응답은 무시한다', () async {
    final slow = Completer<List<AddressCandidate>>();

    repository.respond = (_, _) => slow.future;
    final selected = AddressResultViewState.fromDomain(_address);

    action(const ApplyPropertyAddressAction.search('불정로 6'));
    await Future<void>.delayed(_afterDebounce);
    action(ApplyPropertyAddressAction.select(selected));
    slow.complete(const [_address, _address]);
    await Future<void>.delayed(Duration.zero);

    expect(state().selected, selected);
    expect(state().results, isEmpty);
  });

  test('선택하면 대기 중인 검색을 취소한다', () async {
    action(const ApplyPropertyAddressAction.search('불정로 6'));
    action(ApplyPropertyAddressAction.select(AddressResultViewState.fromDomain(_address)));
    await Future<void>.delayed(_afterDebounce);

    expect(repository.queries, isEmpty);
  });

  group('다음 페이지', () {
    List<AddressCandidate> pageOf(int count) => List.filled(count, _address);

    Future<void> searchFirstPage() async {
      action(const ApplyPropertyAddressAction.search('불정로'));
      await Future<void>.delayed(_afterDebounce);
    }

    setUp(() {
      repository.totalCount = 25;
      repository.respond = (_, page) async => pageOf(page < 3 ? 10 : 5);
    });

    test('끝까지 이어 붙이고 더 없으면 요청하지 않는다', () async {
      await searchFirstPage();
      expect(state().results, hasLength(10));
      expect(state().hasMore, isTrue);

      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);
      expect(state().results, hasLength(20));
      expect(state().page, 2);

      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);
      expect(state().results, hasLength(25));
      expect(state().hasMore, isFalse);

      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);
      expect(repository.pages, [1, 2, 3]);
    });

    test('불러오는 중에 다시 호출해도 요청은 한 번만 보낸다', () async {
      await searchFirstPage();

      action(const ApplyPropertyAddressAction.loadMore());
      expect(state().isLoading, isTrue);
      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);

      expect(repository.pages, [1, 2]);
      expect(state().isLoading, isFalse);
    });

    test('다음 페이지 응답 전에 새로 검색하면 늦게 온 응답은 버린다', () async {
      final slow = Completer<List<AddressCandidate>>();

      await searchFirstPage();
      repository.respond = (_, page) => page == 2 ? slow.future : Future.value(pageOf(10));

      action(const ApplyPropertyAddressAction.loadMore());
      action(const ApplyPropertyAddressAction.search('테헤란로'));
      await Future<void>.delayed(_afterDebounce);
      slow.complete(pageOf(10));
      await Future<void>.delayed(Duration.zero);

      expect(state().query, '테헤란로');
      expect(state().results, hasLength(10));
      expect(state().page, 1);
      expect(repository.pages, [1, 2, 1]);
    });

    test('다음 페이지 실패 시 기존 결과를 유지하고 오류를 알린다', () async {
      await searchFirstPage();
      repository.respond = (_, _) async => throw const ApiException.network();

      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);

      expect(state().results, hasLength(10));
      expect(state().isLoading, isFalse);
      expect(state().page, 1);
      expect(state().errorMessage, isNotNull);
    });

    test('다음 페이지가 비어 있으면 더 요청하지 않는다', () async {
      await searchFirstPage();
      repository.respond = (_, _) async => const [];

      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);
      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);

      expect(repository.pages, [1, 2]);
      expect(state().hasMore, isFalse);
    });

    test('주소를 선택한 뒤에는 다음 페이지를 요청하지 않는다', () async {
      await searchFirstPage();
      action(ApplyPropertyAddressAction.select(state().results.first));

      action(const ApplyPropertyAddressAction.loadMore());
      await Future<void>.delayed(Duration.zero);

      expect(repository.pages, [1]);
    });
  });

  group('좌표 조회', () {
    final selected = AddressResultViewState.fromDomain(_address);

    test('주소를 선택하면 참고항목을 뺀 도로명주소로 좌표를 찾고 다음으로 갈 수 있다', () async {
      action(ApplyPropertyAddressAction.select(selected));

      expect(state().isLocating, isTrue);
      expect(state().canProceed, isFalse);

      await Future<void>.delayed(Duration.zero);

      expect(repository.locatedAddresses, ['경기도 성남시 분당구 불정로 6']);
      expect(state().isLocating, isFalse);
      expect(state().located!.roadAddress, _address.roadAddress);
      expect(state().located!.latitude, 37.3595033);
      expect(state().located!.longitude, 127.105216);
      expect(state().canProceed, isTrue);
    });

    test('좌표를 얻기 전에는 다음으로 이동하지 않는다', () {
      repository.respondLocate = (_) => Completer<({double latitude, double longitude})?>().future;

      action(ApplyPropertyAddressAction.select(selected));
      action(const ApplyPropertyAddressAction.next());

      expect(state().navigateTo, isNull);
    });

    test('좌표를 얻으면 다음으로 이동한다', () async {
      action(ApplyPropertyAddressAction.select(selected));
      await Future<void>.delayed(Duration.zero);
      action(const ApplyPropertyAddressAction.next());

      expect(state().navigateTo, isNotNull);
    });

    test('좌표를 못 찾으면 오류를 알리고 다음으로 갈 수 없다', () async {
      repository.respondLocate = (_) async => null;

      action(ApplyPropertyAddressAction.select(selected));
      await Future<void>.delayed(Duration.zero);

      expect(state().isLocating, isFalse);
      expect(state().canProceed, isFalse);
      expect(state().errorMessage, isNotNull);
    });

    test('좌표 조회가 실패하면 오류를 알린다', () async {
      repository.respondLocate = (_) async => throw const ApiException.unauthorized();

      action(ApplyPropertyAddressAction.select(selected));
      await Future<void>.delayed(Duration.zero);

      expect(state().isLocating, isFalse);
      expect(state().canProceed, isFalse);
      expect(state().errorMessage, isNotNull);
    });

    test('조회 중에 다시 입력하기를 누르면 늦게 온 좌표는 버린다', () async {
      final slow = Completer<({double latitude, double longitude})?>();

      repository.respondLocate = (_) => slow.future;

      action(ApplyPropertyAddressAction.select(selected));
      action(const ApplyPropertyAddressAction.reset());
      slow.complete((latitude: 37.3595033, longitude: 127.105216));
      await Future<void>.delayed(Duration.zero);

      expect(state().selected, isNull);
      expect(state().located, isNull);
      expect(state().isLocating, isFalse);
    });
  });

  group('상세 주소', () {
    final selected = AddressResultViewState.fromDomain(_address);

    test('입력하면 상세 주소가 바뀌고 공백만 있으면 입력되지 않은 것으로 본다', () {
      action(ApplyPropertyAddressAction.select(selected));

      action(const ApplyPropertyAddressAction.inputDetail('202호'));

      expect(state().detailAddress, '202호');
      expect(state().hasDetailAddress, isTrue);

      action(const ApplyPropertyAddressAction.inputDetail('   '));

      expect(state().hasDetailAddress, isFalse);
    });

    test('다른 주소를 선택하면 상세 주소를 비운다', () {
      action(ApplyPropertyAddressAction.select(selected));
      action(const ApplyPropertyAddressAction.inputDetail('202호'));

      action(ApplyPropertyAddressAction.select(selected));

      expect(state().detailAddress, isEmpty);
    });

    test('다시 입력하면 상세 주소를 비운다', () {
      action(ApplyPropertyAddressAction.select(selected));
      action(const ApplyPropertyAddressAction.inputDetail('202호'));

      action(const ApplyPropertyAddressAction.reset());

      expect(state().detailAddress, isEmpty);
    });

    test('상세 주소가 없어도 좌표를 얻으면 다음으로 이동한다', () async {
      action(ApplyPropertyAddressAction.select(selected));
      await Future<void>.delayed(Duration.zero);

      action(const ApplyPropertyAddressAction.next());

      expect(state().hasDetailAddress, isFalse);
      expect(state().navigateTo, isNotNull);
    });
  });
}
