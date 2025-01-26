import 'package:flutter/material.dart';

class ThanaSelector extends StatelessWidget {
  final String? selectedThana;
  final ValueChanged<String?> onChanged;

  const ThanaSelector({
    Key? key,
    required this.selectedThana,
    required this.onChanged,
  }) : super(key: key);

  static const List<String> thanas = [
    'Ramna Model Thana',
    'Motijheel Thana',
    'Kotwali Thana',
    'Dhanmondi Thana',
    'Mohammadpur Thana',
    'Sutrapur Thana',
    'Tejgaon Model Thana',
    'Gulshan Thana',
    'Lalbagh Thana',
    'Mirpur Thana',
    'Pallabi Thana',
    'Sabujbag Thana',
    'Cantonment Thana',
    'Demra Thana',
    'Hazaribagh Thana',
    'Shyampur Thana',
    'Badda Thana',
    'Kafrul Thana',
    'Khilgaon Thana',
    'Uttara Model Thana',
    'Shah Ali Thana',
    'Biman Bandar Thana',
    'Paltan Model Thana',
    'Adabar Thana',
    'Darus Salam Thana',
    'Uttarkhan Thana',
    'Kamrangirchar Thana',
    'Kadamtoli Thana',
    'Gendaria Thana',
    'Chalkbazar Thana',
    'Tejgaon Industrial Thana',
    'Turag Thana',
    'Dakhinkhan Thana',
    'Bangshal Thana',
    'Bhashantek Thana',
    'Bhatara Thana',
    'Jatrabari Thana',
    'Rampura Thana',
    'Rupnagar Thana',
    'Sherebangla Nagar Thana',
    'Shahjahanpur Thana',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Thana',
        border: OutlineInputBorder(),
      ),
      value: selectedThana,
      items: thanas.map((String thana) {
        return DropdownMenuItem<String>(
          value: thana,
          child: Text(thana),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a thana';
        }
        return null;
      },
    );
  }
}
