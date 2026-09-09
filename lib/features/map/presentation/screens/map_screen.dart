import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 50,
          children: [
            Text(
              "Map Screen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            Text("Map Screen")
          ],
        ),
      ),
    );
  }
}
