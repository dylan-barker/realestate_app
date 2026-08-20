import 'package:flutter/widgets.dart';

/// Renders an image from a web-accessible URL (e.g. the blob URL produced by
/// `image_picker` on the web).
Widget localFileImage(
  String path, {
  BoxFit? fit,
  int? cacheWidth,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  return Image.network(
    path,
    fit: fit,
    cacheWidth: cacheWidth,
    errorBuilder: errorBuilder,
  );
}
