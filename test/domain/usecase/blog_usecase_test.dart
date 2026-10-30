import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/domain/exception/permission_denied_exception.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/model/user_role.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/blog_repository.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';
import 'package:vine_butler/domain/repository/user_role_repository.dart';
import 'package:vine_butler/domain/usecase/blog_usecase.dart';

class _FakeBlogRepository implements BlogRepository {
  int writeCount = 0;

  @override
  Future<BlogPost> write(Property property) async {
    writeCount++;
    return const BlogPost(title: '생성된 제목', body: '생성된 본문');
  }
}

class _FakePropertyRepository implements PropertyRepository {
  Property? property;
  final Map<String, BlogPost> savedPosts = {};

  @override
  Future<Property?> getById(String id) async => property;

  @override
  Future<void> saveBlogPost(String propertyId, BlogPost post) async => savedPosts[propertyId] = post;

  @override
  Stream<List<Property>> watchList() => const Stream.empty();

  @override
  Stream<List<Property>> watchFilter(PropertySearchCondition condition) => const Stream.empty();

  @override
  Future<void> save(Property property) async {}

  @override
  Future<void> delete(String id) async {}
}

class _FakeUserRoleRepository implements UserRoleRepository {
  UserRole role = UserRole.master;

  @override
  Future<UserRole> currentRole() async => role;
}

Property _property({required DateTime updatedAt, BlogPost? blogPost}) {
  return Property(
    id: 'a',
    owner: const Owner(name: '홍길동', phone: '010-1234-5678'),
    propertyType: PropertyType.apartment,
    deal: const PropertyDeal(transactionType: PropertyTransactionType.rent, price: 10000000, monthlyRent: 500000),
    address: const Address(
      zipCode: '06236',
      roadAddress: '서울 강남구 테헤란로 1',
      lotAddress: '역삼동 1-1',
      sido: '서울특별시',
      sigungu: '강남구',
      dongMyeon: '역삼동',
      latitude: 37.5006,
      longitude: 127.0364,
    ),
    blogPost: blogPost,
    updatedAt: updatedAt,
  );
}

void main() {
  late _FakeBlogRepository blogRepository;
  late _FakePropertyRepository propertyRepository;
  late _FakeUserRoleRepository userRoleRepository;
  late BlogUseCase useCase;

  setUp(() {
    blogRepository = _FakeBlogRepository();
    propertyRepository = _FakePropertyRepository();
    userRoleRepository = _FakeUserRoleRepository();
    useCase = BlogUseCase(blogRepository, propertyRepository, userRoleRepository);
  });

  group('fetch', () {
    test('글을 만든 뒤 매물이 그대로면 저장된 글을 돌려준다', () async {
      final post = BlogPost(title: '제목', body: '본문', propertyUpdatedAt: DateTime(2021));

      propertyRepository.property = _property(updatedAt: DateTime(2021), blogPost: post);

      expect(await useCase.fetch('a'), post);
    });

    test('글을 만든 뒤 매물이 수정됐으면 null을 돌려준다', () async {
      propertyRepository.property = _property(
        updatedAt: DateTime(2022),
        blogPost: BlogPost(title: '제목', body: '본문', propertyUpdatedAt: DateTime(2021)),
      );

      expect(await useCase.fetch('a'), isNull);
    });

    test('저장된 글이 없으면 null을 돌려준다', () async {
      propertyRepository.property = _property(updatedAt: DateTime(2021));

      expect(await useCase.fetch('a'), isNull);
    });
  });

  group('write', () {
    test('생성한 글에 현재 매물의 updatedAt을 넣어 저장한다', () async {
      propertyRepository.property = _property(updatedAt: DateTime(2021));

      final post = await useCase.write('a');

      expect(post?.propertyUpdatedAt, DateTime(2021));
      expect(propertyRepository.savedPosts['a'], post);
    });

    test('매물이 없으면 생성하지 않고 null을 돌려준다', () async {
      expect(await useCase.write('a'), isNull);
      expect(blogRepository.writeCount, 0);
    });

    test('권한이 없으면 PermissionDeniedException을 던진다', () async {
      userRoleRepository.role = UserRole.none;
      propertyRepository.property = _property(updatedAt: DateTime(2021));

      await expectLater(useCase.write('a'), throwsA(isA<PermissionDeniedException>()));
      expect(propertyRepository.savedPosts, isEmpty);
    });
  });
}
