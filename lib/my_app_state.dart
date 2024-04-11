import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  List<String> sections = List.empty();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void updateSections(List<String> newSections) {
    print("update sectios from $sections to $newSections");
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
