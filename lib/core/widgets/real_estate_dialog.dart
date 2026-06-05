import 'package:flutter/material.dart';

import '../theme/themes.dart';

Future<T?> showRealEstateDialog<T>({
  required BuildContext context,
  required String title,
  Widget? content,
  List<Widget>? actions,
}) {
  final theme = RealEstateTheme.crimson();
  final textTheme = theme.toThemeData().textTheme;

  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          title,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: content,
        actions: actions,
      );
    },
  );
}

Widget dialogCancelButton({
  required BuildContext context,
  required RealEstateTheme theme,
  VoidCallback? onPressed,
  String text = 'Cancel',
}) {
  return TextButton(
    onPressed: onPressed ?? () => Navigator.of(context).pop(),
    child: Text(text, style: TextStyle(color: theme.textSecondary)),
  );
}

Widget dialogActionButton({
  required RealEstateTheme theme,
  required String text,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white)),
  );
}

void showRealEstateBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: builder,
  );
}
