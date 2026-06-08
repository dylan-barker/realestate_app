import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';

class IntegrationTile extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final String title;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const IntegrationTile({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.title,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderLight),
      ),
      child: Theme(
        data: ThemeData(unselectedWidgetColor: theme.borderLight),
        child: CheckboxListTile(
          value: isChecked,
          onChanged: onChanged,
          activeColor: theme.primaryColor,
          checkColor: Colors.white,
          title: Text(
            title,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.textPrimary,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
