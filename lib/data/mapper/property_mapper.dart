import 'package:drift/drift.dart';
import 'package:vine_butler/data/local/app_database.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/blog_post.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_image.dart';

extension PropertyRowMapper on PropertyTableData {
  Property toDomain({List<PropertyImage> images = const [], BlogPost? blogPost}) {
    return Property(
      id: id,
      owner: Owner(name: ownerName, phone: ownerPhone),
      propertyType: propertyType,
      deal: PropertyDeal(transactionType: transactionType, price: price, monthlyRent: monthlyRent),
      address: Address(
        zipCode: zipCode,
        roadAddress: roadAddress,
        lotAddress: lotAddress,
        sido: sido,
        sigungu: sigungu,
        dongMyeon: dongMyeon,
        detailAddress: detailAddress,
        latitude: latitude,
        longitude: longitude,
      ),
      maintenanceCost: maintenanceCost,
      isSuretyInsuranceAvailable: isSuretyInsuranceAvailable,
      hasLoan: hasLoan,
      isParkingAvailable: isParkingAvailable,
      moveInDate: moveInDate,
      isFlexibleMoveInDate: isFlexibleMoveInDate,
      roomCount: roomCount,
      furnitureOptions: furnitureOptions,
      memo: memo,
      images: images,
      blogPost: blogPost,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      syncedAt: syncedAt,
    );
  }
}

extension PropertyDomainMapper on Property {
  PropertyTableCompanion toCompanion() {
    return PropertyTableCompanion(
      id: Value(id),
      ownerName: Value(owner.name),
      ownerPhone: Value(owner.phone),
      transactionType: Value(deal.transactionType),
      propertyType: Value(propertyType),
      price: Value(deal.price),
      monthlyRent: Value(deal.monthlyRent),
      maintenanceCost: Value(maintenanceCost),
      zipCode: Value(address.zipCode),
      roadAddress: Value(address.roadAddress),
      lotAddress: Value(address.lotAddress),
      sido: Value(address.sido),
      sigungu: Value(address.sigungu),
      dongMyeon: Value(address.dongMyeon),
      detailAddress: Value(address.detailAddress),
      latitude: Value(address.latitude),
      longitude: Value(address.longitude),
      isSuretyInsuranceAvailable: Value(isSuretyInsuranceAvailable),
      hasLoan: Value(hasLoan),
      isParkingAvailable: Value(isParkingAvailable),
      moveInDate: Value(moveInDate),
      isFlexibleMoveInDate: Value(isFlexibleMoveInDate),
      roomCount: Value(roomCount),
      furnitureOptions: Value(furnitureOptions),
      memo: Value(memo),
      updatedAt: Value(updatedAt),
      deletedAt: Value(deletedAt),
      syncedAt: Value(syncedAt),
    );
  }
}
