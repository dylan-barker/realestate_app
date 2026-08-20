/// `dart:io` exceptions never surface on the web.
bool isIoNetworkError(Object? error) => false;
