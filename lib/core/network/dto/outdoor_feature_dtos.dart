class OutdoorFeatureDto {
  final int id;
  final int listingId;
  final String description;

  const OutdoorFeatureDto({
    required this.id,
    required this.listingId,
    required this.description,
  });

  factory OutdoorFeatureDto.fromJson(Map<String, dynamic> json) {
    return OutdoorFeatureDto(
      id: json['id'] as int,
      listingId: json['listingId'] as int,
      description: json['description'] as String,
    );
  }
}
