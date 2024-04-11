import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SectionData {
  String name;
  int iconCodePoint;
  int position = 0;

  SectionData(
      {required this.name,
      required this.iconCodePoint,
      required this.position});

  IconData get iconData => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  // Section.availableIcons
  Icon icon() {
    return Icon(iconData);
  }

  // Factory function to create an instance from a DocumentSnapshot
  factory SectionData.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SectionData(
      name: data['name'],
      iconCodePoint: data['iconCodePoint'],
      position: data['position'],
    );
  }
}
