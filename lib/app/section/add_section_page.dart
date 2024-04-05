import 'package:eyam_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSectionPage extends StatefulWidget {
  @override
  _AddSectionPageState createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String _visibility = 'default';
  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      print("Savng ...");
      setState(() {
        saving = true;
      });

      DocumentReference<Map<String, dynamic>> result =
          await FirebaseFirestore.instance.collection('sections').add({
        'name': nameController.text,
        'visibility': _visibility,
      });

      setState(() {
        saving = false; // Stop saving
      });
      print("Saved!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Created ${nameController.text} section ${result.id}!')),
      );
    } else {
      print("Form Errors");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct errors')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name', enabled: !saving),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a section name';
                } else {
                  var trimmed = value.trim();
                  if (trimmed.length < 3) {
                    return 'The name "${trimmed}" must be more than 3 characters and less than 50';
                  } else if (trimmed.length > 50) {
                    return 'The name "${trimmed}" must be less than 50 characters';
                  }
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              value: _visibility,
              decoration:
                  InputDecoration(labelText: 'Visibility', enabled: !saving),
              items: <String>['public', 'default', 'private']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: saving
                  ? null
                  : (String? newValue) {
                      setState(() {
                        _visibility = newValue!;
                      });
                    },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _saveData,
                    child: Text('Save'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: saving
                        ? null
                        : () {
                            // Add your own cancel functionality
                            Navigator.of(context).pop();
                          },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
