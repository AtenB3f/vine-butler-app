import 'package:flutter_test/flutter_test.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';

void main() {
  test('검색어가 있으면 확정 여부로 BND 상태를 정한다', () {
    expect(PropertySearchStatus.select.bndStatus(query: '역삼', isFilterApplied: true), AppBndSearchStatus.search);
    expect(PropertySearchStatus.open.bndStatus(query: '역삼', isFilterApplied: true), AppBndSearchStatus.enable);
  });

  test('검색어가 없으면 필터 적용 여부로 BND 상태를 정한다', () {
    expect(PropertySearchStatus.select.bndStatus(query: '', isFilterApplied: true), AppBndSearchStatus.filter);
    expect(PropertySearchStatus.close.bndStatus(query: '', isFilterApplied: false), AppBndSearchStatus.disable);
  });
}
