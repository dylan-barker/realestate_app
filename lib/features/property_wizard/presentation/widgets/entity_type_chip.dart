import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';

class EntityTypeChip extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const EntityTypeChip({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.1)
              : theme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? theme.primaryColor : theme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
