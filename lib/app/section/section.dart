import 'package:cloud_firestore/cloud_firestore.dart';

class Section {
  static Future<CollectionReference<Map<String, dynamic>>> sections() async {
    return FirebaseFirestore.instance.collection('sections');
  }

  static save(String name, String visibility) async {
    CollectionReference<Map<String, dynamic>> coll = await sections();
    await coll.add({
      'name': name,
      'visibility': visibility,
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
  static Future<Iterable<String>> getVisibleSections() async {
    CollectionReference<Map<String, dynamic>> coll = await sections();
    // Querying the 'sections' collection where 'visible' field is 'public', 'default', or 'private'
    QuerySnapshot querySnapshot = await coll
        .where('visibility', whereIn: ['public', 'default', 'private']).get();

    // Getting all the documents returned by the query
    List<DocumentSnapshot> documents = querySnapshot.docs;

    return documents
        .map((e) => e.get("name")?.toString() ?? "")
        .where((n) => n.isNotEmpty);
  }
}
