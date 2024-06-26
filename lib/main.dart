import 'package:eyam_app/app/section/add_section_page.dart';
import 'package:eyam_app/app/section/section.dart';
import 'package:eyam_app/app/section/section_data.dart';
import 'package:eyam_app/app/section/section_page.dart';
import 'package:eyam_app/app_state.dart';
import 'package:eyam_app/generator_page.dart';
import 'package:eyam_app/init.dart';
import 'package:eyam_app/my_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await Init.init();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Eyam App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var selectedSection = "";

  @override
  void initState() {
    super.initState();

    var st8 = MyAppState.forContext(context);

    selectedSection = st8.currentSection?.name ?? "";

    Section.getVisibleSections()
        .then((value) => st8.updateSections(value.toList()));
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // if the 'Add Section' has updated the current section, then it will disagree
    // with the selectedSection state variable, so we need to reset it
    if (selectedSection != (appState.currentSection?.name ?? "")) {
      selectedSection = appState.currentSection?.name ?? "";
      if (selectedSection != "") {
        selectedIndex = appState.sections
            .indexWhere((element) => element.name == selectedSection);
      } else {
        selectedIndex = 0;
      }
    }

    return buildPage(context, appState.sections);
  }

  Widget buildPage(BuildContext context, List<SectionData> sections) {
    Widget page;

    var lastIndex = sections.length + 2;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      default:
        if (selectedIndex == lastIndex) {
          page = AddSectionPage();
        } else {
          page = SelectedSection(sectionName: selectedSection);
        }
    }

    return mainPage(sections, page);
  }

  LayoutBuilder mainPage(List<SectionData> sections, Widget page) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(child: navigationRail(constraints, sections)),
            Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page),
            ),
          ],
        ),
      );
    });
  }

  NavigationRail navigationRail(
      BoxConstraints constraints, List<SectionData> sections) {
    var safeIndex = selectedIndex;
    var maxIndex = 2 + sections.length;
    if (selectedIndex > maxIndex) {
      print("WTF? $selectedIndex w/ maxIndex $maxIndex for $sections");
      safeIndex = maxIndex - 1;
    }
    return NavigationRail(
      extended: constraints.maxWidth >= 600,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.favorite),
          label: Text('Favorites'),
        ),
        // code to insert more NavigationRailDestination from sections  list
        ...sections.map((section) => NavigationRailDestination(
              icon: section.icon(),
              label: Text(section.name),
            )),
        NavigationRailDestination(
          icon: Icon(Icons.add_circle),
          label: Text('Add Section'),
        )
      ],
      selectedIndex: safeIndex,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
          if (selectedIndex > 1) {
            var sectionIndex = selectedIndex - 2;
            if (sectionIndex >= sections.length) {
              // the user clicked on the last nav element, 'Add Section'
              selectedSection = "";
            } else {
              selectedSection = sections[selectedIndex - 2].name;
            }
            MyAppState.forContext(context).setSection(selectedSection);
          }
        });
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
