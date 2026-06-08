import 'enums/entity_type.dart';

class Owner {
  final String id;
  final EntityType entityType;
  final String firstName;
  final String lastName;
  final String companyName;
  final String email;
  final String phone;
  final String idNumber;
  final String registrationNumber;

  const Owner({
    this.id = '',
    this.entityType = EntityType.person,
    this.firstName = '',
    this.lastName = '',
    this.companyName = '',
    this.email = '',
    this.phone = '',
    this.idNumber = '',
    this.registrationNumber = '',
  });

  Owner copyWith({
    String? id,
    EntityType? entityType,
    String? firstName,
    String? lastName,
    String? companyName,
    String? email,
    String? phone,
    String? idNumber,
    String? registrationNumber,
  }) {
    return Owner(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      idNumber: idNumber ?? this.idNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
    );
  }

  String get displayName {
    if (entityType == EntityType.business) {
      return companyName;
    }
    return '$firstName $lastName';
  }

  String get displayIdNumber {
    if (entityType == EntityType.business) {
      return registrationNumber;
    }
    return idNumber;
  }
}
