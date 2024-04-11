import 'package:english_words/english_words.dart';
import 'package:eyam_app/app/section/section_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  List<SectionData> sections = List.empty();
  SectionData? currentSection;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  static MyAppState forContext(BuildContext context) {
    return Provider.of<MyAppState>(context, listen: false);
  }

  void unsetSection() {
    setSection(sections.firstOrNull?.name ?? "");
  }

  void setSection(String name) {
    SectionData? found =
        sections.where((element) => element.name == name).firstOrNull;
    SectionData? before = currentSection;
    currentSection = found;

    if (before != currentSection) {
      // print("updating section from $before to $currentSection, notifying...");
      notifyListeners();
    } else {
      // print("updating section from $before to $currentSection, no change");
    }
  }

  void updateSections(List<SectionData> newSections) {
    sections = newSections;
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
