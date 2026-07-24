class ListingSummaryDto {
  final int id;
  final String referenceNumber;
  final String? p24Ref;
  final int propertyTypeId;
  final int? listingValuationId;
  final DateTime? listDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ListingSummaryDto({
    required this.id,
    required this.referenceNumber,
    this.p24Ref,
    required this.propertyTypeId,
    this.listingValuationId,
    this.listDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
