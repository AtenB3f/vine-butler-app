import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/property.dart';

/// 매물 블로그 글 작성용 프롬프트 규격
///
/// - 메시지 순서: system → user(사진1 + `imageCaption`) → assistant(`imageReply`) → … → user(마지막 사진 + `request`)
/// - `request`: 매물 정보와 작성 요청을 담아 앱이 보내는 마지막 user 메시지
/// - `imageReply`: 사진 사이에 넣는 assistant 응답 (user 메시지가 연속되지 않게 함)
/// - `parse`: `system`에서 지정한 출력 형식의 응답을 블로그 글로 변환
abstract class BlogPrompt {
  Property get property;

  String get system;

  String get request;

  String imageCaption(int number);

  String imageReply(int number);

  BlogPost parse(String content);
}

/// 매물로 블로그 프롬프트를 만드는 함수 (프롬프트 구현체 교체 지점)
typedef BlogPromptBuilder = BlogPrompt Function(Property property);
