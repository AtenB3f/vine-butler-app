import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

class PropertyDetailOwner extends StatelessWidget {
  final PropertyDetailData data;

  const PropertyDetailOwner({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 14,
      children: [
        Row(
          spacing: 8,
          children: [
            _optionTitle('집주인'),
            const Spacer(),
            AppIcons.callSM(BaseColor.dark),
            AppFontStyle.body3.text(data.ownerPhone, TextColor.dark),
          ],
        ),
        if (data.agentPhone != null) ... [
          Row(
            spacing: 8,
            children: [
              _optionTitle('공인중개'),
              const Spacer(),
              if (data.agentCompany case final agentCompany?) ... [
                AppFontStyle.body2.text(agentCompany, TextColor.medium),
              ],
              AppIcons.callSM(),
              if (data.agentPhone case final agentPhone?) ... [
                AppFontStyle.body3.text(agentPhone, TextColor.dark),
              ]
            ],
          )
        ]
      ],
    );
  }

  Text _optionTitle(String title) {
    return AppFontStyle.body1.text(title, TextColor.light);
  }
}
