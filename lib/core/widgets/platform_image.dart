import 'package:flutter/widgets.dart';

import 'platform_image_io.dart'
    if (dart.library.html) 'platform_image_web.dart'
    as platform;

/// Renders an image stored at a local file path. The web variant renders the
/// blob URL produced by `image_picker` via [Image.network], since `dart:io`'s
/// [File] does not exist there.
Widget localFileImage(
  String path, {
  BoxFit? fit,
  int? cacheWidth,
  ImageErrorWidgetBuilder? errorBuilder,
}) => platform.localFileImage(
  path,
  fit: fit,
  cacheWidth: cacheWidth,
  errorBuilder: errorBuilder,
);
