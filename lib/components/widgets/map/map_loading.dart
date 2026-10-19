import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';

class MapLoading extends StatelessWidget {
  const MapLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: BaseColor.light,
      child: Center(
        child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
      ),
    );
  }
}
