import '../data/models/enums/lead_source.dart';
import '../data/models/enums/mandate_type.dart';
import '../data/models/owner.dart';
import '../data/models/property_state.dart';

extension MandateContactsActions on PropertyState {
  PropertyState withMandateType(MandateType type) =>
      copyWith(mandateType: type);

  PropertyState withLeadSource(LeadSource source) =>
      copyWith(leadSource: source);

  PropertyState withSyncLightstone(bool value) =>
      copyWith(syncLightstone: value);

  PropertyState withSyncLoom(bool value) => copyWith(syncLoom: value);

  PropertyState withPrimaryOwner(Owner owner) =>
      copyWith(primaryOwner: owner);

  PropertyState withAddedCoOwner() {
    final newOwner = Owner(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return copyWith(coOwners: [...coOwners, newOwner]);
  }

  PropertyState withUpdatedCoOwner(int index, Owner owner) {
    final updated = List<Owner>.from(coOwners);
    if (index >= 0 && index < updated.length) {
      updated[index] = owner;
      return copyWith(coOwners: updated);
    }
    return this;
  }

  PropertyState withRemovedCoOwner(String id) =>
      copyWith(coOwners: coOwners.where((o) => o.id != id).toList());

  PropertyState withMandateDates({String? start, String? end}) =>
      copyWith(
        mandateStart: start ?? mandateStart,
        mandateEnd: end ?? mandateEnd,
      );
}
