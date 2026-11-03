import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class PropertyDetailPost extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PropertyDetailPost({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        AppFontStyle.body1.text('포스트', TextColor.light),
        Pressable(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppFontStyle.sub2.style(TextColor.dark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox.square(dimension: 30, child: Center(child: AppIcons.chevronRightSM(TextColor.dark))),
            ],
          ),
        ),
      ],
    );
  }
}
