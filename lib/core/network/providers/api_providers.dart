import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_client.dart';
import '../services/auth_api_service.dart';
import '../services/lookup_api_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApiService(client);
});

final lookupApiServiceProvider = Provider<LookupApiService>((ref) {
  final client = ref.watch(apiClientProvider);
  return LookupApiService(client);
});
