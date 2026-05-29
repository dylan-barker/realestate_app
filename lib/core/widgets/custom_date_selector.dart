import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/themes.dart';

class CustomDateSelector extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onDateSelected;

  const CustomDateSelector({
    super.key,
    required this.label,
    this.value,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final parsed = value != null ? DateTime.tryParse(value!) : null;
    final picked = await showDatePicker(
      context: context,
      initialDate: parsed ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFCC0000),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onDateSelected(DateFormat('dd MMM yyyy').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = RealEstateTheme.crimson();
    final textTheme = theme.toThemeData().textTheme;
    final isPlaceholder = value == null || value!.isEmpty;
    final displayValue = isPlaceholder ? 'Select Date' : value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: theme.textLabel,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.borderLight),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: isPlaceholder ? theme.textSecondary : theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  displayValue,
                  style: textTheme.bodyLarge?.copyWith(
                    color: isPlaceholder ? theme.textSecondary : theme.textPrimary,
                    fontWeight: isPlaceholder ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
