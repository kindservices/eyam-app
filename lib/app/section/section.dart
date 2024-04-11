import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyam_app/app/section/section_data.dart';
import 'package:flutter/material.dart';

class Section {
  static Future<CollectionReference<Map<String, dynamic>>> sections() async {
    return FirebaseFirestore.instance.collection('sections');
  }

  static final List<IconData> availableIcons = [
    Icons.home,
    Icons.star,
    Icons.settings,
    Icons.alarm,
    Icons.face,
    Icons.lock,
    Icons.camera,
    Icons.camera_alt,
    Icons.school,
    Icons.work,
    Icons.build,
    Icons.accessibility_new,
    Icons.account_balance,
    Icons.sports_handball,
    Icons.sports_football,
    Icons.sports_soccer,
    Icons.cabin,
    Icons.emoji_emotions
  ];

  static addSection(
      String name, String visibility, int iconCodePoint, int position) async {
    CollectionReference<Map<String, dynamic>> coll = await sections();
    await coll.add({
      'name': name,
      'visibility': visibility,
      'iconCodePoint': iconCodePoint,
      'position': position
    });
  }

  /// TODO - the query logic is wrong. It needs to be thought out propertly,
  /// but should be something like:
  ///
  /// For anonymous users:
  /// - show all public sections
  ///
  /// For logged-in users:
  /// - all public sections, and
  /// - all sections written by me, and
  /// - all default sections, meaning sections which I'm a member of
  static Future<Iterable<SectionData>> getVisibleSections() async {
    CollectionReference<Map<String, dynamic>> coll = await sections();
    // Querying the 'sections' collection where 'visible' field is 'public', 'default', or 'private'
    QuerySnapshot querySnapshot = await coll
        .where('visibility', whereIn: ['public', 'default', 'private']).get();

    // Getting all the documents returned by the query
    List<DocumentSnapshot> documents = querySnapshot.docs;

    return documents.map((e) => SectionData.fromDocumentSnapshot(e));
  }
}
