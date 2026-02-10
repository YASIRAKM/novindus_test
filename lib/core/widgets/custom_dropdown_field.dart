import 'package:flutter/material.dart';
import 'package:novindus_tets/core/constants/text_style_constants.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final String? hint;
  final bool showLabel;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.showLabel = true,
    this.validator,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel) Text(label, style: TextStyleConstants.labelStyle),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            validator: validator,
            isExpanded: true,
            menuMaxHeight: 300,
            style: TextStyleConstants.inputTextStyle,
            decoration: TextStyleConstants.inputDecoration(hint: hint),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
