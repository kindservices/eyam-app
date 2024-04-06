import 'package:flutter/material.dart';

class SelectedSection extends StatelessWidget {
  final String sectionName;

  SelectedSection({required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Selected Section: $sectionName',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
