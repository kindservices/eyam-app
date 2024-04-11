import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eyam_app/app/section/section_data.dart';
import 'package:flutter/material.dart';

class Section {
  static Future<CollectionReference<Map<String, dynamic>>> sections() async {
    return FirebaseFirestore.instance.collection('sections');
  }

  static final List<IconData> availableIcons = [
    Icons.accessibility_new,
    Icons.account_balance,
    Icons.alarm,
    Icons.build,
    Icons.back_hand_sharp,
    Icons.balance,
    Icons.cabin,
    Icons.camera,
    Icons.camera_alt,
    Icons.dark_mode,
    Icons.emoji_emotions,
    Icons.face,
    Icons.family_restroom,
    Icons.factory,
    Icons.favorite,
    Icons.gamepad_outlined,
    Icons.garage_rounded,
    Icons.gite,
    Icons.golf_course,
    Icons.grading,
    Icons.home,
    Icons.handyman,
    Icons.headphones,
    Icons.healing,
    Icons.health_and_safety,
    Icons.ice_skating_rounded,
    Icons.icecream_outlined,
    Icons.imagesearch_roller,
    Icons.insights,
    Icons.kayaking,
    Icons.key_sharp,
    Icons.keyboard,
    Icons.king_bed_outlined,
    Icons.lock,
    Icons.label_important,
    Icons.lan_rounded,
    Icons.landscape_outlined,
    Icons.lens_blur,
    Icons.mail_outlined,
    Icons.male,
    Icons.female,
    Icons.nature_people,
    Icons.near_me,
    Icons.offline_bolt_outlined,
    Icons.ondemand_video_sharp,
    Icons.outdoor_grill,
    Icons.agriculture_outlined,
    Icons.palette_outlined,
    Icons.park,
    Icons.qr_code_2_rounded,
    Icons.radio_rounded,
    Icons.ramp_left,
    Icons.recycling,
    Icons.school,
    Icons.star,
    Icons.sailing,
    Icons.satellite_alt,
    Icons.sports_handball,
    Icons.sports_football,
    Icons.sports_soccer,
    Icons.settings,
    Icons.table_bar_outlined,
    Icons.tablet_mac,
    Icons.verified,
    Icons.video_camera_front_outlined,
    Icons.wallet,
    Icons.warning,
    Icons.water,
    Icons.work,
    Icons.wb_incandescent_outlined,
    Icons.wb_cloudy_rounded,
    Icons.wb_sunny_rounded
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
        .where('visibility', whereIn: ['public', 'default', 'private'])
        .orderBy('position', descending: false)
        .get();

    // Getting all the documents returned by the query
    List<DocumentSnapshot> documents = querySnapshot.docs;

    return documents.map((e) => SectionData.fromDocumentSnapshot(e));
  }
}
