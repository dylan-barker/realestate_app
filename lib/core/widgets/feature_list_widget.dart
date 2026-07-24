import 'package:flutter/material.dart';

import '../theme/themes.dart';

class FeatureListWidget extends StatelessWidget {
  final List<String> allAvailable;
  final List<String> selectedFeatures;
  final Set<String> hiddenFeatures;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onHide;
  final VoidCallback? onAddCustom;
  final RealEstateTheme theme;
  final TextTheme textTheme;

  const FeatureListWidget({
    super.key,
    required this.allAvailable,
    required this.selectedFeatures,
    required this.hiddenFeatures,
    required this.onToggle,
    required this.onHide,
    this.onAddCustom,
    required this.theme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final visibleFeatures = allAvailable
        .where((f) => !hiddenFeatures.contains(f))
        .toList();
    final customFeatures = selectedFeatures
        .where((f) => !allAvailable.contains(f))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleFeatures.map(
          (f) => _FeatureRow(
            name: f,
            isSelected: selectedFeatures.contains(f),
            showSwitch: true,
            onToggle: () => onToggle(f),
            onHide: () => onHide(f),
            theme: theme,
            textTheme: textTheme,
          ),
        ),
        if (customFeatures.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Custom',
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...customFeatures.map(
            (f) => _FeatureRow(
              name: f,
              isSelected: true,
              showSwitch: false,
              onHide: () => onHide(f),
              theme: theme,
              textTheme: textTheme,
            ),
          ),
        ],
        if (onAddCustom != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAddCustom,
              icon: const Icon(Icons.add, size: 22),
              label: const Text('ADD CUSTOM FEATURE'),
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.cardBackgroundColor,
                foregroundColor: theme.primaryColor,
                side: BorderSide(
                  color: theme.primaryColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool showSwitch;
  final VoidCallback? onToggle;
  final VoidCallback onHide;
  final RealEstateTheme theme;
  final TextTheme textTheme;

  const _FeatureRow({
    required this.name,
    required this.isSelected,
    required this.showSwitch,
    this.onToggle,
    required this.onHide,
    required this.theme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: textTheme.bodyLarge?.copyWith(
                color: isSelected || !showSwitch
                    ? theme.textPrimary
                    : theme.textSecondary.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (showSwitch)
            Switch(
              value: isSelected,
              onChanged: (_) => onToggle?.call(),
              activeThumbColor: theme.primaryColor,
            ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: theme.textSecondary),
            onPressed: onHide,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
