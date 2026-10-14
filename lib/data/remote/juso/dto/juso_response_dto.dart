class JusoResponseDto {
  const JusoResponseDto({
    required this.errorCode,
    required this.errorMessage,
    required this.totalCount,
    required this.addresses,
  });

  factory JusoResponseDto.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>? ?? const {};
    final common = results['common'] as Map<String, dynamic>? ?? const {};
    return JusoResponseDto(
      errorCode: '${common['errorCode'] ?? ''}',
      errorMessage: '${common['errorMessage'] ?? ''}',
      totalCount: int.tryParse('${common['totalCount'] ?? ''}') ?? 0,
      addresses: [
        for (final item in results['juso'] as List<dynamic>? ?? const [])
          JusoAddressDto.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  final String errorCode;
  final String errorMessage;
  final int totalCount;
  final List<JusoAddressDto> addresses;

  bool get isOk => errorCode == '0';
}

class JusoAddressDto {
  const JusoAddressDto({
    required this.roadAddr,
    required this.roadAddrPart1,
    required this.jibunAddr,
    required this.zipNo,
    required this.siNm,
    required this.sggNm,
    required this.emdNm,
    required this.bdNm,
  });

  factory JusoAddressDto.fromJson(Map<String, dynamic> json) {
    String read(String key) => '${json[key] ?? ''}';
    return JusoAddressDto(
      roadAddr: read('roadAddr'),
      roadAddrPart1: read('roadAddrPart1'),
      jibunAddr: read('jibunAddr'),
      zipNo: read('zipNo'),
      siNm: read('siNm'),
      sggNm: read('sggNm'),
      emdNm: read('emdNm'),
      bdNm: read('bdNm'),
    );
  }

  final String roadAddr;
  final String roadAddrPart1;
  final String jibunAddr;
  final String zipNo;
  final String siNm;
  final String sggNm;
  final String emdNm;
  final String bdNm;
}
