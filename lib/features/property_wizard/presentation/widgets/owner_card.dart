import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../data/models/enums/entity_type.dart';
import '../../data/models/owner.dart';
import 'business_fields.dart';
import 'entity_type_chip.dart';
import 'person_fields.dart';

class OwnerCard extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final Owner owner;
  final String label;
  final bool showRemove;
  final ValueChanged<Owner> onChanged;
  final VoidCallback? onRemove;

  const OwnerCard({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.owner,
    required this.label,
    required this.showRemove,
    required this.onChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: theme.textLabel,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showRemove)
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: EntityTypeChip(
                  theme: theme,
                  textTheme: textTheme,
                  label: 'Person',
                  isSelected: owner.entityType == EntityType.person,
                  onTap: () => onChanged(owner.copyWith(
                    entityType: EntityType.person,
                    firstName: '',
                    lastName: '',
                    companyName: '',
                    idNumber: '',
                    registrationNumber: '',
                  )),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: EntityTypeChip(
                  theme: theme,
                  textTheme: textTheme,
                  label: 'Business',
                  isSelected: owner.entityType == EntityType.business,
                  onTap: () => onChanged(owner.copyWith(
                    entityType: EntityType.business,
                    firstName: '',
                    lastName: '',
                    companyName: '',
                    idNumber: '',
                    registrationNumber: '',
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (owner.entityType == EntityType.person)
            PersonFields(
              theme: theme,
              textTheme: textTheme,
              owner: owner,
              onChanged: onChanged,
            )
          else
            BusinessFields(
              theme: theme,
              textTheme: textTheme,
              owner: owner,
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}
