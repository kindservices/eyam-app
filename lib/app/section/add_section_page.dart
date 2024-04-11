import 'package:eyam_app/app/section/section.dart';
import 'package:eyam_app/my_app_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:provider/provider.dart';

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

  IconData? selectedIcon;

  @override
  void dispose() {
    _nameController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void onCancel(BuildContext context) {
    MyAppState.forContext(context).unsetSection();
  }

  void onAddSection(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saving = true;
      });

      // TODO - this is a race-condition hack
      var pos = Provider.of<MyAppState>(context, listen: false).sections.length;

      await Section.addSection(
          _nameController.text, _visibility, selectedIcon?.codePoint ?? 0, pos);

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
        SnackBar(content: Text('Please correct the errors')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                sectionNameField(),
                SizedBox(height: 10),
                iconField(),
                SizedBox(height: 18),
                emojiPicker(),
                SizedBox(height: 18),
                visibilityField(),
                SizedBox(height: 18),
                formButtons(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<IconData> iconField() {
    return DropdownButtonFormField<IconData>(
      decoration: InputDecoration(
          labelText: 'Icon', // Label added here
          border: OutlineInputBorder(),
          enabled: !saving),
      value: selectedIcon,
      hint: Text('Select an Icon'),
      onChanged: (newValue) {
        setState(() {
          selectedIcon = newValue;
        });
      },
      items: Section.availableIcons
          .map<DropdownMenuItem<IconData>>((IconData value) {
        return DropdownMenuItem<IconData>(
          value: value,
          child: Icon(value),
        );
      }).toList(),
    );
  }

  Widget sectionNameField() {
    return TextFormField(
      controller: _nameController,
      scrollController: _scrollController,
      focusNode: _focus,
      decoration: InputDecoration(
          prefixIcon: IconButton(
            icon: Icon(Icons.emoji_objects_outlined),
            onPressed: () {
              setState(() {
                _emojiShowing = !_emojiShowing;
              });
            },
          ),
          labelText: 'Name',
          border: OutlineInputBorder(),
          enabled: !saving),
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
    );
  }

  void _moveFocus() {
    setState(() {
      _emojiShowing = !_emojiShowing;
      _nameController.selection =
          TextSelection.collapsed(offset: _nameController.text.length);
    });
    _focus.requestFocus();
  }

  Offstage emojiPicker() {
    return Offstage(
      offstage: !_emojiShowing,
      child: EmojiPicker(
        textEditingController: _nameController,
        scrollController: _scrollController,
        onEmojiSelected: (category, emoji) => _moveFocus(),
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
          bottomActionBarConfig:
              const BottomActionBarConfig(showBackspaceButton: false),
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
            onPressed: saving ? null : () => onCancel(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget visibilityField() {
    return DropdownButtonFormField(
      value: _visibility,
      decoration: InputDecoration(
          labelText: 'Visibility',
          border: OutlineInputBorder(),
          enabled: !saving),
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
    );
  }
}
