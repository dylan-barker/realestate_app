class OutdoorExtraItem {
  final String name;
  final int quantity;

  OutdoorExtraItem({
    required this.name,
    this.quantity = 1,
  });

  OutdoorExtraItem copyWith({
    String? name,
    int? quantity,
  }) {
    return OutdoorExtraItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
    );
  }
}
