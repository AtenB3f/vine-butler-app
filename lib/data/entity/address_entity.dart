class RoadAddressEntity {
  final String roadName;
  final String buildingNumber;
  final String? buildingName;

  RoadAddressEntity({
    required this.roadName,
    required this.buildingNumber,
    this.buildingName,
  });
}

class LotAddressEntity {
  final String dongMyeon;
  final String landNumber;
  final String? buildingName;

  LotAddressEntity({
    required this.dongMyeon,
    required this.landNumber,
    this.buildingName,
  });
}

class RegionEntity {
  final String sido;
  final String sigungu;
  final String dongMyeon;
  final String? ri;

  RegionEntity({
    required this.sido,
    required this.sigungu,
    required this.dongMyeon,
    this.ri,
  });
}

class LocationEntity {
  final double latitude;
  final double longitude;

  LocationEntity({required this.latitude, required this.longitude});
}

class AddressEntity {
  final RoadAddressEntity roadAddress;
  final LotAddressEntity lotAddress;
  final String? unit;
  final RegionEntity region;
  final LocationEntity location;
  final String postalCode;

  AddressEntity({
    required this.roadAddress,
    required this.lotAddress,
    this.unit,
    required this.region,
    required this.location,
    required this.postalCode,
  });
}
