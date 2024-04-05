import 'package:eyam_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Text('Add section.'),
    );
  }
}
