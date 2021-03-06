import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/editor/widgets/create_tab.dart';
import 'package:nyanya_rocket/screens/editor/widgets/edit_tab.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class Editor extends StatefulWidget {
  @override
  EditorState createState() {
    return new EditorState();
  }
}

class EditorState extends State<Editor> {
  String name;
  EditorMode mode;

  @override
  void initState() {
    super.initState();

    mode = EditorMode.Puzzle;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).editorTitle),
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Icon(Icons.add),
                  text: NyaNyaLocalizations.of(context).newTab),
              Tab(
                  icon: Icon(Icons.edit),
                  text: NyaNyaLocalizations.of(context).editTab),
            ],
          ),
        ),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [
            CreateTab(),
            EditTab(),
          ],
        ),
      ),
    );
  }
}
