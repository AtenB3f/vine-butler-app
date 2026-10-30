import 'package:vine_butler/data/remote/clova/prompts/blog_prompt.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/shared/extensions/price_extension.dart';
import 'package:vine_butler/shared/utils/date_formatter.dart';

/// 기본 블로그 프롬프트
///
/// - `_titleMarker`, `_bodyMarker`: 응답을 제목·본문으로 나누는 구분자 (`system` 출력 형식과 `parse`가 함께 사용)
/// - `_titleGuide`, `_bodyGuide`: `system`에 넣는 제목·본문 작성 지침 (구분자는 상수로 끼워 넣어 `parse`와 항상 같게 유지)
class DefaultBlogPrompt implements BlogPrompt {
  const DefaultBlogPrompt(this.property);

  static const _titleMarker = '[제목]';
  static const _bodyMarker = '[본문]';
  static const _titleGuide = '''
아래 형식을 따를 것
`$_titleMarker 검색 결과에 보일 45자 이내의 짧은 핵심 문장 한 줄. 지역 필수 포함, 매물 유형 필수 포함, 거래타입 필수 포함, 핵심 장점 1~2개 포함, 매물의 장점과 특징을 강조`
예) $_titleMarker 테스트구 테스트동 가성비 좋은 역세권 원룸 월세 7000/60 매물 
''';
  static const _bodyGuide = '''
`“$_bodyMarker” - 인삿말 - 집 정보 - 장점 - 추천 대상 - 마무리 인삿말 순서로 작성`
- 인삿말: 한국의 현재 계절, 한국의 현재 날씨, 한국 현재 날짜(예: 공휴일, 5월 가정의 달, 7~8월 여름 휴가철, 추석 연휴 등)의 소재를 활용한 인삿말을 2줄 내외로 작성. 다음으로 이어질 집 소개로 잘 이어지도록 작성함.
- 집 정보: 거래 조건, 관리비, 방 개수, 옵션, 입주 시기 등 입력된 정보. 한눈에 보기 편하도록 리스트, 강조와 같은 마크다운을 사용가능, 표 사용 불가
- 장점: 사진과 매물 정보로 확인되는 장점 3~5개 내외의 핵심 포인트. (예: 채광, 전망, 구조, 옵션, 주변 시설 등), 불렛으로 작성할 것
- 추천 대상: 사진과 매물 정보로 확인되는 내용으로 매물 유형과 조건에 어울리는 사람, 예: 신혼부부, 1인 가구, 반려동물 있는 가구 등, 자차가 없는 사람, 역세권을 선호하는 사람 등
- 마무리 인삿말: 감사인사 혹은 다음을 기약하는 내용 등 마무리 인삿말을 2줄 내외로 작성
''';

  @override
  final Property property;

  @override
  String get system {
    return '''
당신은 공인중개사무소의 네이버 블로그에 매물 소개 글을 쓰는 작성자입니다.

<규칙>
- 사진과 정보로 확인할 수 없는 내용을 거짓으로 지어내지 말 것
- 사진이 없는 경우는 유저가 보낸 텍스트로 작성된 매물 정보로만 글을 쓸 것
- 사진이 집의 내부와 외부로 보여지지 않는 경우 해당 사진에 대한 설명은 쓰지 않음
- 정중하고 친근한 말투로 작성할 것 
- 한 문장마다 개행문자 써서 가독성이 좋게 작성할 것

<출력 형식>
- 제목과 본문으로 구분하여 작성해야 함. 각 항목의 출력 형식은 아래와 같음
- 각 항목의 구분자는 '$_titleMarker' '$_bodyMarker'으로 구분하기에 필수로 추가할 것
- 제목과 본문은 아래와 같이 작성할 것

<제목>
$_titleGuide

<본문>
$_bodyGuide
''';
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
      if (property.hasLoan case final loan?) '- 융자: ${loan ? '있음' : '없음'}',
      if (property.isSuretyInsuranceAvailable case final insurance?) '- 전세보증보험: ${insurance ? '가입 가능' : '가입 불가'}',
      '- 입주: ${property.isFlexibleMoveInDate ? '$moveIn (협의 가능)' : moveIn}',
      if (property.furnitureOptions.isNotEmpty) '- 가구 옵션: ${property.furnitureOptions.join(', ')}',
    ];

    return '매물 정보\n${info.join('\n')}\n\n시스템의 규칙과 출력 형식을 맞추어 작성할 것. `$_titleMarker`과`$_bodyMarker` 구분자를 반드시 포함할 것.';
  }

  @override
  String imageCaption(int number) => '$number번째 매물 사진입니다.';

  @override
  String imageReply(int number) => '$number번째 사진을 확인했습니다.';

  /// 응답을 제목과 본문으로 나누는 함수
  ///
  /// - `[본문]`이 없으면 응답 전체를 본문으로 사용
  /// - 구분자를 꾸민 기호(`**[제목]**`, `` `[제목]` ``, `“[본문]”`, `:`)는 제거
  /// - 제목은 첫 줄만 사용하고 앞뒤 꾸밈 기호를 모두 제거
  /// - 본문은 마크다운 강조(`**`)가 깨지지 않도록 구분자와 같은 줄에 남은 꾸밈 기호만 제거
  @override
  BlogPost parse(String content) {
    final decoration = RegExp(r'^[\s*`"“”:]+|[\s*`"“”:]+$');
    final markerLineDecoration = RegExp(r'^[ \t*`"“”:]*\n');
    final bodyIndex = content.indexOf(_bodyMarker);

    if (bodyIndex < 0) { return BlogPost(body: content.trim()); }

    final titleIndex = content.indexOf(_titleMarker);
    final titleText = titleIndex < 0 || titleIndex > bodyIndex ? '' : content.substring(titleIndex + _titleMarker.length, bodyIndex).replaceAll(decoration, '');
    final title = titleText.split('\n').first.replaceAll(decoration, '');
    final body = content.substring(bodyIndex + _bodyMarker.length).replaceFirst(markerLineDecoration, '').trim();

    return BlogPost(title: title, body: body.replaceFirst(RegExp(r'^[`"“”:]+\s*'), ''));
  }
}
