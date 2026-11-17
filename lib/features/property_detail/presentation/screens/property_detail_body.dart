import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vine_butler/components/components.dart';
// import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_address.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_media.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_options.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_owner.dart';
// import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_post.dart';
import 'package:vine_butler/features/property_detail/presentation/screens/property_detail_price_info.dart';
import 'package:vine_butler/features/property_detail/property_detail_vm.dart';

class PropertyDetailBody extends ConsumerWidget {
  final String id;

  const PropertyDetailBody({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyDetailVMProvider(id));

    switch (state.status) {
      case PropertyDetailStatus.loading:
        return const Center(
          child: AppLoadingSpinner(viewState: AppLoadingSpinnerViewState(size: AppLoadingSpinnerSize.large)),
        );

      case PropertyDetailStatus.notFound:
        return Center(child: AppFontStyle.body3.text('매물을 찾을 수 없습니다.', TextColor.medium));

      case PropertyDetailStatus.loaded:
        return _contents(context, ref, state.data!, state.isMapVisible);
    }
  }

  Widget _contents(BuildContext context, WidgetRef ref, PropertyDetailData data, bool isMapVisible) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 20, right: 20, top: 20, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 40,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                if (context.isMobile || data.hasImages)
                  PropertyDetailMedia(
                    data: data,
                    isMapVisible: isMapVisible,
                    onToggleMap: () => ref.read(propertyDetailVMProvider(id).notifier).action(PropertyDetailAction.toggleMap),
                  ),
                PropertyDetailAddress(data: data),
              ],
            ),
            PropertyDetailPriceInfo(data: data),
            PropertyDetailOwner(data: data),
            PropertyDetailOptions(data: data),
            // if (data.postTitle case final postTitle?)
            //   PropertyDetailPost(
            //     title: postTitle,
            //     onTap: () => openPost(context, ref, id, PropertyPostRoute(id: id)),
            //   ),
          ],
        ),
      ),
    );
  }

  /// 포스트 화면 이동 함수 (돌아오면 새로 저장된 포스트를 반영하도록 다시 조회)
  static Future<void> openPost(BuildContext context, WidgetRef ref, String id, GoRouteData route) async {
    await route.push(context);

    if (!context.mounted) { return; }

    ref.read(propertyDetailVMProvider(id).notifier).action(PropertyDetailAction.fetch);
  }
}
