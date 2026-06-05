import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../data/models/enums/standard_amenity.dart';
import '../../data/models/room.dart';
import '../../providers/property_provider.dart';

class RoomDetailsStep extends ConsumerWidget {
  final String roomId;

  const RoomDetailsStep({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyViewModelProvider);
    final viewModel = ref.read(propertyViewModelProvider.notifier);
    final theme = ref.watch(themeProvider);
    final textTheme = theme.toThemeData().textTheme;

    final room = state.rooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => state.rooms.first,
    );

    final ratings = [
      {
        'level': 1,
        'emoji': '\u{1F635}',
        'label': 'LEVEL 1\nTo be\nrenovated',
        'range': '0\u201324%',
      },
      {
        'level': 2,
        'emoji': '\u{1F610}',
        'label': 'LEVEL 2\nTo be\nrenovated',
        'range': '25\u201349%',
      },
      {
        'level': 3,
        'emoji': '\u{1F642}',
        'label': 'LEVEL 3\nOptional\nrenovation',
        'range': '50\u201374%',
      },
      {
        'level': 4,
        'emoji': '\u{1F600}',
        'label': 'LEVEL 4\nPerfect\ncondition',
        'range': '75\u2013100%',
      },
    ];

    final amenityCategories = AmenityCategory.values;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.textPrimary,
            size: 20,
          ),
          onPressed: () {
            viewModel.selectRoomForEditing(null);
            context.pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Property Details',
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
                Text(
                  'K',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: theme.textPrimary,
                  ),
                ),
                Text(
                  'W',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: theme.primaryColor,
                  ),
                ),
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
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 24.0,
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ROOM IDENTITY',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textLabel,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              CustomCard(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: theme.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => _showRenameDialog(
                        context,
                        viewModel,
                        room.id,
                        room.name,
                        theme,
                        textTheme,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildRoomGraphic(context, theme, textTheme, room, viewModel),
              const SizedBox(height: 28),
              Text(
                'Room Condition Rating',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rate the current state of the space.',
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: ratings.map((rating) {
                  final level = rating['level'] as int;
                  final emoji = rating['emoji'] as String;
                  final label = rating['label'] as String;
                  final range = rating['range'] as String;
                  final isSelected = room.conditionRating == level;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomCard(
                        isSelected: isSelected,
                        onTap: () => viewModel.updateRoomDetails(
                          roomId: room.id,
                          conditionRating: level,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 10),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium?.copyWith(
                                fontSize: 9,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? theme.primaryColor
                                    : theme.textSecondary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              range,
                              style: textTheme.labelLarge?.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? theme.primaryColor
                                    : theme.textSecondary.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _RatingSlider(
                conditionRating: room.conditionRating,
                theme: theme,
                textTheme: textTheme,
                onChanged: (level) {
                  viewModel.updateRoomDetails(
                    roomId: room.id,
                    conditionRating: level,
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(height: 1, color: theme.borderLight),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features & Amenities',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Select all that apply to this space.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'REQUIRED',
                      style: textTheme.labelMedium?.copyWith(
                        color: const Color(0xFFEF4444),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (room.features.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: room.features.length,
                  itemBuilder: (context, index) {
                    final feature = room.features[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: CustomChip(
                        label: feature,
                        onDelete: () =>
                            viewModel.removeFeatureFromRoom(room.id, feature),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddFeatureDialog(
                    context, viewModel, room.id, theme, textTheme,
                  ),
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text('ADD CUSTOM FEATURE'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(
                      color: theme.primaryColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              for (var cat in amenityCategories) ...[
                _buildAmenityCategory(theme, textTheme, cat, room, viewModel),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
              Container(height: 1, color: theme.borderLight),
              const SizedBox(height: 20),
              Text(
                'ROOM NOTES',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textLabel,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              CustomCard(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: theme.textLabel,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ROOM NOTES',
                          style: textTheme.labelLarge?.copyWith(
                            color: theme.textLabel,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: room.notes,
                      maxLines: 4,
                      onChanged: (val) => viewModel.updateRoomDetails(
                        roomId: room.id,
                        notes: val,
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        color: theme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Add specific details about the condition or layout of this room...',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: theme.textSecondary.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Save & Return to Features',
                fullWidth: true,
                onTap: () {
                  viewModel.selectRoomForEditing(null);
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityCategory(
    RealEstateTheme theme,
    TextTheme textTheme,
    AmenityCategory cat,
    Room room,
    PropertyViewModel viewModel,
  ) {
    final amenitiesInCategory = StandardAmenity.values
        .where((a) => a.category == cat)
        .toList();

    final suggestedInCategory = amenitiesInCategory
        .where((a) => !room.features.contains(a.displayString))
        .toList();

    if (suggestedInCategory.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cat.displayString.toUpperCase(),
          style: textTheme.labelLarge?.copyWith(
            color: theme.textSecondary,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: suggestedInCategory.map((amenity) {
            return InkWell(
              onTap: () =>
                  viewModel.addFeatureToRoom(room.id, amenity.displayString),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.borderLight),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 12, color: theme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      amenity.displayString,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoomGraphic(
    BuildContext context,
    RealEstateTheme theme,
    TextTheme textTheme,
    Room room,
    PropertyViewModel viewModel,
  ) {
    final hasImage = room.imagePath != null;

    return GestureDetector(
      onTap: () => _showImagePickerOptions(
        context,
        viewModel,
        room.id,
        theme,
        textTheme,
      ),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: !hasImage ? const Color(0xFFE5E7EB) : null,
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                Image.file(
                  File(room.imagePath!),
                  fit: BoxFit.cover,
                  cacheWidth: 800,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE5E7EB),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to retry',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!hasImage)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Tap to add room photo',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePickerOptions(
    BuildContext context,
    PropertyViewModel viewModel,
    String roomId,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, 'camera'),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, 'gallery'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null) return;

    final ImageSource source = result == 'camera'
        ? ImageSource.camera
        : ImageSource.gallery;
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked != null) {
      viewModel.updateRoomDetails(roomId: roomId, imagePath: picked.path);
    }
  }

  void _showRenameDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    String roomId,
    String currentName,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String name = currentName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Rename Room',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: 'Room Name',
                placeholder: 'e.g. Master Bedroom Suite',
                initialValue: currentName,
                onChanged: (val) => name = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.trim().isNotEmpty) {
                  viewModel.renameRoom(roomId, name.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddFeatureDialog(
    BuildContext context,
    PropertyViewModel viewModel,
    String roomId,
    RealEstateTheme theme,
    TextTheme textTheme,
  ) {
    String feature = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Add Amenity / Feature',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: 'Feature Name',
                placeholder: 'e.g. USB Outlets, Underfloor Heating',
                onChanged: (val) => feature = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (feature.trim().isNotEmpty) {
                  viewModel.addFeatureToRoom(roomId, feature.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class _RatingSlider extends StatefulWidget {
  final int? conditionRating;
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final ValueChanged<int> onChanged;

  const _RatingSlider({
    required this.conditionRating,
    required this.theme,
    required this.textTheme,
    required this.onChanged,
  });

  @override
  State<_RatingSlider> createState() => _RatingSliderState();
}

class _RatingSliderState extends State<_RatingSlider> {
  double _dragValue = 0;
  bool _fromSelfChange = false;

  @override
  void initState() {
    super.initState();
    _dragValue = _levelToMidpoint(widget.conditionRating ?? 1);
  }

  @override
  void didUpdateWidget(_RatingSlider old) {
    super.didUpdateWidget(old);
    if (widget.conditionRating != old.conditionRating) {
      if (!_fromSelfChange) {
        _dragValue = _levelToMidpoint(widget.conditionRating ?? 1);
      }
      _fromSelfChange = false;
    }
  }

  static double _levelToMidpoint(int? level) {
    switch (level) {
      case 1: return 12;
      case 2: return 37;
      case 3: return 62;
      case 4: return 87;
      default: return 0;
    }
  }

  static int _valueToLevel(double value) {
    if (value < 25) return 1;
    if (value < 50) return 2;
    if (value < 75) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final activeLevel = _valueToLevel(_dragValue);
    final displayValue = _dragValue;

    final segments = [
      {'range': '0\u201324%', 'level': 1},
      {'range': '25\u201349%', 'level': 2},
      {'range': '50\u201374%', 'level': 3},
      {'range': '75\u2013100%', 'level': 4},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final pixelsPerPercent = barWidth / 100;
            setState(() {
              _dragValue = (_dragValue +
                      details.delta.dx / pixelsPerPercent)
                  .clamp(0.0, 100.0);
            });
          },
          onHorizontalDragEnd: (_) {
            if (_valueToLevel(_dragValue) != widget.conditionRating) {
              _fromSelfChange = true;
              widget.onChanged(_valueToLevel(_dragValue));
            } else {
              setState(() {});
            }
          },
          onTapUp: (details) {
            final tapPercent = (details.localPosition.dx / barWidth) * 100;
            _dragValue = tapPercent;
            _fromSelfChange = true;
            widget.onChanged(_valueToLevel(tapPercent));
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: widget.theme.borderLight),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Stack(
                children: [
                  Row(
                    children: List.generate(4, (i) {
                      final lvl = i + 1;
                  final isActive = lvl == activeLevel;
                          return Expanded(
                            child: Container(
                              color: isActive
                                  ? widget.theme.primaryColor.withOpacity(0.12)
                                  : Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    segments[i]['range'] as String,
                                    style: widget.textTheme.labelLarge?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? widget.theme.primaryColor
                                          : widget.theme.textSecondary
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      Positioned(
                        left: ((displayValue / 100) * barWidth - 14).clamp(0.0, barWidth - 28),
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: widget.theme.primaryColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${displayValue.round()}%',
                              style: widget.textTheme.labelLarge?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
