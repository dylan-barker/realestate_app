import 'network_error_check_io.dart'
    if (dart.library.html) 'network_error_check_web.dart'
    as platform;

/// Returns true when [error] is one of the `dart:io` network exceptions
/// ([SocketException], [HandshakeException]). Always false on the web, where
/// those types do not exist.
bool isIoNetworkError(Object? error) => platform.isIoNetworkError(error);
