import 'package:eyam_app/app/section/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' as foundation;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class AddSectionPage extends StatefulWidget {
  @override
  _AddSectionPageState createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emojiController = TextEditingController();
  String _visibility = 'default';
  bool saving = false;

  Emoji? icon;

  @override
  void dispose() {
    nameController.dispose();
    emojiController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saving = true;
      });

      await Section.save(nameController.text, _visibility);

      setState(() {
        saving = false; // Stop saving
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created ${nameController.text}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct errors')),
      );
    }
  }

  Widget emojiPicker(BuildContext context) {
    return Row(
      children: [
        // CupertinoActionSheetAction(
        //   child: Text('Close'),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        EmojiPicker(
          onEmojiSelected: (Category? category, Emoji emoji) {
            setState(() {
              icon = emoji;
            });
            Navigator.pop(context);
          },
          onBackspacePressed: null,
          textEditingController:
              emojiController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
          config: Config(
            height: 256,
            // bgColor: const Color(0xFFF2F2F2),
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 28 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
            ),
            swapCategoryAndBottomBar: false,
            skinToneConfig: const SkinToneConfig(),
            categoryViewConfig: const CategoryViewConfig(),
            bottomActionBarConfig: const BottomActionBarConfig(),
            searchViewConfig: const SearchViewConfig(),
          ),
        ),
      ],
    );
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
            Row(
              children: [
                Text("Icon:"),
                if (icon != null) Text(icon!.emoji),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      // showCupertinoModalPopup(context: context, builder: builder)
                      // how do I hide this modal programmatically?
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return emojiPicker(context);
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
                    onPressed: saving ? null : _saveData,
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
