import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/wizard_scaffold.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../data/models/enums/room_category.dart';
import '../../data/models/room.dart';
import '../../providers/property_provider.dart';
import '../widgets/add_outdoor_dialog.dart';
import '../widgets/outdoor_subcategory.dart';
import '../widgets/room_section.dart';
import '../widgets/wizard_actions.dart';

class PropertyFeaturesStep extends ConsumerWidget {
  const PropertyFeaturesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;

    final categories = RoomCategory.values;

    Map<RoomCategory, List<Room>> groupedRooms = {
      for (var cat in categories) cat: [],
    };
    for (var room in state.rooms) {
      if (groupedRooms.containsKey(room.type)) {
        groupedRooms[room.type]!.add(room);
      }
    }

    final outdoorCategories = OutdoorExtraCategory.values;

    return WizardScaffold(
      title: 'Property Features',
      description:
          'Detail and configure every room in the residence.',
      onBack: () => goBackWizard(context, ref),
      onNext: () => advanceWizard(context, ref),
      children: [
        Text(
          'ROOMS',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textLabel,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        for (var category in categories) ...[
          RoomSection(
            theme: theme,
            textTheme: textTheme,
            category: category,
            rooms: groupedRooms[category]!,
            viewModel: viewModel,
            onRoomTap: (roomId) => context.push('/wizard/room-details/$roomId'),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 20),
        Container(height: 1, color: theme.borderLight),
        const SizedBox(height: 20),
        Text(
          'OUTDOOR & EXTRAS',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textLabel,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        for (var outdoorCat in outdoorCategories) ...[
          OutdoorSubcategory(
            theme: theme,
            textTheme: textTheme,
            outdoorCat: outdoorCat,
            selectedItems: state.outdoorExtras,
            viewModel: viewModel,
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => AddOutdoorDialog.show(
              context,
              viewModel,
              theme,
              textTheme,
            ),
            icon: const Icon(Icons.add_circle_outline, size: 22),
            label: const Text('Add Custom Outdoor / Extra Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: theme.textLabel,
              elevation: 0,
              side: BorderSide(color: theme.borderLight, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
