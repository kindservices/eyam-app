import 'package:eyam_app/app/section/section.dart';
import 'package:eyam_app/my_app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' as foundation;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class AddSectionPage extends StatefulWidget {
  @override
  _AddSectionPageState createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scrollController = ScrollController();
  FocusNode _focus = FocusNode();
  String _visibility = 'default';
  bool saving = false;
  bool _emojiShowing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void onAddSection(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saving = true;
      });

      await Section.addSection(_nameController.text, _visibility);

      setState(() {
        saving = false; // Stop saving
      });
      var st8 = Provider.of<MyAppState>(context, listen: false);

      Section.getVisibleSections()
          .then((value) => st8.updateSections(value.toList()));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created ${_nameController.text}')),
      );
    } else {
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
            sectionNameField(),
            emojiPicker(),
            visibilityField(),
            formButtons(context),
          ],
        ),
      ),
    );
  }

  Row sectionNameField() {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              setState(() {
                _emojiShowing = !_emojiShowing;
              });
            },
            icon: const Icon(
              Icons.emoji_emotions,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: _nameController,
            scrollController: _scrollController,
            focusNode: _focus,
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
        ),
      ],
    );
  }

  Offstage emojiPicker() {
    return Offstage(
      offstage: !_emojiShowing,
      child: EmojiPicker(
        textEditingController: _nameController,
        scrollController: _scrollController,
        onEmojiSelected: (category, emoji) => _focus.requestFocus(),
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.2
                    : 1.0),
          ),
          swapCategoryAndBottomBar: false,
          skinToneConfig: const SkinToneConfig(),
          categoryViewConfig: const CategoryViewConfig(),
          bottomActionBarConfig: const BottomActionBarConfig(),
          searchViewConfig: const SearchViewConfig(),
        ),
      ),
    );
  }

  Padding formButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: saving ? null : () => onAddSection(context),
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
    );
  }

  Padding visibilityField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
      child: DropdownButtonFormField(
        value: _visibility,
        decoration: InputDecoration(labelText: 'Visibility', enabled: !saving),
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
    );
  }
}
