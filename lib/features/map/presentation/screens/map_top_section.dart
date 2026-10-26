import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_filter_tags.dart';

class MapTopSection extends StatelessWidget {
  final String query;
  final PropertyFilterData filter;
  final ValueChanged<PropertyFilterData> onFilter;
  final VoidCallback onClearQuery;
  final VoidCallback onMyLocationTap;

  const MapTopSection({
    super.key,
    required this.query,
    required this.filter,
    required this.onFilter,
    required this.onClearQuery,
    required this.onMyLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StateColor.white,
      height: 46,
      child: Row(
        spacing: 4,
        children: [
          Expanded(
            child: PropertyFilterTags(
              query: query,
              filter: filter,
              onFilter: onFilter,
              onClearQuery: onClearQuery,
            ),
          ),
          _myLocationButton(),
        ],
      ),
    );
  }

  Widget _myLocationButton() {
    return Pressable(
      onTap: onMyLocationTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: StateColor.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            AppIcons.compassMD(TextColor.dark),
            AppFontStyle.bold2.text('내 위치', TextColor.dark),
          ],
        ),
      ),
    );
  }
}
