import 'package:flutter/material.dart';
import '../theme/themes.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete; // Shows clear/close icon on the right
  final bool isRequired;

  const CustomChip({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = RealEstateTheme.crimson();
    final isSelectedState = isSelected;

    Widget chipContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(
        horizontal: onDelete != null ? 12 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isSelectedState 
            ? theme.primaryColor 
            : (onDelete != null ? Colors.white : theme.borderLight.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isSelectedState 
              ? theme.primaryColor 
              : (onDelete != null ? theme.borderLight : Colors.transparent),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.toThemeData().textTheme.bodyMedium?.copyWith(
              color: isSelectedState 
                  ? Colors.white 
                  : (onDelete != null ? theme.textPrimary : theme.textPrimary.withOpacity(0.8)),
              fontWeight: isSelectedState || onDelete != null ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                size: 16,
                color: theme.textSecondary,
              ),
            ),
          ]
        ],
      ),
    );

    if (onTap != null && onDelete == null) {
      return GestureDetector(
        onTap: onTap,
        child: chipContent,
      );
    }

    return chipContent;
  }
}
