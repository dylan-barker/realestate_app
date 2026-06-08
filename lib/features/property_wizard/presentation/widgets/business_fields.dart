import 'package:flutter/material.dart';

import '../../../../core/theme/themes.dart';
import '../../../../core/widgets/custom_text_input.dart';
import '../../data/models/owner.dart';

class BusinessFields extends StatelessWidget {
  final RealEstateTheme theme;
  final TextTheme textTheme;
  final Owner owner;
  final ValueChanged<Owner> onChanged;

  const BusinessFields({
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
        CustomTextInput(
          theme: theme,
          label: 'COMPANY NAME',
          placeholder: 'Acme Properties Pty Ltd',
          initialValue: owner.companyName,
          style: InputStyle.cardBorder,
          onChanged: (val) =>
              onChanged(owner.copyWith(companyName: val)),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          theme: theme,
          label: 'EMAIL ADDRESS',
          placeholder: 'info@acmeproperties.com',
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
          label: 'REGISTRATION NUMBER',
          placeholder: 'Optional',
          initialValue: owner.registrationNumber,
          onChanged: (val) =>
              onChanged(owner.copyWith(registrationNumber: val)),
        ),
      ],
    );
  }
}
