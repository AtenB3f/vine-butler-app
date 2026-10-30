import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/data/remote/clova/prompts/default_blog_prompt.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/property_type.dart';

void main() {
  final prompt = DefaultBlogPrompt(
    Property(
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
      updatedAt: DateTime(2020),
    ),
  );

  test('구분자로 제목과 본문을 나눈다', () {
    final post = prompt.parse('[제목] 역삼동 월세 원룸\n[본문]\n안녕하세요.\n\n## 장점\n- 채광');

    expect(post.title, '역삼동 월세 원룸');
    expect(post.body, '안녕하세요.\n\n## 장점\n- 채광');
  });

  test('꾸며진 구분자도 나누고 본문의 마크다운 강조는 유지한다', () {
    final post = prompt.parse('**[제목]** 역삼동 월세 원룸\n\n**“[본문]”**\n**안녕하세요.** 소개드립니다.');

    expect(post.title, '역삼동 월세 원룸');
    expect(post.body, '**안녕하세요.** 소개드립니다.');
  });

  test('제목 뒤에 설명이 붙어도 첫 줄만 제목으로 쓴다', () {
    final post = prompt.parse('[제목]\n역삼동 월세 원룸\n(30자 이내)\n[본문] 본문입니다.');

    expect(post.title, '역삼동 월세 원룸');
    expect(post.body, '본문입니다.');
  });

  test('본문 구분자가 없으면 전체를 본문으로 쓴다', () {
    final post = prompt.parse('구분자 없는 응답');

    expect(post.title, '');
    expect(post.body, '구분자 없는 응답');
  });
}
