import 'dart:io' show File;

import 'package:flutter/widgets.dart';

/// Renders an image from a local filesystem path.
Widget localFileImage(
  String path, {
  BoxFit? fit,
  int? cacheWidth,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  return Image.file(
    File(path),
    fit: fit,
    cacheWidth: cacheWidth,
    errorBuilder: errorBuilder,
  );
}
