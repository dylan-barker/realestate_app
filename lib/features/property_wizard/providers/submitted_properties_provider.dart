import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/property_state.dart';

class SubmittedPropertiesNotifier extends Notifier<List<PropertyState>> {
  @override
  List<PropertyState> build() => [];

  void add(PropertyState property) {
    state = [...state, property];
  }

  void clear() {
    state = [];
  }
}

// TODO: Replace with persistent storage later
final submittedPropertiesProvider = NotifierProvider<
    SubmittedPropertiesNotifier, List<PropertyState>>(
  SubmittedPropertiesNotifier.new,
);
