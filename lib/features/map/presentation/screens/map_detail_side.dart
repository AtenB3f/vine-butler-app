import 'package:flutter/material.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_body.dart';

/// 데스크톱 지도 탭 오른쪽 매물 상세
class MapDetailSide extends StatelessWidget {
  final String id;

  const MapDetailSide({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '매물 정보',
      rightIcon: (color) => AppIcons.iconMD('Expand_MD', color),
      onRightTap: () => PropertyDetailRoute(id: id).push(context),
      body: PropertyDetailBody(id: id),
    );
  }
}
