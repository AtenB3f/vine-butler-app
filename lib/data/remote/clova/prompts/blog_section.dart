/// 블로그 본문 구성 항목
///
/// - `name`: 항목 이름 (예: 장점, 추천 대상)
/// - `guide`: 해당 항목에 쓸 내용 지침
class BlogSection {
  const BlogSection(this.name, this.guide);

  final String name;
  final String guide;
}
