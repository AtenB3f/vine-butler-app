import 'package:vine_butler/data/remote/clova/prompts/blog_prompt.dart';
import 'package:vine_butler/data/remote/clova/prompts/blog_section.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/shared/extensions/price_extension.dart';
import 'package:vine_butler/shared/utils/date_formatter.dart';

/// 기본 블로그 프롬프트
///
/// - `_titleMarker`, `_bodyMarker`: 응답을 제목·본문으로 나누는 구분자 (`system` 출력 형식과 `parse`가 함께 사용)
class DefaultBlogPrompt implements BlogPrompt {
  const DefaultBlogPrompt(this.property);

  static const _titleMarker = '[제목]';
  static const _bodyMarker = '[본문]';

  @override
  final Property property;

  @override
  String get system {
    const sections = [
      BlogSection('장점', '사진과 매물 정보로 확인되는 장점 3~5가지'),
      BlogSection('집 정보', '거래 조건, 관리비, 방 개수, 옵션, 입주 시기 등 입력된 정보'),
      BlogSection('추천 대상', '매물 유형과 조건에 어울리는 사람'),
    ];
    final sectionGuide = [
      for (final (index, section) in sections.indexed) '${index + 1}. ${section.name}: ${section.guide}',
    ].join('\n');

    return '''
당신은 공인중개사무소의 네이버 블로그에 매물 소개 글을 쓰는 작성자입니다.

규칙
- 사진에서 직접 보이는 것과 입력된 매물 정보만 근거로 씁니다.
- 방향(남향 등), 채광, 신축 여부, 면적, 층수, 주변 시설처럼 사진과 정보로 확인할 수 없는 내용은 쓰지 않습니다.
- 정확한 번지·호수, 집주인 정보, 연락처는 쓰지 않습니다.
- "최고", "완벽" 같은 과장 표현은 쓰지 않습니다.

출력 형식 (아래 형식 외의 내용은 쓰지 않습니다)
$_titleMarker
검색 결과에 보일 30자 이내의 짧은 핵심 문장 한 줄 (지역, 매물 유형, 핵심 장점 포함)
$_bodyMarker
블로그 본문 약 2,000자 markdown 형식

본문 구성 (아래 순서대로 쓰고, 각 항목 안의 소제목·문단·문장은 자유롭게 작성)
$sectionGuide''';
  }

  @override
  String get request {
    final deal = property.deal;
    final price = switch (deal.transactionType) {
      PropertyTransactionType.buy => '매매 ${deal.price.formattedKRW}',
      PropertyTransactionType.depositOnly => '전세 ${deal.price.formattedKRW}',
      PropertyTransactionType.rent => '월세 보증금 ${deal.price.formattedKRW} / 월 ${(deal.monthlyRent ?? 0).formattedKRW}',
    };
    final propertyType = switch (property.propertyType) {
      PropertyType.apartment => '아파트',
      PropertyType.oneRoom => '원룸',
      PropertyType.twoRoom => '투룸',
      PropertyType.villa => '빌라',
      PropertyType.detachedHouse => '단독주택',
      PropertyType.commercialBuilding => '상가',
    };
    final address = property.address;
    final moveIn = formatMoveInDate(property.moveInDate);
    final info = [
      '- 지역: ${[address.sido, address.sigungu, address.dongMyeon].where((part) => part.isNotEmpty).join(' ')}',
      '- 매물 유형: $propertyType',
      '- 거래: $price',
      if (property.maintenanceCost case final cost?) '- 관리비: ${cost == 0 ? '없음' : '월 ${cost.formattedKRW}'}',
      if (property.roomCount case final count?) '- 방 개수: $count개',
      if (property.isParkingAvailable case final parking?) '- 주차: ${parking ? '가능' : '불가'}',
      if (property.hasLoan case final loan?) '- 대출: ${loan ? '있음' : '없음'}',
      if (property.isSuretyInsuranceAvailable case final insurance?) '- 전세보증보험: ${insurance ? '가입 가능' : '가입 불가'}',
      '- 입주: ${property.isFlexibleMoveInDate ? '$moveIn (협의 가능)' : moveIn}',
      if (property.furnitureOptions.isNotEmpty) '- 옵션: ${property.furnitureOptions.join(', ')}',
    ];

    return '매물 정보\n${info.join('\n')}\n\n위 사진과 매물 정보로 블로그 글을 작성해 주세요.';
  }

  @override
  String imageCaption(int number) => '$number번째 매물 사진입니다.';

  @override
  BlogPost parse(String content) {
    final bodyIndex = content.indexOf(_bodyMarker);

    if (bodyIndex < 0) { return BlogPost(body: content.trim()); }

    final titleIndex = content.indexOf(_titleMarker);
    final title = titleIndex < 0 || titleIndex > bodyIndex ? '' : content.substring(titleIndex + _titleMarker.length, bodyIndex).trim();

    return BlogPost(title: title, body: content.substring(bodyIndex + _bodyMarker.length).trim());
  }
}
