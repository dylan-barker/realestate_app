import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../data/models/owner.dart';

class PersonFields extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final Owner owner;
  final ValueChanged<Owner> onChanged;

  const PersonFields({
    super.key,
    required this.theme,
    required this.textTheme,
    required this.owner,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextInput(
                theme: theme,
                label: 'FIRST NAME',
                placeholder: 'John',
                initialValue: owner.firstName,
                style: InputStyle.cardBorder,
                onChanged: (val) =>
                    onChanged(owner.copyWith(firstName: val)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextInput(
                theme: theme,
                label: 'LAST NAME',
                placeholder: 'Doe',
                initialValue: owner.lastName,
                style: InputStyle.cardBorder,
                onChanged: (val) =>
                    onChanged(owner.copyWith(lastName: val)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'EMAIL ADDRESS',
          placeholder: 'john.doe@example.com',
          initialValue: owner.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => onChanged(owner.copyWith(email: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'PHONE NUMBER',
          placeholder: '+27 82 000 0000',
          initialValue: owner.phone,
          keyboardType: TextInputType.phone,
          onChanged: (val) => onChanged(owner.copyWith(phone: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'ID NUMBER',
          placeholder: 'Optional',
          initialValue: owner.idNumber,
          onChanged: (val) => onChanged(owner.copyWith(idNumber: val)),
        ),
      ],
    );
  }
}
