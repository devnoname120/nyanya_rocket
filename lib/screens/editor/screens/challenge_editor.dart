import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/challenge_store.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ChallengeEditor extends StatefulWidget {
  static final ChallengeStore store = ChallengeStore();

  final ChallengeData challenge;
  final String uuid;

  ChallengeEditor({
    @required this.challenge,
    this.uuid,
  });

  @override
  _ChallengeEditorState createState() {
    return _ChallengeEditorState();
  }
}

class _ChallengeEditorState extends State<ChallengeEditor> {
  EditorGameController _editorGameController;
  String uuid;

  @override
  void initState() {
    super.initState();

    _editorGameController =
        EditorGameController(game: widget.challenge.getGame());

    uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editorGameController.close();
  }

  ChallengeData _buildChallengeData() {
    dynamic gameJson = _editorGameController.game.toJson();

    return ChallengeData(
      name: widget.challenge.name,
      author: 'Anonymous',
      type: widget.challenge.type,
      gameData: jsonEncode(gameJson),
    );
  }

  List<EditorMenu> _menusForType(ChallengeType type) {
    switch (type) {
      case ChallengeType.GetMice:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(
                type: ToolType.Tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.walls,
          StandardMenus.eraser,
        ];
        break;

      case ChallengeType.RunAway:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(
                type: ToolType.Tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
          StandardMenus.eraser,
        ];
        break;

      case ChallengeType.LunchTime:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
          StandardMenus.eraser,
        ];
        break;

      case ChallengeType.OneHundredMice:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(
                type: ToolType.Tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.generators,
          StandardMenus.walls,
          StandardMenus.eraser,
        ];
        break;

      default:
        return [];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
              child: EditorPlacer(
            editorGameController: _editorGameController,
            menus: _menusForType(widget.challenge.type),
            onPlay: () => _handlePlay(context),
            onSave: _handleSave,
          )),
        ],
      ),
    );
  }

  void _handlePlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Challenge(
              challenge: _buildChallengeData(),
            )));
  }

  void _handleSave() {
    if (uuid == null) {
      ChallengeEditor.store
          .saveNewChallenge(_buildChallengeData())
          .then((String uuid) {
        this.uuid = uuid;
        print('Saved $uuid');
      });
    } else {
      ChallengeEditor.store
          .updateChallenge(uuid, _buildChallengeData())
          .then((bool status) {
        print('Updated $uuid');
      });
    }
  }
}
