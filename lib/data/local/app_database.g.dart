// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PropertyTableTable extends PropertyTable
    with TableInfo<$PropertyTableTable, PropertyTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertyTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerPhoneMeta = const VerificationMeta(
    'ownerPhone',
  );
  @override
  late final GeneratedColumn<String> ownerPhone = GeneratedColumn<String>(
    'owner_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PropertyTransactionType, String>
  transactionType =
      GeneratedColumn<String>(
        'transaction_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PropertyTransactionType>(
        $PropertyTableTable.$convertertransactionType,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PropertyType, String>
  propertyType = GeneratedColumn<String>(
    'property_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PropertyType>($PropertyTableTable.$converterpropertyType);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyRentMeta = const VerificationMeta(
    'monthlyRent',
  );
  @override
  late final GeneratedColumn<int> monthlyRent = GeneratedColumn<int>(
    'monthly_rent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maintenanceCostMeta = const VerificationMeta(
    'maintenanceCost',
  );
  @override
  late final GeneratedColumn<int> maintenanceCost = GeneratedColumn<int>(
    'maintenance_cost',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipCodeMeta = const VerificationMeta(
    'zipCode',
  );
  @override
  late final GeneratedColumn<String> zipCode = GeneratedColumn<String>(
    'zip_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roadAddressMeta = const VerificationMeta(
    'roadAddress',
  );
  @override
  late final GeneratedColumn<String> roadAddress = GeneratedColumn<String>(
    'road_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lotAddressMeta = const VerificationMeta(
    'lotAddress',
  );
  @override
  late final GeneratedColumn<String> lotAddress = GeneratedColumn<String>(
    'lot_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sidoMeta = const VerificationMeta('sido');
  @override
  late final GeneratedColumn<String> sido = GeneratedColumn<String>(
    'sido',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sigunguMeta = const VerificationMeta(
    'sigungu',
  );
  @override
  late final GeneratedColumn<String> sigungu = GeneratedColumn<String>(
    'sigungu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dongMyeonMeta = const VerificationMeta(
    'dongMyeon',
  );
  @override
  late final GeneratedColumn<String> dongMyeon = GeneratedColumn<String>(
    'dong_myeon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailAddressMeta = const VerificationMeta(
    'detailAddress',
  );
  @override
  late final GeneratedColumn<String> detailAddress = GeneratedColumn<String>(
    'detail_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSuretyInsuranceAvailableMeta =
      const VerificationMeta('isSuretyInsuranceAvailable');
  @override
  late final GeneratedColumn<bool> isSuretyInsuranceAvailable =
      GeneratedColumn<bool>(
        'is_surety_insurance_available',
        aliasedName,
        true,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_surety_insurance_available" IN (0, 1))',
        ),
      );
  static const VerificationMeta _hasLoanMeta = const VerificationMeta(
    'hasLoan',
  );
  @override
  late final GeneratedColumn<bool> hasLoan = GeneratedColumn<bool>(
    'has_loan',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_loan" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isParkingAvailableMeta =
      const VerificationMeta('isParkingAvailable');
  @override
  late final GeneratedColumn<bool> isParkingAvailable = GeneratedColumn<bool>(
    'is_parking_available',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_parking_available" IN (0, 1))',
    ),
  );
  static const VerificationMeta _moveInDateMeta = const VerificationMeta(
    'moveInDate',
  );
  @override
  late final GeneratedColumn<DateTime> moveInDate = GeneratedColumn<DateTime>(
    'move_in_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFlexibleMoveInDateMeta =
      const VerificationMeta('isFlexibleMoveInDate');
  @override
  late final GeneratedColumn<bool> isFlexibleMoveInDate = GeneratedColumn<bool>(
    'is_flexible_move_in_date',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_flexible_move_in_date" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _roomCountMeta = const VerificationMeta(
    'roomCount',
  );
  @override
  late final GeneratedColumn<int> roomCount = GeneratedColumn<int>(
    'room_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  furnitureOptions = GeneratedColumn<String>(
    'furniture_options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  ).withConverter<List<String>>($PropertyTableTable.$converterfurnitureOptions);
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerName,
    ownerPhone,
    transactionType,
    propertyType,
    price,
    monthlyRent,
    maintenanceCost,
    zipCode,
    roadAddress,
    lotAddress,
    sido,
    sigungu,
    dongMyeon,
    detailAddress,
    latitude,
    longitude,
    isSuretyInsuranceAvailable,
    hasLoan,
    isParkingAvailable,
    moveInDate,
    isFlexibleMoveInDate,
    roomCount,
    furnitureOptions,
    memo,
    updatedAt,
    deletedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<PropertyTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerNameMeta);
    }
    if (data.containsKey('owner_phone')) {
      context.handle(
        _ownerPhoneMeta,
        ownerPhone.isAcceptableOrUnknown(data['owner_phone']!, _ownerPhoneMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerPhoneMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('monthly_rent')) {
      context.handle(
        _monthlyRentMeta,
        monthlyRent.isAcceptableOrUnknown(
          data['monthly_rent']!,
          _monthlyRentMeta,
        ),
      );
    }
    if (data.containsKey('maintenance_cost')) {
      context.handle(
        _maintenanceCostMeta,
        maintenanceCost.isAcceptableOrUnknown(
          data['maintenance_cost']!,
          _maintenanceCostMeta,
        ),
      );
    }
    if (data.containsKey('zip_code')) {
      context.handle(
        _zipCodeMeta,
        zipCode.isAcceptableOrUnknown(data['zip_code']!, _zipCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_zipCodeMeta);
    }
    if (data.containsKey('road_address')) {
      context.handle(
        _roadAddressMeta,
        roadAddress.isAcceptableOrUnknown(
          data['road_address']!,
          _roadAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roadAddressMeta);
    }
    if (data.containsKey('lot_address')) {
      context.handle(
        _lotAddressMeta,
        lotAddress.isAcceptableOrUnknown(data['lot_address']!, _lotAddressMeta),
      );
    } else if (isInserting) {
      context.missing(_lotAddressMeta);
    }
    if (data.containsKey('sido')) {
      context.handle(
        _sidoMeta,
        sido.isAcceptableOrUnknown(data['sido']!, _sidoMeta),
      );
    } else if (isInserting) {
      context.missing(_sidoMeta);
    }
    if (data.containsKey('sigungu')) {
      context.handle(
        _sigunguMeta,
        sigungu.isAcceptableOrUnknown(data['sigungu']!, _sigunguMeta),
      );
    } else if (isInserting) {
      context.missing(_sigunguMeta);
    }
    if (data.containsKey('dong_myeon')) {
      context.handle(
        _dongMyeonMeta,
        dongMyeon.isAcceptableOrUnknown(data['dong_myeon']!, _dongMyeonMeta),
      );
    } else if (isInserting) {
      context.missing(_dongMyeonMeta);
    }
    if (data.containsKey('detail_address')) {
      context.handle(
        _detailAddressMeta,
        detailAddress.isAcceptableOrUnknown(
          data['detail_address']!,
          _detailAddressMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('is_surety_insurance_available')) {
      context.handle(
        _isSuretyInsuranceAvailableMeta,
        isSuretyInsuranceAvailable.isAcceptableOrUnknown(
          data['is_surety_insurance_available']!,
          _isSuretyInsuranceAvailableMeta,
        ),
      );
    }
    if (data.containsKey('has_loan')) {
      context.handle(
        _hasLoanMeta,
        hasLoan.isAcceptableOrUnknown(data['has_loan']!, _hasLoanMeta),
      );
    }
    if (data.containsKey('is_parking_available')) {
      context.handle(
        _isParkingAvailableMeta,
        isParkingAvailable.isAcceptableOrUnknown(
          data['is_parking_available']!,
          _isParkingAvailableMeta,
        ),
      );
    }
    if (data.containsKey('move_in_date')) {
      context.handle(
        _moveInDateMeta,
        moveInDate.isAcceptableOrUnknown(
          data['move_in_date']!,
          _moveInDateMeta,
        ),
      );
    }
    if (data.containsKey('is_flexible_move_in_date')) {
      context.handle(
        _isFlexibleMoveInDateMeta,
        isFlexibleMoveInDate.isAcceptableOrUnknown(
          data['is_flexible_move_in_date']!,
          _isFlexibleMoveInDateMeta,
        ),
      );
    }
    if (data.containsKey('room_count')) {
      context.handle(
        _roomCountMeta,
        roomCount.isAcceptableOrUnknown(data['room_count']!, _roomCountMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      )!,
      ownerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_phone'],
      )!,
      transactionType: $PropertyTableTable.$convertertransactionType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}transaction_type'],
        )!,
      ),
      propertyType: $PropertyTableTable.$converterpropertyType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}property_type'],
        )!,
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      monthlyRent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_rent'],
      ),
      maintenanceCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maintenance_cost'],
      ),
      zipCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zip_code'],
      )!,
      roadAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}road_address'],
      )!,
      lotAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot_address'],
      )!,
      sido: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sido'],
      )!,
      sigungu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sigungu'],
      )!,
      dongMyeon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dong_myeon'],
      )!,
      detailAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_address'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      isSuretyInsuranceAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_surety_insurance_available'],
      ),
      hasLoan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_loan'],
      ),
      isParkingAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_parking_available'],
      ),
      moveInDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}move_in_date'],
      ),
      isFlexibleMoveInDate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_flexible_move_in_date'],
      )!,
      roomCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_count'],
      ),
      furnitureOptions: $PropertyTableTable.$converterfurnitureOptions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}furniture_options'],
        )!,
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $PropertyTableTable createAlias(String alias) {
    return $PropertyTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PropertyTransactionType, String, String>
  $convertertransactionType = const EnumNameConverter<PropertyTransactionType>(
    PropertyTransactionType.values,
  );
  static JsonTypeConverter2<PropertyType, String, String>
  $converterpropertyType = const EnumNameConverter<PropertyType>(
    PropertyType.values,
  );
  static TypeConverter<List<String>, String> $converterfurnitureOptions =
      const StringListConverter();
}

class PropertyTableData extends DataClass
    implements Insertable<PropertyTableData> {
  final String id;
  final String ownerName;
  final String ownerPhone;
  final PropertyTransactionType transactionType;
  final PropertyType propertyType;
  final int price;
  final int? monthlyRent;
  final int? maintenanceCost;
  final String zipCode;
  final String roadAddress;
  final String lotAddress;
  final String sido;
  final String sigungu;
  final String dongMyeon;
  final String detailAddress;
  final double latitude;
  final double longitude;
  final bool? isSuretyInsuranceAvailable;
  final bool? hasLoan;
  final bool? isParkingAvailable;
  final DateTime? moveInDate;
  final bool isFlexibleMoveInDate;
  final int? roomCount;
  final List<String> furnitureOptions;
  final String memo;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? syncedAt;
  const PropertyTableData({
    required this.id,
    required this.ownerName,
    required this.ownerPhone,
    required this.transactionType,
    required this.propertyType,
    required this.price,
    this.monthlyRent,
    this.maintenanceCost,
    required this.zipCode,
    required this.roadAddress,
    required this.lotAddress,
    required this.sido,
    required this.sigungu,
    required this.dongMyeon,
    required this.detailAddress,
    required this.latitude,
    required this.longitude,
    this.isSuretyInsuranceAvailable,
    this.hasLoan,
    this.isParkingAvailable,
    this.moveInDate,
    required this.isFlexibleMoveInDate,
    this.roomCount,
    required this.furnitureOptions,
    required this.memo,
    required this.updatedAt,
    this.deletedAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_name'] = Variable<String>(ownerName);
    map['owner_phone'] = Variable<String>(ownerPhone);
    {
      map['transaction_type'] = Variable<String>(
        $PropertyTableTable.$convertertransactionType.toSql(transactionType),
      );
    }
    {
      map['property_type'] = Variable<String>(
        $PropertyTableTable.$converterpropertyType.toSql(propertyType),
      );
    }
    map['price'] = Variable<int>(price);
    if (!nullToAbsent || monthlyRent != null) {
      map['monthly_rent'] = Variable<int>(monthlyRent);
    }
    if (!nullToAbsent || maintenanceCost != null) {
      map['maintenance_cost'] = Variable<int>(maintenanceCost);
    }
    map['zip_code'] = Variable<String>(zipCode);
    map['road_address'] = Variable<String>(roadAddress);
    map['lot_address'] = Variable<String>(lotAddress);
    map['sido'] = Variable<String>(sido);
    map['sigungu'] = Variable<String>(sigungu);
    map['dong_myeon'] = Variable<String>(dongMyeon);
    map['detail_address'] = Variable<String>(detailAddress);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || isSuretyInsuranceAvailable != null) {
      map['is_surety_insurance_available'] = Variable<bool>(
        isSuretyInsuranceAvailable,
      );
    }
    if (!nullToAbsent || hasLoan != null) {
      map['has_loan'] = Variable<bool>(hasLoan);
    }
    if (!nullToAbsent || isParkingAvailable != null) {
      map['is_parking_available'] = Variable<bool>(isParkingAvailable);
    }
    if (!nullToAbsent || moveInDate != null) {
      map['move_in_date'] = Variable<DateTime>(moveInDate);
    }
    map['is_flexible_move_in_date'] = Variable<bool>(isFlexibleMoveInDate);
    if (!nullToAbsent || roomCount != null) {
      map['room_count'] = Variable<int>(roomCount);
    }
    {
      map['furniture_options'] = Variable<String>(
        $PropertyTableTable.$converterfurnitureOptions.toSql(furnitureOptions),
      );
    }
    map['memo'] = Variable<String>(memo);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PropertyTableCompanion toCompanion(bool nullToAbsent) {
    return PropertyTableCompanion(
      id: Value(id),
      ownerName: Value(ownerName),
      ownerPhone: Value(ownerPhone),
      transactionType: Value(transactionType),
      propertyType: Value(propertyType),
      price: Value(price),
      monthlyRent: monthlyRent == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyRent),
      maintenanceCost: maintenanceCost == null && nullToAbsent
          ? const Value.absent()
          : Value(maintenanceCost),
      zipCode: Value(zipCode),
      roadAddress: Value(roadAddress),
      lotAddress: Value(lotAddress),
      sido: Value(sido),
      sigungu: Value(sigungu),
      dongMyeon: Value(dongMyeon),
      detailAddress: Value(detailAddress),
      latitude: Value(latitude),
      longitude: Value(longitude),
      isSuretyInsuranceAvailable:
          isSuretyInsuranceAvailable == null && nullToAbsent
          ? const Value.absent()
          : Value(isSuretyInsuranceAvailable),
      hasLoan: hasLoan == null && nullToAbsent
          ? const Value.absent()
          : Value(hasLoan),
      isParkingAvailable: isParkingAvailable == null && nullToAbsent
          ? const Value.absent()
          : Value(isParkingAvailable),
      moveInDate: moveInDate == null && nullToAbsent
          ? const Value.absent()
          : Value(moveInDate),
      isFlexibleMoveInDate: Value(isFlexibleMoveInDate),
      roomCount: roomCount == null && nullToAbsent
          ? const Value.absent()
          : Value(roomCount),
      furnitureOptions: Value(furnitureOptions),
      memo: Value(memo),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PropertyTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyTableData(
      id: serializer.fromJson<String>(json['id']),
      ownerName: serializer.fromJson<String>(json['ownerName']),
      ownerPhone: serializer.fromJson<String>(json['ownerPhone']),
      transactionType: $PropertyTableTable.$convertertransactionType.fromJson(
        serializer.fromJson<String>(json['transactionType']),
      ),
      propertyType: $PropertyTableTable.$converterpropertyType.fromJson(
        serializer.fromJson<String>(json['propertyType']),
      ),
      price: serializer.fromJson<int>(json['price']),
      monthlyRent: serializer.fromJson<int?>(json['monthlyRent']),
      maintenanceCost: serializer.fromJson<int?>(json['maintenanceCost']),
      zipCode: serializer.fromJson<String>(json['zipCode']),
      roadAddress: serializer.fromJson<String>(json['roadAddress']),
      lotAddress: serializer.fromJson<String>(json['lotAddress']),
      sido: serializer.fromJson<String>(json['sido']),
      sigungu: serializer.fromJson<String>(json['sigungu']),
      dongMyeon: serializer.fromJson<String>(json['dongMyeon']),
      detailAddress: serializer.fromJson<String>(json['detailAddress']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      isSuretyInsuranceAvailable: serializer.fromJson<bool?>(
        json['isSuretyInsuranceAvailable'],
      ),
      hasLoan: serializer.fromJson<bool?>(json['hasLoan']),
      isParkingAvailable: serializer.fromJson<bool?>(
        json['isParkingAvailable'],
      ),
      moveInDate: serializer.fromJson<DateTime?>(json['moveInDate']),
      isFlexibleMoveInDate: serializer.fromJson<bool>(
        json['isFlexibleMoveInDate'],
      ),
      roomCount: serializer.fromJson<int?>(json['roomCount']),
      furnitureOptions: serializer.fromJson<List<String>>(
        json['furnitureOptions'],
      ),
      memo: serializer.fromJson<String>(json['memo']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerName': serializer.toJson<String>(ownerName),
      'ownerPhone': serializer.toJson<String>(ownerPhone),
      'transactionType': serializer.toJson<String>(
        $PropertyTableTable.$convertertransactionType.toJson(transactionType),
      ),
      'propertyType': serializer.toJson<String>(
        $PropertyTableTable.$converterpropertyType.toJson(propertyType),
      ),
      'price': serializer.toJson<int>(price),
      'monthlyRent': serializer.toJson<int?>(monthlyRent),
      'maintenanceCost': serializer.toJson<int?>(maintenanceCost),
      'zipCode': serializer.toJson<String>(zipCode),
      'roadAddress': serializer.toJson<String>(roadAddress),
      'lotAddress': serializer.toJson<String>(lotAddress),
      'sido': serializer.toJson<String>(sido),
      'sigungu': serializer.toJson<String>(sigungu),
      'dongMyeon': serializer.toJson<String>(dongMyeon),
      'detailAddress': serializer.toJson<String>(detailAddress),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'isSuretyInsuranceAvailable': serializer.toJson<bool?>(
        isSuretyInsuranceAvailable,
      ),
      'hasLoan': serializer.toJson<bool?>(hasLoan),
      'isParkingAvailable': serializer.toJson<bool?>(isParkingAvailable),
      'moveInDate': serializer.toJson<DateTime?>(moveInDate),
      'isFlexibleMoveInDate': serializer.toJson<bool>(isFlexibleMoveInDate),
      'roomCount': serializer.toJson<int?>(roomCount),
      'furnitureOptions': serializer.toJson<List<String>>(furnitureOptions),
      'memo': serializer.toJson<String>(memo),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PropertyTableData copyWith({
    String? id,
    String? ownerName,
    String? ownerPhone,
    PropertyTransactionType? transactionType,
    PropertyType? propertyType,
    int? price,
    Value<int?> monthlyRent = const Value.absent(),
    Value<int?> maintenanceCost = const Value.absent(),
    String? zipCode,
    String? roadAddress,
    String? lotAddress,
    String? sido,
    String? sigungu,
    String? dongMyeon,
    String? detailAddress,
    double? latitude,
    double? longitude,
    Value<bool?> isSuretyInsuranceAvailable = const Value.absent(),
    Value<bool?> hasLoan = const Value.absent(),
    Value<bool?> isParkingAvailable = const Value.absent(),
    Value<DateTime?> moveInDate = const Value.absent(),
    bool? isFlexibleMoveInDate,
    Value<int?> roomCount = const Value.absent(),
    List<String>? furnitureOptions,
    String? memo,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => PropertyTableData(
    id: id ?? this.id,
    ownerName: ownerName ?? this.ownerName,
    ownerPhone: ownerPhone ?? this.ownerPhone,
    transactionType: transactionType ?? this.transactionType,
    propertyType: propertyType ?? this.propertyType,
    price: price ?? this.price,
    monthlyRent: monthlyRent.present ? monthlyRent.value : this.monthlyRent,
    maintenanceCost: maintenanceCost.present
        ? maintenanceCost.value
        : this.maintenanceCost,
    zipCode: zipCode ?? this.zipCode,
    roadAddress: roadAddress ?? this.roadAddress,
    lotAddress: lotAddress ?? this.lotAddress,
    sido: sido ?? this.sido,
    sigungu: sigungu ?? this.sigungu,
    dongMyeon: dongMyeon ?? this.dongMyeon,
    detailAddress: detailAddress ?? this.detailAddress,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isSuretyInsuranceAvailable: isSuretyInsuranceAvailable.present
        ? isSuretyInsuranceAvailable.value
        : this.isSuretyInsuranceAvailable,
    hasLoan: hasLoan.present ? hasLoan.value : this.hasLoan,
    isParkingAvailable: isParkingAvailable.present
        ? isParkingAvailable.value
        : this.isParkingAvailable,
    moveInDate: moveInDate.present ? moveInDate.value : this.moveInDate,
    isFlexibleMoveInDate: isFlexibleMoveInDate ?? this.isFlexibleMoveInDate,
    roomCount: roomCount.present ? roomCount.value : this.roomCount,
    furnitureOptions: furnitureOptions ?? this.furnitureOptions,
    memo: memo ?? this.memo,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  PropertyTableData copyWithCompanion(PropertyTableCompanion data) {
    return PropertyTableData(
      id: data.id.present ? data.id.value : this.id,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      ownerPhone: data.ownerPhone.present
          ? data.ownerPhone.value
          : this.ownerPhone,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      propertyType: data.propertyType.present
          ? data.propertyType.value
          : this.propertyType,
      price: data.price.present ? data.price.value : this.price,
      monthlyRent: data.monthlyRent.present
          ? data.monthlyRent.value
          : this.monthlyRent,
      maintenanceCost: data.maintenanceCost.present
          ? data.maintenanceCost.value
          : this.maintenanceCost,
      zipCode: data.zipCode.present ? data.zipCode.value : this.zipCode,
      roadAddress: data.roadAddress.present
          ? data.roadAddress.value
          : this.roadAddress,
      lotAddress: data.lotAddress.present
          ? data.lotAddress.value
          : this.lotAddress,
      sido: data.sido.present ? data.sido.value : this.sido,
      sigungu: data.sigungu.present ? data.sigungu.value : this.sigungu,
      dongMyeon: data.dongMyeon.present ? data.dongMyeon.value : this.dongMyeon,
      detailAddress: data.detailAddress.present
          ? data.detailAddress.value
          : this.detailAddress,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isSuretyInsuranceAvailable: data.isSuretyInsuranceAvailable.present
          ? data.isSuretyInsuranceAvailable.value
          : this.isSuretyInsuranceAvailable,
      hasLoan: data.hasLoan.present ? data.hasLoan.value : this.hasLoan,
      isParkingAvailable: data.isParkingAvailable.present
          ? data.isParkingAvailable.value
          : this.isParkingAvailable,
      moveInDate: data.moveInDate.present
          ? data.moveInDate.value
          : this.moveInDate,
      isFlexibleMoveInDate: data.isFlexibleMoveInDate.present
          ? data.isFlexibleMoveInDate.value
          : this.isFlexibleMoveInDate,
      roomCount: data.roomCount.present ? data.roomCount.value : this.roomCount,
      furnitureOptions: data.furnitureOptions.present
          ? data.furnitureOptions.value
          : this.furnitureOptions,
      memo: data.memo.present ? data.memo.value : this.memo,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyTableData(')
          ..write('id: $id, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerPhone: $ownerPhone, ')
          ..write('transactionType: $transactionType, ')
          ..write('propertyType: $propertyType, ')
          ..write('price: $price, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('maintenanceCost: $maintenanceCost, ')
          ..write('zipCode: $zipCode, ')
          ..write('roadAddress: $roadAddress, ')
          ..write('lotAddress: $lotAddress, ')
          ..write('sido: $sido, ')
          ..write('sigungu: $sigungu, ')
          ..write('dongMyeon: $dongMyeon, ')
          ..write('detailAddress: $detailAddress, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isSuretyInsuranceAvailable: $isSuretyInsuranceAvailable, ')
          ..write('hasLoan: $hasLoan, ')
          ..write('isParkingAvailable: $isParkingAvailable, ')
          ..write('moveInDate: $moveInDate, ')
          ..write('isFlexibleMoveInDate: $isFlexibleMoveInDate, ')
          ..write('roomCount: $roomCount, ')
          ..write('furnitureOptions: $furnitureOptions, ')
          ..write('memo: $memo, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    ownerName,
    ownerPhone,
    transactionType,
    propertyType,
    price,
    monthlyRent,
    maintenanceCost,
    zipCode,
    roadAddress,
    lotAddress,
    sido,
    sigungu,
    dongMyeon,
    detailAddress,
    latitude,
    longitude,
    isSuretyInsuranceAvailable,
    hasLoan,
    isParkingAvailable,
    moveInDate,
    isFlexibleMoveInDate,
    roomCount,
    furnitureOptions,
    memo,
    updatedAt,
    deletedAt,
    syncedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyTableData &&
          other.id == this.id &&
          other.ownerName == this.ownerName &&
          other.ownerPhone == this.ownerPhone &&
          other.transactionType == this.transactionType &&
          other.propertyType == this.propertyType &&
          other.price == this.price &&
          other.monthlyRent == this.monthlyRent &&
          other.maintenanceCost == this.maintenanceCost &&
          other.zipCode == this.zipCode &&
          other.roadAddress == this.roadAddress &&
          other.lotAddress == this.lotAddress &&
          other.sido == this.sido &&
          other.sigungu == this.sigungu &&
          other.dongMyeon == this.dongMyeon &&
          other.detailAddress == this.detailAddress &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isSuretyInsuranceAvailable == this.isSuretyInsuranceAvailable &&
          other.hasLoan == this.hasLoan &&
          other.isParkingAvailable == this.isParkingAvailable &&
          other.moveInDate == this.moveInDate &&
          other.isFlexibleMoveInDate == this.isFlexibleMoveInDate &&
          other.roomCount == this.roomCount &&
          other.furnitureOptions == this.furnitureOptions &&
          other.memo == this.memo &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncedAt == this.syncedAt);
}

class PropertyTableCompanion extends UpdateCompanion<PropertyTableData> {
  final Value<String> id;
  final Value<String> ownerName;
  final Value<String> ownerPhone;
  final Value<PropertyTransactionType> transactionType;
  final Value<PropertyType> propertyType;
  final Value<int> price;
  final Value<int?> monthlyRent;
  final Value<int?> maintenanceCost;
  final Value<String> zipCode;
  final Value<String> roadAddress;
  final Value<String> lotAddress;
  final Value<String> sido;
  final Value<String> sigungu;
  final Value<String> dongMyeon;
  final Value<String> detailAddress;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<bool?> isSuretyInsuranceAvailable;
  final Value<bool?> hasLoan;
  final Value<bool?> isParkingAvailable;
  final Value<DateTime?> moveInDate;
  final Value<bool> isFlexibleMoveInDate;
  final Value<int?> roomCount;
  final Value<List<String>> furnitureOptions;
  final Value<String> memo;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PropertyTableCompanion({
    this.id = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerPhone = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.propertyType = const Value.absent(),
    this.price = const Value.absent(),
    this.monthlyRent = const Value.absent(),
    this.maintenanceCost = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.roadAddress = const Value.absent(),
    this.lotAddress = const Value.absent(),
    this.sido = const Value.absent(),
    this.sigungu = const Value.absent(),
    this.dongMyeon = const Value.absent(),
    this.detailAddress = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isSuretyInsuranceAvailable = const Value.absent(),
    this.hasLoan = const Value.absent(),
    this.isParkingAvailable = const Value.absent(),
    this.moveInDate = const Value.absent(),
    this.isFlexibleMoveInDate = const Value.absent(),
    this.roomCount = const Value.absent(),
    this.furnitureOptions = const Value.absent(),
    this.memo = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertyTableCompanion.insert({
    required String id,
    required String ownerName,
    required String ownerPhone,
    required PropertyTransactionType transactionType,
    required PropertyType propertyType,
    required int price,
    this.monthlyRent = const Value.absent(),
    this.maintenanceCost = const Value.absent(),
    required String zipCode,
    required String roadAddress,
    required String lotAddress,
    required String sido,
    required String sigungu,
    required String dongMyeon,
    this.detailAddress = const Value.absent(),
    required double latitude,
    required double longitude,
    this.isSuretyInsuranceAvailable = const Value.absent(),
    this.hasLoan = const Value.absent(),
    this.isParkingAvailable = const Value.absent(),
    this.moveInDate = const Value.absent(),
    this.isFlexibleMoveInDate = const Value.absent(),
    this.roomCount = const Value.absent(),
    this.furnitureOptions = const Value.absent(),
    this.memo = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerName = Value(ownerName),
       ownerPhone = Value(ownerPhone),
       transactionType = Value(transactionType),
       propertyType = Value(propertyType),
       price = Value(price),
       zipCode = Value(zipCode),
       roadAddress = Value(roadAddress),
       lotAddress = Value(lotAddress),
       sido = Value(sido),
       sigungu = Value(sigungu),
       dongMyeon = Value(dongMyeon),
       latitude = Value(latitude),
       longitude = Value(longitude),
       updatedAt = Value(updatedAt);
  static Insertable<PropertyTableData> custom({
    Expression<String>? id,
    Expression<String>? ownerName,
    Expression<String>? ownerPhone,
    Expression<String>? transactionType,
    Expression<String>? propertyType,
    Expression<int>? price,
    Expression<int>? monthlyRent,
    Expression<int>? maintenanceCost,
    Expression<String>? zipCode,
    Expression<String>? roadAddress,
    Expression<String>? lotAddress,
    Expression<String>? sido,
    Expression<String>? sigungu,
    Expression<String>? dongMyeon,
    Expression<String>? detailAddress,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isSuretyInsuranceAvailable,
    Expression<bool>? hasLoan,
    Expression<bool>? isParkingAvailable,
    Expression<DateTime>? moveInDate,
    Expression<bool>? isFlexibleMoveInDate,
    Expression<int>? roomCount,
    Expression<String>? furnitureOptions,
    Expression<String>? memo,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerPhone != null) 'owner_phone': ownerPhone,
      if (transactionType != null) 'transaction_type': transactionType,
      if (propertyType != null) 'property_type': propertyType,
      if (price != null) 'price': price,
      if (monthlyRent != null) 'monthly_rent': monthlyRent,
      if (maintenanceCost != null) 'maintenance_cost': maintenanceCost,
      if (zipCode != null) 'zip_code': zipCode,
      if (roadAddress != null) 'road_address': roadAddress,
      if (lotAddress != null) 'lot_address': lotAddress,
      if (sido != null) 'sido': sido,
      if (sigungu != null) 'sigungu': sigungu,
      if (dongMyeon != null) 'dong_myeon': dongMyeon,
      if (detailAddress != null) 'detail_address': detailAddress,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isSuretyInsuranceAvailable != null)
        'is_surety_insurance_available': isSuretyInsuranceAvailable,
      if (hasLoan != null) 'has_loan': hasLoan,
      if (isParkingAvailable != null)
        'is_parking_available': isParkingAvailable,
      if (moveInDate != null) 'move_in_date': moveInDate,
      if (isFlexibleMoveInDate != null)
        'is_flexible_move_in_date': isFlexibleMoveInDate,
      if (roomCount != null) 'room_count': roomCount,
      if (furnitureOptions != null) 'furniture_options': furnitureOptions,
      if (memo != null) 'memo': memo,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertyTableCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerName,
    Value<String>? ownerPhone,
    Value<PropertyTransactionType>? transactionType,
    Value<PropertyType>? propertyType,
    Value<int>? price,
    Value<int?>? monthlyRent,
    Value<int?>? maintenanceCost,
    Value<String>? zipCode,
    Value<String>? roadAddress,
    Value<String>? lotAddress,
    Value<String>? sido,
    Value<String>? sigungu,
    Value<String>? dongMyeon,
    Value<String>? detailAddress,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<bool?>? isSuretyInsuranceAvailable,
    Value<bool?>? hasLoan,
    Value<bool?>? isParkingAvailable,
    Value<DateTime?>? moveInDate,
    Value<bool>? isFlexibleMoveInDate,
    Value<int?>? roomCount,
    Value<List<String>>? furnitureOptions,
    Value<String>? memo,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return PropertyTableCompanion(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      transactionType: transactionType ?? this.transactionType,
      propertyType: propertyType ?? this.propertyType,
      price: price ?? this.price,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      maintenanceCost: maintenanceCost ?? this.maintenanceCost,
      zipCode: zipCode ?? this.zipCode,
      roadAddress: roadAddress ?? this.roadAddress,
      lotAddress: lotAddress ?? this.lotAddress,
      sido: sido ?? this.sido,
      sigungu: sigungu ?? this.sigungu,
      dongMyeon: dongMyeon ?? this.dongMyeon,
      detailAddress: detailAddress ?? this.detailAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isSuretyInsuranceAvailable:
          isSuretyInsuranceAvailable ?? this.isSuretyInsuranceAvailable,
      hasLoan: hasLoan ?? this.hasLoan,
      isParkingAvailable: isParkingAvailable ?? this.isParkingAvailable,
      moveInDate: moveInDate ?? this.moveInDate,
      isFlexibleMoveInDate: isFlexibleMoveInDate ?? this.isFlexibleMoveInDate,
      roomCount: roomCount ?? this.roomCount,
      furnitureOptions: furnitureOptions ?? this.furnitureOptions,
      memo: memo ?? this.memo,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (ownerPhone.present) {
      map['owner_phone'] = Variable<String>(ownerPhone.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(
        $PropertyTableTable.$convertertransactionType.toSql(
          transactionType.value,
        ),
      );
    }
    if (propertyType.present) {
      map['property_type'] = Variable<String>(
        $PropertyTableTable.$converterpropertyType.toSql(propertyType.value),
      );
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (monthlyRent.present) {
      map['monthly_rent'] = Variable<int>(monthlyRent.value);
    }
    if (maintenanceCost.present) {
      map['maintenance_cost'] = Variable<int>(maintenanceCost.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<String>(zipCode.value);
    }
    if (roadAddress.present) {
      map['road_address'] = Variable<String>(roadAddress.value);
    }
    if (lotAddress.present) {
      map['lot_address'] = Variable<String>(lotAddress.value);
    }
    if (sido.present) {
      map['sido'] = Variable<String>(sido.value);
    }
    if (sigungu.present) {
      map['sigungu'] = Variable<String>(sigungu.value);
    }
    if (dongMyeon.present) {
      map['dong_myeon'] = Variable<String>(dongMyeon.value);
    }
    if (detailAddress.present) {
      map['detail_address'] = Variable<String>(detailAddress.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isSuretyInsuranceAvailable.present) {
      map['is_surety_insurance_available'] = Variable<bool>(
        isSuretyInsuranceAvailable.value,
      );
    }
    if (hasLoan.present) {
      map['has_loan'] = Variable<bool>(hasLoan.value);
    }
    if (isParkingAvailable.present) {
      map['is_parking_available'] = Variable<bool>(isParkingAvailable.value);
    }
    if (moveInDate.present) {
      map['move_in_date'] = Variable<DateTime>(moveInDate.value);
    }
    if (isFlexibleMoveInDate.present) {
      map['is_flexible_move_in_date'] = Variable<bool>(
        isFlexibleMoveInDate.value,
      );
    }
    if (roomCount.present) {
      map['room_count'] = Variable<int>(roomCount.value);
    }
    if (furnitureOptions.present) {
      map['furniture_options'] = Variable<String>(
        $PropertyTableTable.$converterfurnitureOptions.toSql(
          furnitureOptions.value,
        ),
      );
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertyTableCompanion(')
          ..write('id: $id, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerPhone: $ownerPhone, ')
          ..write('transactionType: $transactionType, ')
          ..write('propertyType: $propertyType, ')
          ..write('price: $price, ')
          ..write('monthlyRent: $monthlyRent, ')
          ..write('maintenanceCost: $maintenanceCost, ')
          ..write('zipCode: $zipCode, ')
          ..write('roadAddress: $roadAddress, ')
          ..write('lotAddress: $lotAddress, ')
          ..write('sido: $sido, ')
          ..write('sigungu: $sigungu, ')
          ..write('dongMyeon: $dongMyeon, ')
          ..write('detailAddress: $detailAddress, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isSuretyInsuranceAvailable: $isSuretyInsuranceAvailable, ')
          ..write('hasLoan: $hasLoan, ')
          ..write('isParkingAvailable: $isParkingAvailable, ')
          ..write('moveInDate: $moveInDate, ')
          ..write('isFlexibleMoveInDate: $isFlexibleMoveInDate, ')
          ..write('roomCount: $roomCount, ')
          ..write('furnitureOptions: $furnitureOptions, ')
          ..write('memo: $memo, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PropertyImageTableTable extends PropertyImageTable
    with TableInfo<$PropertyImageTableTable, PropertyImageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertyImageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id)',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    fileName,
    order,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'property_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<PropertyImageTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyImageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyImageTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PropertyImageTableTable createAlias(String alias) {
    return $PropertyImageTableTable(attachedDatabase, alias);
  }
}

class PropertyImageTableData extends DataClass
    implements Insertable<PropertyImageTableData> {
  final String id;
  final String propertyId;
  final String fileName;
  final int order;
  final DateTime createdAt;
  const PropertyImageTableData({
    required this.id,
    required this.propertyId,
    required this.fileName,
    required this.order,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['property_id'] = Variable<String>(propertyId);
    map['file_name'] = Variable<String>(fileName);
    map['order'] = Variable<int>(order);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PropertyImageTableCompanion toCompanion(bool nullToAbsent) {
    return PropertyImageTableCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      fileName: Value(fileName),
      order: Value(order),
      createdAt: Value(createdAt),
    );
  }

  factory PropertyImageTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyImageTableData(
      id: serializer.fromJson<String>(json['id']),
      propertyId: serializer.fromJson<String>(json['propertyId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      order: serializer.fromJson<int>(json['order']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'propertyId': serializer.toJson<String>(propertyId),
      'fileName': serializer.toJson<String>(fileName),
      'order': serializer.toJson<int>(order),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PropertyImageTableData copyWith({
    String? id,
    String? propertyId,
    String? fileName,
    int? order,
    DateTime? createdAt,
  }) => PropertyImageTableData(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    fileName: fileName ?? this.fileName,
    order: order ?? this.order,
    createdAt: createdAt ?? this.createdAt,
  );
  PropertyImageTableData copyWithCompanion(PropertyImageTableCompanion data) {
    return PropertyImageTableData(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      order: data.order.present ? data.order.value : this.order,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyImageTableData(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('fileName: $fileName, ')
          ..write('order: $order, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, propertyId, fileName, order, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyImageTableData &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.fileName == this.fileName &&
          other.order == this.order &&
          other.createdAt == this.createdAt);
}

class PropertyImageTableCompanion
    extends UpdateCompanion<PropertyImageTableData> {
  final Value<String> id;
  final Value<String> propertyId;
  final Value<String> fileName;
  final Value<int> order;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PropertyImageTableCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.order = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertyImageTableCompanion.insert({
    required String id,
    required String propertyId,
    required String fileName,
    required int order,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       propertyId = Value(propertyId),
       fileName = Value(fileName),
       order = Value(order),
       createdAt = Value(createdAt);
  static Insertable<PropertyImageTableData> custom({
    Expression<String>? id,
    Expression<String>? propertyId,
    Expression<String>? fileName,
    Expression<int>? order,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (fileName != null) 'file_name': fileName,
      if (order != null) 'order': order,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertyImageTableCompanion copyWith({
    Value<String>? id,
    Value<String>? propertyId,
    Value<String>? fileName,
    Value<int>? order,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PropertyImageTableCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      fileName: fileName ?? this.fileName,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertyImageTableCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('fileName: $fileName, ')
          ..write('order: $order, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PropertyTableTable propertyTable = $PropertyTableTable(this);
  late final $PropertyImageTableTable propertyImageTable =
      $PropertyImageTableTable(this);
  late final Index propertyImagesPropertyId = Index(
    'property_images_property_id',
    'CREATE INDEX property_images_property_id ON property_images (property_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    propertyTable,
    propertyImageTable,
    propertyImagesPropertyId,
  ];
}

typedef $$PropertyTableTableCreateCompanionBuilder =
    PropertyTableCompanion Function({
      required String id,
      required String ownerName,
      required String ownerPhone,
      required PropertyTransactionType transactionType,
      required PropertyType propertyType,
      required int price,
      Value<int?> monthlyRent,
      Value<int?> maintenanceCost,
      required String zipCode,
      required String roadAddress,
      required String lotAddress,
      required String sido,
      required String sigungu,
      required String dongMyeon,
      Value<String> detailAddress,
      required double latitude,
      required double longitude,
      Value<bool?> isSuretyInsuranceAvailable,
      Value<bool?> hasLoan,
      Value<bool?> isParkingAvailable,
      Value<DateTime?> moveInDate,
      Value<bool> isFlexibleMoveInDate,
      Value<int?> roomCount,
      Value<List<String>> furnitureOptions,
      Value<String> memo,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$PropertyTableTableUpdateCompanionBuilder =
    PropertyTableCompanion Function({
      Value<String> id,
      Value<String> ownerName,
      Value<String> ownerPhone,
      Value<PropertyTransactionType> transactionType,
      Value<PropertyType> propertyType,
      Value<int> price,
      Value<int?> monthlyRent,
      Value<int?> maintenanceCost,
      Value<String> zipCode,
      Value<String> roadAddress,
      Value<String> lotAddress,
      Value<String> sido,
      Value<String> sigungu,
      Value<String> dongMyeon,
      Value<String> detailAddress,
      Value<double> latitude,
      Value<double> longitude,
      Value<bool?> isSuretyInsuranceAvailable,
      Value<bool?> hasLoan,
      Value<bool?> isParkingAvailable,
      Value<DateTime?> moveInDate,
      Value<bool> isFlexibleMoveInDate,
      Value<int?> roomCount,
      Value<List<String>> furnitureOptions,
      Value<String> memo,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

final class $$PropertyTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $PropertyTableTable, PropertyTableData> {
  $$PropertyTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $PropertyImageTableTable,
    List<PropertyImageTableData>
  >
  _propertyImageTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.propertyImageTable,
        aliasName: 'properties__id__property_images__property_id',
      );

  $$PropertyImageTableTableProcessedTableManager get propertyImageTableRefs {
    final manager = $$PropertyImageTableTableTableManager(
      $_db,
      $_db.propertyImageTable,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _propertyImageTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertyTableTableFilterComposer
    extends Composer<_$AppDatabase, $PropertyTableTable> {
  $$PropertyTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPhone => $composableBuilder(
    column: $table.ownerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PropertyTransactionType,
    PropertyTransactionType,
    String
  >
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PropertyType, PropertyType, String>
  get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maintenanceCost => $composableBuilder(
    column: $table.maintenanceCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roadAddress => $composableBuilder(
    column: $table.roadAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lotAddress => $composableBuilder(
    column: $table.lotAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sido => $composableBuilder(
    column: $table.sido,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sigungu => $composableBuilder(
    column: $table.sigungu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dongMyeon => $composableBuilder(
    column: $table.dongMyeon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailAddress => $composableBuilder(
    column: $table.detailAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSuretyInsuranceAvailable => $composableBuilder(
    column: $table.isSuretyInsuranceAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasLoan => $composableBuilder(
    column: $table.hasLoan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isParkingAvailable => $composableBuilder(
    column: $table.isParkingAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFlexibleMoveInDate => $composableBuilder(
    column: $table.isFlexibleMoveInDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roomCount => $composableBuilder(
    column: $table.roomCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get furnitureOptions => $composableBuilder(
    column: $table.furnitureOptions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> propertyImageTableRefs(
    Expression<bool> Function($$PropertyImageTableTableFilterComposer f) f,
  ) {
    final $$PropertyImageTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.propertyImageTable,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertyImageTableTableFilterComposer(
            $db: $db,
            $table: $db.propertyImageTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertyTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertyTableTable> {
  $$PropertyTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPhone => $composableBuilder(
    column: $table.ownerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertyType => $composableBuilder(
    column: $table.propertyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maintenanceCost => $composableBuilder(
    column: $table.maintenanceCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roadAddress => $composableBuilder(
    column: $table.roadAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lotAddress => $composableBuilder(
    column: $table.lotAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sido => $composableBuilder(
    column: $table.sido,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sigungu => $composableBuilder(
    column: $table.sigungu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dongMyeon => $composableBuilder(
    column: $table.dongMyeon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailAddress => $composableBuilder(
    column: $table.detailAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSuretyInsuranceAvailable => $composableBuilder(
    column: $table.isSuretyInsuranceAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasLoan => $composableBuilder(
    column: $table.hasLoan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isParkingAvailable => $composableBuilder(
    column: $table.isParkingAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFlexibleMoveInDate => $composableBuilder(
    column: $table.isFlexibleMoveInDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roomCount => $composableBuilder(
    column: $table.roomCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furnitureOptions => $composableBuilder(
    column: $table.furnitureOptions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertyTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertyTableTable> {
  $$PropertyTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get ownerPhone => $composableBuilder(
    column: $table.ownerPhone,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PropertyTransactionType, String>
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PropertyType, String> get propertyType =>
      $composableBuilder(
        column: $table.propertyType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get monthlyRent => $composableBuilder(
    column: $table.monthlyRent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maintenanceCost => $composableBuilder(
    column: $table.maintenanceCost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get zipCode =>
      $composableBuilder(column: $table.zipCode, builder: (column) => column);

  GeneratedColumn<String> get roadAddress => $composableBuilder(
    column: $table.roadAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lotAddress => $composableBuilder(
    column: $table.lotAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sido =>
      $composableBuilder(column: $table.sido, builder: (column) => column);

  GeneratedColumn<String> get sigungu =>
      $composableBuilder(column: $table.sigungu, builder: (column) => column);

  GeneratedColumn<String> get dongMyeon =>
      $composableBuilder(column: $table.dongMyeon, builder: (column) => column);

  GeneratedColumn<String> get detailAddress => $composableBuilder(
    column: $table.detailAddress,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isSuretyInsuranceAvailable => $composableBuilder(
    column: $table.isSuretyInsuranceAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasLoan =>
      $composableBuilder(column: $table.hasLoan, builder: (column) => column);

  GeneratedColumn<bool> get isParkingAvailable => $composableBuilder(
    column: $table.isParkingAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFlexibleMoveInDate => $composableBuilder(
    column: $table.isFlexibleMoveInDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roomCount =>
      $composableBuilder(column: $table.roomCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get furnitureOptions =>
      $composableBuilder(
        column: $table.furnitureOptions,
        builder: (column) => column,
      );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> propertyImageTableRefs<T extends Object>(
    Expression<T> Function($$PropertyImageTableTableAnnotationComposer a) f,
  ) {
    final $$PropertyImageTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.propertyImageTable,
          getReferencedColumn: (t) => t.propertyId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PropertyImageTableTableAnnotationComposer(
                $db: $db,
                $table: $db.propertyImageTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PropertyTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertyTableTable,
          PropertyTableData,
          $$PropertyTableTableFilterComposer,
          $$PropertyTableTableOrderingComposer,
          $$PropertyTableTableAnnotationComposer,
          $$PropertyTableTableCreateCompanionBuilder,
          $$PropertyTableTableUpdateCompanionBuilder,
          (PropertyTableData, $$PropertyTableTableReferences),
          PropertyTableData,
          PrefetchHooks Function({bool propertyImageTableRefs})
        > {
  $$PropertyTableTableTableManager(_$AppDatabase db, $PropertyTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertyTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertyTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertyTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerName = const Value.absent(),
                Value<String> ownerPhone = const Value.absent(),
                Value<PropertyTransactionType> transactionType =
                    const Value.absent(),
                Value<PropertyType> propertyType = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int?> monthlyRent = const Value.absent(),
                Value<int?> maintenanceCost = const Value.absent(),
                Value<String> zipCode = const Value.absent(),
                Value<String> roadAddress = const Value.absent(),
                Value<String> lotAddress = const Value.absent(),
                Value<String> sido = const Value.absent(),
                Value<String> sigungu = const Value.absent(),
                Value<String> dongMyeon = const Value.absent(),
                Value<String> detailAddress = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<bool?> isSuretyInsuranceAvailable = const Value.absent(),
                Value<bool?> hasLoan = const Value.absent(),
                Value<bool?> isParkingAvailable = const Value.absent(),
                Value<DateTime?> moveInDate = const Value.absent(),
                Value<bool> isFlexibleMoveInDate = const Value.absent(),
                Value<int?> roomCount = const Value.absent(),
                Value<List<String>> furnitureOptions = const Value.absent(),
                Value<String> memo = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertyTableCompanion(
                id: id,
                ownerName: ownerName,
                ownerPhone: ownerPhone,
                transactionType: transactionType,
                propertyType: propertyType,
                price: price,
                monthlyRent: monthlyRent,
                maintenanceCost: maintenanceCost,
                zipCode: zipCode,
                roadAddress: roadAddress,
                lotAddress: lotAddress,
                sido: sido,
                sigungu: sigungu,
                dongMyeon: dongMyeon,
                detailAddress: detailAddress,
                latitude: latitude,
                longitude: longitude,
                isSuretyInsuranceAvailable: isSuretyInsuranceAvailable,
                hasLoan: hasLoan,
                isParkingAvailable: isParkingAvailable,
                moveInDate: moveInDate,
                isFlexibleMoveInDate: isFlexibleMoveInDate,
                roomCount: roomCount,
                furnitureOptions: furnitureOptions,
                memo: memo,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerName,
                required String ownerPhone,
                required PropertyTransactionType transactionType,
                required PropertyType propertyType,
                required int price,
                Value<int?> monthlyRent = const Value.absent(),
                Value<int?> maintenanceCost = const Value.absent(),
                required String zipCode,
                required String roadAddress,
                required String lotAddress,
                required String sido,
                required String sigungu,
                required String dongMyeon,
                Value<String> detailAddress = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<bool?> isSuretyInsuranceAvailable = const Value.absent(),
                Value<bool?> hasLoan = const Value.absent(),
                Value<bool?> isParkingAvailable = const Value.absent(),
                Value<DateTime?> moveInDate = const Value.absent(),
                Value<bool> isFlexibleMoveInDate = const Value.absent(),
                Value<int?> roomCount = const Value.absent(),
                Value<List<String>> furnitureOptions = const Value.absent(),
                Value<String> memo = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertyTableCompanion.insert(
                id: id,
                ownerName: ownerName,
                ownerPhone: ownerPhone,
                transactionType: transactionType,
                propertyType: propertyType,
                price: price,
                monthlyRent: monthlyRent,
                maintenanceCost: maintenanceCost,
                zipCode: zipCode,
                roadAddress: roadAddress,
                lotAddress: lotAddress,
                sido: sido,
                sigungu: sigungu,
                dongMyeon: dongMyeon,
                detailAddress: detailAddress,
                latitude: latitude,
                longitude: longitude,
                isSuretyInsuranceAvailable: isSuretyInsuranceAvailable,
                hasLoan: hasLoan,
                isParkingAvailable: isParkingAvailable,
                moveInDate: moveInDate,
                isFlexibleMoveInDate: isFlexibleMoveInDate,
                roomCount: roomCount,
                furnitureOptions: furnitureOptions,
                memo: memo,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PropertyTableTable, PropertyTableData>(table),
                  $$PropertyTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({propertyImageTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (propertyImageTableRefs) db.propertyImageTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (propertyImageTableRefs)
                    await $_getPrefetchedData<
                      PropertyTableData,
                      $PropertyTableTable,
                      PropertyImageTableData
                    >(
                      currentTable: table,
                      referencedTable: $$PropertyTableTableReferences
                          ._propertyImageTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PropertyTableTableReferences(
                            db,
                            table,
                            p0,
                          ).propertyImageTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.propertyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PropertyTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertyTableTable,
      PropertyTableData,
      $$PropertyTableTableFilterComposer,
      $$PropertyTableTableOrderingComposer,
      $$PropertyTableTableAnnotationComposer,
      $$PropertyTableTableCreateCompanionBuilder,
      $$PropertyTableTableUpdateCompanionBuilder,
      (PropertyTableData, $$PropertyTableTableReferences),
      PropertyTableData,
      PrefetchHooks Function({bool propertyImageTableRefs})
    >;
typedef $$PropertyImageTableTableCreateCompanionBuilder =
    PropertyImageTableCompanion Function({
      required String id,
      required String propertyId,
      required String fileName,
      required int order,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PropertyImageTableTableUpdateCompanionBuilder =
    PropertyImageTableCompanion Function({
      Value<String> id,
      Value<String> propertyId,
      Value<String> fileName,
      Value<int> order,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PropertyImageTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PropertyImageTableTable,
          PropertyImageTableData
        > {
  $$PropertyImageTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PropertyTableTable _propertyIdTable(_$AppDatabase db) => db
      .propertyTable
      .createAlias('property_images__property_id__properties__id');

  $$PropertyTableTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<String>('property_id')!;

    final manager = $$PropertyTableTableTableManager(
      $_db,
      $_db.propertyTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PropertyImageTableTableFilterComposer
    extends Composer<_$AppDatabase, $PropertyImageTableTable> {
  $$PropertyImageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertyTableTableFilterComposer get propertyId {
    final $$PropertyTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.propertyTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertyTableTableFilterComposer(
            $db: $db,
            $table: $db.propertyTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PropertyImageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertyImageTableTable> {
  $$PropertyImageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertyTableTableOrderingComposer get propertyId {
    final $$PropertyTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.propertyTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertyTableTableOrderingComposer(
            $db: $db,
            $table: $db.propertyTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PropertyImageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertyImageTableTable> {
  $$PropertyImageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PropertyTableTableAnnotationComposer get propertyId {
    final $$PropertyTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.propertyTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertyTableTableAnnotationComposer(
            $db: $db,
            $table: $db.propertyTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PropertyImageTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertyImageTableTable,
          PropertyImageTableData,
          $$PropertyImageTableTableFilterComposer,
          $$PropertyImageTableTableOrderingComposer,
          $$PropertyImageTableTableAnnotationComposer,
          $$PropertyImageTableTableCreateCompanionBuilder,
          $$PropertyImageTableTableUpdateCompanionBuilder,
          (PropertyImageTableData, $$PropertyImageTableTableReferences),
          PropertyImageTableData,
          PrefetchHooks Function({bool propertyId})
        > {
  $$PropertyImageTableTableTableManager(
    _$AppDatabase db,
    $PropertyImageTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertyImageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertyImageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertyImageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertyImageTableCompanion(
                id: id,
                propertyId: propertyId,
                fileName: fileName,
                order: order,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String propertyId,
                required String fileName,
                required int order,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PropertyImageTableCompanion.insert(
                id: id,
                propertyId: propertyId,
                fileName: fileName,
                order: order,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PropertyImageTableTable, PropertyImageTableData>(
                    table,
                  ),
                  $$PropertyImageTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({propertyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (propertyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.propertyId,
                                referencedTable:
                                    $$PropertyImageTableTableReferences
                                        ._propertyIdTable(db),
                                referencedColumn:
                                    $$PropertyImageTableTableReferences
                                        ._propertyIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PropertyImageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertyImageTableTable,
      PropertyImageTableData,
      $$PropertyImageTableTableFilterComposer,
      $$PropertyImageTableTableOrderingComposer,
      $$PropertyImageTableTableAnnotationComposer,
      $$PropertyImageTableTableCreateCompanionBuilder,
      $$PropertyImageTableTableUpdateCompanionBuilder,
      (PropertyImageTableData, $$PropertyImageTableTableReferences),
      PropertyImageTableData,
      PrefetchHooks Function({bool propertyId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PropertyTableTableTableManager get propertyTable =>
      $$PropertyTableTableTableManager(_db, _db.propertyTable);
  $$PropertyImageTableTableTableManager get propertyImageTable =>
      $$PropertyImageTableTableTableManager(_db, _db.propertyImageTable);
}
