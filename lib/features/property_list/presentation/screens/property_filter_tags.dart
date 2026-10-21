import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_list/presentation/property_filter_view_state.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';

class PropertyFilterTags extends StatelessWidget {
  final String query;
  final PropertyFilterData filter;
  final ValueChanged<PropertyFilterData> onFilter;
  final VoidCallback onClearQuery;

  const PropertyFilterTags({
    super.key,
    required this.query,
    required this.filter,
    required this.onFilter,
    required this.onClearQuery,
  });

  @override
  Widget build(BuildContext context) {
    final transactionType = filter.transactionType;
    final keyword = query.trim();
    final tags = [
      if (transactionType != null)
        _tag(transactionType.label, () => onFilter(filter.copyWith(transactionType: () => null))),
      for (final option in PropertyTypeFilterOption.values)
        if (filter.propertyTypes.containsAll(option.types))
          _tag(option.label, () => onFilter(filter.copyWith(propertyTypes: filter.propertyTypes.difference(option.types)))),
      if (keyword.isNotEmpty) _tag(keyword, onClearQuery),
    ];

    if (tags.isEmpty) { return const SizedBox.shrink(); }

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        child: Row(
          spacing: 6,
          children: tags,
        ),
      ),
    );
  }

  Widget _tag(String text, VoidCallback onTap) {
    return IconTag(text: text, status: IconTagStatus.off, onTap: onTap);
  }
}
