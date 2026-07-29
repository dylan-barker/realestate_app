import 'package:flutter/material.dart';

import '../theme/themes.dart';

class FeatureListWidget extends StatelessWidget {
  final List<String> selectedFeatures;
  final List<String> availableDefaults;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  final String categoryLabel;
  final RealEstateTheme theme;
  final TextTheme textTheme;

  const FeatureListWidget({
    super.key,
    required this.selectedFeatures,
    required this.availableDefaults,
    required this.onAdd,
    required this.onRemove,
    required this.categoryLabel,
    required this.theme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedFeatures.isEmpty) {
      return _buildEmpty(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...selectedFeatures.map(
          (f) => _SelectedFeatureRow(
            name: f,
            onRemove: () => onRemove(f),
            theme: theme,
            textTheme: textTheme,
          ),
        ),
        _buildAddButton(context),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'None selected',
            style: textTheme.bodyMedium?.copyWith(
              color: theme.textSecondary.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        _buildAddButton(context),
      ],
    );
  }

  Widget _buildAddButton(BuildContext? context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            if (context != null) _showAddSheet(context);
          },
          icon: const Icon(Icons.add, size: 20),
          label: Text('Add $categoryLabel Feature'),
          style: OutlinedButton.styleFrom(
            backgroundColor: theme.cardBackgroundColor,
            foregroundColor: theme.primaryColor,
            side: BorderSide(
              color: theme.primaryColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FeaturePickerSheet(
        availableDefaults: availableDefaults
            .where((d) => !selectedFeatures.contains(d))
            .toList(),
        onAdd: (f) {
          onAdd(f);
          Navigator.pop(context);
        },
        categoryLabel: categoryLabel,
        theme: theme,
        textTheme: textTheme,
      ),
    );
  }
}

class _SelectedFeatureRow extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;
  final RealEstateTheme theme;
  final TextTheme textTheme;

  const _SelectedFeatureRow({
    required this.name,
    required this.onRemove,
    required this.theme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 18, color: theme.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: textTheme.bodyLarge?.copyWith(
                color: theme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: theme.textSecondary),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

class _FeaturePickerSheet extends StatefulWidget {
  final List<String> availableDefaults;
  final ValueChanged<String> onAdd;
  final String categoryLabel;
  final RealEstateTheme theme;
  final TextTheme textTheme;

  const _FeaturePickerSheet({
    required this.availableDefaults,
    required this.onAdd,
    required this.categoryLabel,
    required this.theme,
    required this.textTheme,
  });

  @override
  State<_FeaturePickerSheet> createState() => _FeaturePickerSheetState();
}

class _FeaturePickerSheetState extends State<_FeaturePickerSheet> {
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Add ${widget.categoryLabel} Feature',
            style: widget.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: widget.theme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _customController,
            style: widget.textTheme.bodyLarge?.copyWith(
              color: widget.theme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Type a custom feature name',
              hintStyle: widget.textTheme.bodyMedium?.copyWith(
                color: widget.theme.textSecondary.withValues(alpha: 0.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.add_circle, color: widget.theme.primaryColor),
                onPressed: _submitCustom,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.theme.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.theme.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.theme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitCustom(),
          ),
          if (widget.availableDefaults.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Available ${widget.categoryLabel} Features',
              style: widget.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.theme.textPrimary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availableDefaults.length,
                itemBuilder: (ctx, i) {
                  final f = widget.availableDefaults[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    dense: true,
                    title: Text(
                      f,
                      style: widget.textTheme.bodyLarge?.copyWith(
                        color: widget.theme.textPrimary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.add_circle_outline,
                      color: widget.theme.primaryColor,
                    ),
                    onTap: () => widget.onAdd(f),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _submitCustom() {
    final text = _customController.text.trim();
    if (text.isNotEmpty) {
      widget.onAdd(text);
      _customController.clear();
    }
  }
}
