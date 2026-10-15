class GeocodeResponseDto {
  const GeocodeResponseDto({
    required this.status,
    required this.totalCount,
    required this.addresses,
    this.errorMessage,
  });

  factory GeocodeResponseDto.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>?;

    return GeocodeResponseDto(
      status: json['status'] as String? ?? '',
      totalCount: (meta?['totalCount'] as num?)?.toInt() ?? 0,
      addresses: [
        for (final item in json['addresses'] as List<dynamic>? ?? const [])
          GeocodeAddressDto.fromJson(item as Map<String, dynamic>),
      ],
      errorMessage: json['errorMessage'] as String?,
    );
  }

  final String status;
  final int totalCount;
  final List<GeocodeAddressDto> addresses;
  final String? errorMessage;

  bool get isOk => status == 'OK';
}

class GeocodeAddressDto {
  const GeocodeAddressDto({
    required this.roadAddress,
    required this.jibunAddress,
    required this.addressElements,
    required this.x,
    required this.y,
  });

  factory GeocodeAddressDto.fromJson(Map<String, dynamic> json) {
    return GeocodeAddressDto(
      roadAddress: json['roadAddress'] as String? ?? '',
      jibunAddress: json['jibunAddress'] as String? ?? '',
      addressElements: [
        for (final item in json['addressElements'] as List<dynamic>? ?? const [])
          AddressElementDto.fromJson(item as Map<String, dynamic>),
      ],
      x: json['x'] as String? ?? '',
      y: json['y'] as String? ?? '',
    );
  }

  final String roadAddress;
  final String jibunAddress;
  final List<AddressElementDto> addressElements;
  final String x;
  final String y;
}

class AddressElementDto {
  const AddressElementDto({required this.types, required this.longName});

  factory AddressElementDto.fromJson(Map<String, dynamic> json) {
    final types = json['types'] ?? json['type'];

    return AddressElementDto(
      types: switch (types) {
        final List<dynamic> list => [for (final type in list) type as String],
        final String type => [type],
        _ => const [],
      },
      longName: json['longName'] as String? ?? '',
    );
  }

  final List<String> types;
  final String longName;
}
