import '../../../domain/enums/lead_source.dart';
import '../../../domain/enums/mandate_type.dart';

class MandateContactsState {
  final MandateType? mandateType;
  final LeadSource? leadSource;
  final bool syncLightstone;
  final bool syncLoom;
  final String? ownerFirstName;
  final String? ownerLastName;
  final String? ownerEmail;
  final String? ownerPhone;
  final String? ownerIdNumber;
  final String? mandateStart;
  final String? mandateEnd;

  const MandateContactsState({
    this.mandateType,
    this.leadSource,
    this.syncLightstone = false,
    this.syncLoom = false,
    this.ownerFirstName,
    this.ownerLastName,
    this.ownerEmail,
    this.ownerPhone,
    this.ownerIdNumber,
    this.mandateStart,
    this.mandateEnd,
  });

  MandateContactsState copyWith({
    MandateType? mandateType,
    LeadSource? leadSource,
    bool? syncLightstone,
    bool? syncLoom,
    String? ownerFirstName,
    String? ownerLastName,
    String? ownerEmail,
    String? ownerPhone,
    String? ownerIdNumber,
    String? mandateStart,
    String? mandateEnd,
  }) {
    return MandateContactsState(
      mandateType: mandateType ?? this.mandateType,
      leadSource: leadSource ?? this.leadSource,
      syncLightstone: syncLightstone ?? this.syncLightstone,
      syncLoom: syncLoom ?? this.syncLoom,
      ownerFirstName: ownerFirstName ?? this.ownerFirstName,
      ownerLastName: ownerLastName ?? this.ownerLastName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerIdNumber: ownerIdNumber ?? this.ownerIdNumber,
      mandateStart: mandateStart ?? this.mandateStart,
      mandateEnd: mandateEnd ?? this.mandateEnd,
    );
  }

  @override
  List<Object?> get props => [
    mandateType,
    leadSource,
    syncLightstone,
    syncLoom,
    ownerFirstName,
    ownerLastName,
    ownerEmail,
    ownerPhone,
    ownerIdNumber,
    mandateStart,
    mandateEnd,
  ];
}
