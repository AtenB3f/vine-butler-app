import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class SliderTab extends StatelessWidget {
  final List<String> imageUrls;

  const SliderTab({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrls.isEmpty
          ? Container(color: BaseColor.light)
          : PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) => Image.network(imageUrls[index], fit: BoxFit.cover),
            ),
    );
  }
}
