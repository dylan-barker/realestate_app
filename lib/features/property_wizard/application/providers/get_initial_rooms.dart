import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/room.dart';
import 'property_provider.dart';

final getInitialRoomsProvider = FutureProvider<List<Room>>((ref) async {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getInitialRooms();
});
