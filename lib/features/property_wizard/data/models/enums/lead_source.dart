enum LeadSource {
  referral,
  website,
  walkIn,
  socialMedia,
  other,
}

extension LeadSourceExtension on LeadSource {
  String get displayString {
    switch (this) {
      case LeadSource.referral:
        return 'Referral';
      case LeadSource.website:
        return 'Website';
      case LeadSource.walkIn:
        return 'Walk-in';
      case LeadSource.socialMedia:
        return 'Social Media';
      case LeadSource.other:
        return 'Other';
    }
  }

  static LeadSource fromString(String val) {
    switch (val.trim().toLowerCase()) {
      case 'website':
        return LeadSource.website;
      case 'walk-in':
      case 'walkin':
        return LeadSource.walkIn;
      case 'social media':
      case 'socialmedia':
        return LeadSource.socialMedia;
      case 'other':
        return LeadSource.other;
      case 'referral':
      default:
        return LeadSource.referral;
    }
  }
}
