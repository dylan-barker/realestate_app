import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../widgets/wizard_footer.dart';
import '../../data/models/room.dart';
import '../../data/models/enums/outdoor_extra.dart';
import '../../data/models/enums/property_wizard_step.dart';
import '../../data/models/enums/room_category.dart';
import '../../application/providers/property_provider.dart';
import '../../application/providers/wizard_navigation_provider.dart';

class PropertyFeaturesStep extends ConsumerWidget {
  const PropertyFeaturesStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;
    final navData = ref.watch(wizardNavigationProvider);

    final categories = RoomCategory.values;

    Map<RoomCategory, List<Room>> groupedRooms = {
      for (var cat in categories) cat: [],
    };
    for (var room in state.rooms) {
      if (groupedRooms.containsKey(room.type)) {
        groupedRooms[room.type]!.add(room);
      }
    }

    final outdoorOptions = OutdoorExtra.values.map((e) => e.displayString).toList();

    final allOutdoorOptions = Set<String>.from(outdoorOptions)
      ..addAll(state.outdoorExtras);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.textPrimary, size: 20),
          onPressed: () {
            viewModel.prevStep();
            context.pop();
          },
        ),
        centerTitle: true,
        title: Text(
          navData.headerTitle,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('K', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 22, color: theme.textPrimary)),
                Text('W', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 22, color: theme.primaryColor)),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: theme.borderLight, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    navData.progressLabel.toUpperCase(),
                    style: textTheme.labelLarge?.copyWith(
                      color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Property Features',
                    style: textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Detail and configure every room in the residence.',
                    style: textTheme.bodyMedium?.copyWith(color: theme.textSecondary.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 28),
                  for (var category in categories) ...[
                    Text(
                      category.displayString.toUpperCase(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: theme.textLabel, fontSize: 13, letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedRooms[category]!.length,
                      itemBuilder: (context, idx) {
                        final room = groupedRooms[category]![idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: CustomCard(
                            onTap: () {
                              viewModel.selectRoomForEditing(room.id);
                              context.push('/wizard/room-details/${room.id}');
                            },
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room.name,
                                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.textPrimary),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        Text(room.description, style: textTheme.bodyMedium?.copyWith(color: theme.textSecondary)),
                                        const SizedBox(width: 6),
                                        Text('•', style: TextStyle(color: theme.textSecondary.withOpacity(0.5))),
                                        const SizedBox(width: 6),
                                        Text(
                                          room.isComplete ? 'COMPLETE' : 'PENDING',
                                          style: textTheme.labelLarge?.copyWith(
                                            color: room.isComplete ? theme.completeColor : theme.pendingColor,
                                            fontSize: 10, fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 14, color: theme.textSecondary.withOpacity(0.5)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                  ],
                  CustomCard(
                    hasDashedBorder: true,
                    backgroundColor: theme.backgroundColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    onTap: () => _showAddRoomDialog(context, viewModel, theme, textTheme),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 20, color: theme.textLabel),
                          const SizedBox(width: 8),
                          Text('Add Room', style: textTheme.bodyLarge?.copyWith(color: theme.textLabel, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'OUTDOOR & EXTRAS',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: theme.textLabel, fontSize: 13, letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0, runSpacing: 10.0,
                    children: allOutdoorOptions.map((opt) {
                      final isSelected = state.outdoorExtras.contains(opt);
                      return CustomChip(label: opt, isSelected: isSelected, onTap: () => viewModel.toggleOutdoorExtra(opt));
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  CustomCard(
                    hasDashedBorder: true,
                    backgroundColor: theme.backgroundColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    onTap: () => _showAddOutdoorDialog(context, viewModel, theme, textTheme),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 20, color: theme.textLabel),
                          const SizedBox(width: 8),
                          Text('Add Outdoor/Extra Item', style: textTheme.bodyLarge?.copyWith(color: theme.textLabel, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar: WizardFooter(
        onNext: () {
          viewModel.nextStep();
          context.push(PropertyWizardStep.mandateContacts.routePath);
        },
        onBack: () {
          viewModel.prevStep();
          context.pop();
        },
      ),
    );
  }

  void _showAddRoomDialog(BuildContext context, PropertyViewModel viewModel, RealEstateTheme theme, TextTheme textTheme) {
    String name = '';
    RoomCategory category = RoomCategory.bedrooms;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Custom Room', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<RoomCategory>(
                    value: category,
                    decoration: InputDecoration(
                      labelText: 'Room Category',
                      labelStyle: textTheme.labelLarge?.copyWith(color: theme.textLabel),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: theme.borderLight)),
                    ),
                    items: RoomCategory.values.map((cat) => DropdownMenuItem(value: cat, child: Text(cat.displayString))).toList(),
                    onChanged: (val) { if (val != null) setState(() => category = val); },
                  ),
                  const SizedBox(height: 16),
                  CustomTextInput(label: 'Room Name', placeholder: 'e.g. Guest Bedroom 2, Study Office', onChanged: (val) => name = val),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: theme.textSecondary)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (name.trim().isNotEmpty) {
                            viewModel.addCustomRoom(name.trim(), category);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Add', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddOutdoorDialog(BuildContext context, PropertyViewModel viewModel, RealEstateTheme theme, TextTheme textTheme) {
    String name = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text('Add Outdoor/Extra Item', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            CustomTextInput(label: 'Item Name', placeholder: 'e.g. Tennis Court, Lapa', onChanged: (val) => name = val),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: theme.textSecondary))),
            ElevatedButton(
              onPressed: () {
                if (name.trim().isNotEmpty) {
                  viewModel.addCustomOutdoorExtra(name.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
