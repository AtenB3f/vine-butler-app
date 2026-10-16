import 'package:uuid/uuid.dart';
import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/owner.dart';
import 'package:vine_butler/domain/model/property.dart';
import 'package:vine_butler/domain/model/property_deal.dart';
import 'package:vine_butler/domain/model/property_image.dart';
import 'package:vine_butler/domain/model/property_search_condition.dart';
import 'package:vine_butler/domain/property_type.dart';
import 'package:vine_butler/domain/repository/property_repository.dart';

class PropertyUseCase {
  const PropertyUseCase(this._repository, [this._uuid = const Uuid()]);

  final PropertyRepository _repository;
  final Uuid _uuid;

  Stream<List<Property>> watchList() => _repository.watchList();

  Stream<List<Property>> watchFilter(PropertySearchCondition condition) => _repository.watchFilter(condition);

  Future<Property?> get(String id) => _repository.getById(id);

  Future<String> create({
    required Owner owner,
    required PropertyType propertyType,
    required PropertyDeal deal,
    required Address address,
    int? maintenanceCost,
    bool? isSuretyInsuranceAvailable,
    bool? hasLoan,
    bool? isParkingAvailable,
    DateTime? moveInDate,
    bool isFlexibleMoveInDate = false,
    int? roomCount,
    List<String> furnitureOptions = const [],
    String memo = '',
    List<PropertyImage> images = const [],
  }) async {
    final id = _uuid.v4();

    await _repository.save(
      Property(
        id: id,
        owner: owner,
        propertyType: propertyType,
        deal: deal,
        address: address,
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
        updatedAt: DateTime.now(),
      ),
    );
    return id;
  }

  Future<void> update(Property property) => _repository.save(property);

  Future<void> delete(String id) => _repository.delete(id);
}
