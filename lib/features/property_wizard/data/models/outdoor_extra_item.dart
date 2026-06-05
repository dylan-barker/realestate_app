import 'enums/outdoor_extra.dart';

class OutdoorExtraItem {
  final String name;
  final int quantity;
  final OutdoorExtraCategory? category;

  OutdoorExtraItem({
    required this.name,
    this.quantity = 1,
    this.category,
  });

  OutdoorExtraItem copyWith({
    String? name,
    int? quantity,
    OutdoorExtraCategory? category,
  }) {
    return OutdoorExtraItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
}
