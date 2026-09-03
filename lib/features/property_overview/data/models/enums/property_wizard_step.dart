enum PropertyWizardStep {
  propertyType(1, 'Property Type', 'Property Details', '/wizard/property-type'),
  address(2, 'Address', 'Property Details', '/wizard/address'),
  buildingInfo(3, 'Building Info', 'Building Info', '/wizard/building-info'),
  propertyFeatures(4, 'Property Features', 'Property Details', '/wizard/property-features'),
  expenses(5, 'Expenses', 'Expenses', '/wizard/expenses'),
  ownerDetails(6, 'Owner Details', 'Owner Details', '/wizard/owner-details'),
  review(7, 'Review', 'Review & Submit', '/wizard/review');

  // Deprecated aliases
  static const valuationCosts = expenses;
  static const contacts = ownerDetails;

  final int stepNumber;
  final String title;
  final String headerTitle;
  final String routePath;

  const PropertyWizardStep(this.stepNumber, this.title, this.headerTitle, this.routePath);

  static PropertyWizardStep fromStepNumber(int n) {
    return values.firstWhere((s) => s.stepNumber == n);
  }

  static PropertyWizardStep fromRoutePath(String path) {
    return values.firstWhere((s) => s.routePath == path);
  }
}
