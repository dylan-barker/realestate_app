import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../providers/property_provider.dart';

class OutdoorChip extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final String label;
  final bool isSelected;
  final int quantity;
  final PropertyViewModel viewModel;

  const OutdoorChip({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.label,
    required this.isSelected,
    required this.quantity,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? theme.primaryColor : theme.borderLight,
        ),
      ),
      child: isSelected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => viewModel.decrementOutdoorQuantity(label),
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  quantity > 1 ? '$label x$quantity' : label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => viewModel.incrementOutdoorQuantity(label),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => viewModel.removeOutdoorExtra(label),
                  child: Icon(Icons.close, size: 14, color: Colors.white70),
                ),
              ],
            )
          : GestureDetector(
              onTap: () => viewModel.addOutdoorExtra(label),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 14, color: theme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
