import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/components/components.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_list/presentation/screens/property_list_item.dart';
import 'package:vine_butler/features/property_list/presentation/property_list_view_state.dart';

class PropertyListScreen extends ConsumerWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMobile) {
      return _mobileScreen(ref);
    } else {
      return _desktopScreen(ref);
    }
  }

  Widget _mobileScreen(WidgetRef ref) {
    final items = List.generate(20, (i) {
      final transactionType = PropertyTransactionType.values[i % PropertyTransactionType.values.length];
      return PropertyListViewState(
        id: i,
        amount: 100000000 + i * 10000000,
        monthlyAmount: transactionType == PropertyTransactionType.rent ? 500000 + i * 10000 : null,
        roadAddress: '서울특별시 강남구 테헤란로 ${152 + i}',
        jibunAddress: '서울특별시 강남구 역삼동 ${10 + i}',
        transactionType: transactionType,
        propertyType: PropertyType.values[i % PropertyType.values.length],
        tag: const ['9평', '방 1개'],
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 0,
      children: [
        _homeBanner(),
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView.separated(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => PropertyListItem(
                viewState: items[index],
                onTap: () => PropertyDetailRoute(id: items[index].id).push(context),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _desktopScreen(WidgetRef ref) {
    final items = List.generate(20, (i) {
      final transactionType = PropertyTransactionType.values[i % PropertyTransactionType.values.length];
      return PropertyListViewState(
        id: i,
        amount: 100000000 + i * 10000000,
        monthlyAmount: transactionType == PropertyTransactionType.rent ? 500000 + i * 10000 : null,
        roadAddress: '서울특별시 강남구 테헤란로 ${152 + i}',
        jibunAddress: '서울특별시 강남구 역삼동 ${10 + i}',
        transactionType: transactionType,
        propertyType: PropertyType.values[i % PropertyType.values.length],
        tag: const ['9평', '방 1개'],
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 0,
      children: [
        _homeBanner(),
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView.separated(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => PropertyListItem(
                viewState: items[index],
                onTap: () => PropertyDetailRoute(id: items[index].id).push(context),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _homeBanner() {
    return Row(
      children: [
        AppImages.tabHome(true),
        Expanded(
          child: AppTextField(
            controller: TextEditingController(),
            onChanged: (value) {
              // Handle text change
            },
          ),
        ),
      ],
    );
  }
}
