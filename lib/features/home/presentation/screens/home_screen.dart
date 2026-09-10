import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: '매물',
      // leftIcon: AppIcons.arrowLeftMD,
      // onLeftTap: () => context.pop() ,
      body: _items(),
    );
  }

  Column _items() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 40,
      children: [
        Text('어떻게 찾아 오셨나요?').header3(TextColor.dark),
        Text('찾아요').sub3(TextColor.dark),
        Text('맡겨요').sub3(TextColor.dark),
      ],
    );
  }
}