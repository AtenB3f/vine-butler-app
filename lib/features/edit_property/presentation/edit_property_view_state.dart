import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/shared/extensions/extensions.dart';
import 'package:vine_butler/shared/utils/utils.dart';

enum EditPropertyStatus {
  loading,
  loaded,
  notFound,
}

enum EditPropertyEvent {
  save,
  failSave,
  invalidOwner,
}

enum EditPropertyPriceField {
  price,
  monthlyRent,
  maintenanceCost
}

class EditPropertyViewState {
  static const double priceDistance = 1000000;
  static const double minMonthlyRent = 10000;
  static const double maxMonthlyRent = 1500000;
  static const double monthlyRentDistance = 10000;
  static const double minMaintenanceCost = 0;
  static const double maxMaintenanceCost = 500000;
  static const double maintenanceCostDistance = 10000;
  static final RegExp _phonePattern = RegExp(r'^010-\d{4}-\d{4}$');

  final EditPropertyStatus status;
  final Property? property;
  final Address? address;
  final PropertyTransactionType transactionType;
  final double price;
  final double monthlyRent;
  final double maintenanceCost;
  final String ownerName;
  final String ownerPhone;
  final DateTime? moveInDate;
  final bool isFlexibleMoveInDate;
  final bool? hasLoan;
  final bool? isParkingAvailable;
  final bool? isSuretyInsuranceAvailable;
  final int? roomCount;
  final Set<String> furnitureOptions;
  final String memo;
  final List<PropertyImage> images;
  final EditPropertyPriceField? editingField;
  final EditPropertyEvent? event;

  const EditPropertyViewState({
    this.status = EditPropertyStatus.loading,
    this.property,
    this.address,
    this.transactionType = PropertyTransactionType.rent,
    this.price = 0,
    this.monthlyRent = minMonthlyRent,
    this.maintenanceCost = 0,
    this.ownerName = '',
    this.ownerPhone = '',
    this.moveInDate,
    this.isFlexibleMoveInDate = false,
    this.hasLoan,
    this.isParkingAvailable,
    this.isSuretyInsuranceAvailable,
    this.roomCount,
    this.furnitureOptions = const {},
    this.memo = '',
    this.images = const [],
    this.editingField,
    this.event,
  });

  factory EditPropertyViewState.fromDomain(Property property) {
    final deal = property.deal;

    return EditPropertyViewState(
      status: EditPropertyStatus.loaded,
      property: property,
      address: property.address,
      transactionType: deal.transactionType,
      price: deal.price.toDouble(),
      monthlyRent: (deal.monthlyRent ?? minMonthlyRent).toDouble(),
      maintenanceCost: (property.maintenanceCost ?? 0).toDouble(),
      ownerName: property.owner.name,
      ownerPhone: property.owner.phone,
      moveInDate: property.moveInDate,
      isFlexibleMoveInDate: property.isFlexibleMoveInDate,
      hasLoan: property.hasLoan,
      isParkingAvailable: property.isParkingAvailable,
      isSuretyInsuranceAvailable: property.isSuretyInsuranceAvailable,
      roomCount: property.roomCount,
      furnitureOptions: property.furnitureOptions.toSet(),
      memo: property.memo,
      images: property.images,
    );
  }

  String get unitAddress {
    final address = this.address;

    return address == null ? '' : lotUnitAddress(address);
  }

  String get regionAddress {
    final address = this.address;

    return address == null ? '' : [address.sido, address.sigungu].where((part) => part.isNotEmpty).join(' ');
  }

  double get minPrice => transactionType.minPrice;

  double get maxPrice => transactionType.maxPrice;

  double get midPrice => minPrice + ((maxPrice - minPrice) / 2 / priceDistance).floor() * priceDistance;

  String get priceLabel => transactionType == PropertyTransactionType.buy ? '금액' : '보증금';

  bool get isMonthlyRentVisible => transactionType == PropertyTransactionType.rent;

  EditPropertyPriceField? get nextField {
    switch (editingField) {
      case EditPropertyPriceField.price:
        return isMonthlyRentVisible ? EditPropertyPriceField.monthlyRent : EditPropertyPriceField.maintenanceCost;

      case EditPropertyPriceField.monthlyRent:
        return EditPropertyPriceField.maintenanceCost;

      case EditPropertyPriceField.maintenanceCost:
      case null:
        return null;
    }
  }

  bool get isOwnerValid => ownerName.trim().isNotEmpty && _phonePattern.hasMatch(ownerPhone);

  bool get hasPhoneError => ownerPhone.isNotEmpty && ownerPhone != '010' && !_phonePattern.hasMatch(ownerPhone);

  EditPropertyViewState copyWith({
    EditPropertyStatus? status,
    Property? property,
    Address? address,
    PropertyTransactionType? transactionType,
    double? price,
    double? monthlyRent,
    double? maintenanceCost,
    String? ownerName,
    String? ownerPhone,
    DateTime? Function()? moveInDate,
    bool? isFlexibleMoveInDate,
    bool? Function()? hasLoan,
    bool? Function()? isParkingAvailable,
    bool? Function()? isSuretyInsuranceAvailable,
    int? Function()? roomCount,
    Set<String>? furnitureOptions,
    String? memo,
    List<PropertyImage>? images,
    EditPropertyPriceField? Function()? editingField,
    EditPropertyEvent? Function()? event,
  }) {
    return EditPropertyViewState(
      status: status ?? this.status,
      property: property ?? this.property,
      address: address ?? this.address,
      transactionType: transactionType ?? this.transactionType,
      price: price ?? this.price,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      maintenanceCost: maintenanceCost ?? this.maintenanceCost,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      moveInDate: moveInDate != null ? moveInDate() : this.moveInDate,
      isFlexibleMoveInDate: isFlexibleMoveInDate ?? this.isFlexibleMoveInDate,
      hasLoan: hasLoan != null ? hasLoan() : this.hasLoan,
      isParkingAvailable: isParkingAvailable != null ? isParkingAvailable() : this.isParkingAvailable,
      isSuretyInsuranceAvailable:
          isSuretyInsuranceAvailable != null ? isSuretyInsuranceAvailable() : this.isSuretyInsuranceAvailable,
      roomCount: roomCount != null ? roomCount() : this.roomCount,
      furnitureOptions: furnitureOptions ?? this.furnitureOptions,
      memo: memo ?? this.memo,
      images: images ?? this.images,
      editingField: editingField != null ? editingField() : this.editingField,
      event: event != null ? event() : this.event,
    );
  }
}
