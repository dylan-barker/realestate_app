import 'dart:io' show SocketException, HandshakeException, HttpException;

/// Returns true when [error] is a `dart:io` network exception.
bool isIoNetworkError(Object? error) =>
    error is SocketException ||
    error is HandshakeException ||
    error is HttpException;
