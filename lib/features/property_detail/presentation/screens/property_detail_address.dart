import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

class PropertyDetailAddress extends StatelessWidget {
  final PropertyDetailData data;

  const PropertyDetailAddress({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (data.unitAddress.isNotEmpty)
          Text(
            data.unitAddress,
            style: AppFontStyle.header1.style(TextColor.dark),
          ),
        Text(
          data.address,
          style: AppFontStyle.sub1.style(TextColor.dark),
        ),
      ],
    );
  }
}
