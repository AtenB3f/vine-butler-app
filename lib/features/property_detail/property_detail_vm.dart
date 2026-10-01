import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

final propertyDetailVMProvider =
    NotifierProvider.family<PropertyDetailVM, PropertyDetailViewState, int>(PropertyDetailVM.new);

class PropertyDetailVM extends Notifier<PropertyDetailViewState> {
  PropertyDetailVM(this.id);

  final int id;

  static final List<String> _mockImageUrls = [
    'https://plus.unsplash.com/premium_photo-1789652751182-f4af07e03ee3?q=80&w=928&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1790011990347-c59091f9437e?q=80&w=663&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1789931366466-f9054227fa41?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  static final List<PropertyDetailData> _mockSamples = [
    PropertyDetailData(
      imageUrls: _mockImageUrls,
      unitAddress: '숲속마을신동아파밀리에',
      address: '동작구 신대방동 717',
      transactionType: PropertyTransactionType.buy,
      amount: 2680000000,
      maintenanceCost: 180000,
      areaExclusive: 85.5,
      ownerPhone: '010-0000-0000',
      agentCompany: 'OO공인중개',
      agentPhone: '010-0000-0000',
      vicinity: ['신대방삼거리역 10분 거리'],
      isAvailableParking: true,
      isAvailableLoan: false,
      isAvailableSuretyInsurance: false,
      moveInDate: DateTime(2025, 7, 25),
      isAvailableMoveInDate: true,
      furnitureOptions: ['가스레인지', '에어컨', '냉장고', '싱크대', '엘레베이터', '마당', '세탁기', '옷장', '식탁'],
      memo: '불법 증축 X',
    ),
    PropertyDetailData(
      imageUrls: _mockImageUrls,
      unitAddress: '숲속마을신동아파밀리에',
      address: '동작구 신대방동 717',
      transactionType: PropertyTransactionType.depositOnly,
      amount: 2680000000,
      maintenanceCost: 180000,
      areaExclusive: 85.5,
      ownerPhone: '010-0000-0000',
      agentCompany: 'OO공인중개',
      agentPhone: '010-0000-0000',
      vicinity: ['신림역 15분 거리'],
      isAvailableParking: true,
      isAvailableLoan: true,
      isAvailableSuretyInsurance: true,
      isAvailableMoveInDate: false,
      furnitureOptions: ['가스레인지', '에어컨', '냉장고', '싱크대', '엘레베이터', '마당', '세탁기', '옷장', '식탁'],
      memo: '불법 증축 X',
    ),
    PropertyDetailData(
      imageUrls: _mockImageUrls,
      unitAddress: '숲속마을신동아파밀리에',
      address: '동작구 신대방동 717',
      transactionType: PropertyTransactionType.rent,
      amount: 80000000,
      monthlyAmount: 800000,
      maintenanceCost: 100000,
      areaExclusive: 39.6,
      ownerPhone: '010-0000-0000',
      vicinity: ['장승배기역 6분 거리'],
      isAvailableParking: false,
      isAvailableLoan: false,
      isAvailableSuretyInsurance: false,
      moveInDate: DateTime(2025, 7, 25),
      isAvailableMoveInDate: false,
      furnitureOptions: ['가스레인지', '에어컨', '냉장고', '싱크대', '엘레베이터', '마당', '세탁기', '옷장', '식탁'],
      memo: null,
    ),
  ];

  @override
  PropertyDetailViewState build() =>
      PropertyDetailViewState(data: _mockSamples[id % _mockSamples.length]);

  void action(PropertyDetailAction action) {
    switch (action) {
      case PropertyDetailAction.fetch:
        break;
    }
  }

  void popNavigation() {
    state = PropertyDetailViewState(data: state.data, navigateTo: null);
  }

  void pushNavigation(String path) {
    state = PropertyDetailViewState(data: state.data, navigateTo: path);
  }
}