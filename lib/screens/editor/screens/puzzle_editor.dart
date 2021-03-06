import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_store.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzleEditor extends StatefulWidget {
  static final PuzzleStore store = PuzzleStore();

  final PuzzleData puzzle;
  final String uuid;

  PuzzleEditor({
    @required this.puzzle,
    this.uuid,
  });

  @override
  _PuzzleEditorState createState() {
    return _PuzzleEditorState();
  }
}

class _PuzzleEditorState extends State<PuzzleEditor> {
  EditorGameController _editorGameController;
  String uuid;

  @override
  void initState() {
    super.initState();

    _editorGameController = EditorGameController(game: widget.puzzle.getGame());

    uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editorGameController.close();
  }

  PuzzleData _buildPuzzleData() {
    List<int> availableArrows = List.filled(4, 0);

    Board copy = Board.copy(_editorGameController.game.board);

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (copy.tiles[x][y] is Arrow) {
          Arrow arrow = copy.tiles[x][y] as Arrow;
          availableArrows[arrow.direction.index]++;
          copy.tiles[x][y] = Empty();
        }
      }
    }

    dynamic gameJson = _editorGameController.game.toJson(); // TODO Cleaner way
    gameJson['board'] = copy.toJson();

    return PuzzleData(
        name: widget.puzzle.name,
        gameData: jsonEncode(gameJson),
        availableArrows: availableArrows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
      ),
      resizeToAvoidBottomPadding: false,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: <Widget>[
              Expanded(
                  child: EditorPlacer(
                      editorGameController: _editorGameController,
                      onPlay: () => _handlePlay(context),
                      onSave: _handleSave,
                      menus: [
                    EditorMenu(subMenu: <EditorTool>[
                      EditorTool(
                          type: ToolType.Tile,
                          tile: Rocket(player: PlayerColor.Blue)),
                      EditorTool(type: ToolType.Tile, tile: Pit())
                    ]),
                    StandardMenus.arrows,
                    StandardMenus.mice,
                    StandardMenus.cats,
                    StandardMenus.walls,
                    StandardMenus.eraser,
                  ])),
            ],
          );
        },
      ),
    );
  }

  void _handlePlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Puzzle(
              puzzle: _buildPuzzleData(),
            )));
  }

  void _handleSave() {
    if (uuid == null) {
      PuzzleEditor.store.saveNewPuzzle(_buildPuzzleData()).then((String uuid) {
        this.uuid = uuid;
        print('Saved $uuid');
      });
    } else {
      PuzzleEditor.store
          .updatePuzzle(uuid, _buildPuzzleData())
          .then((bool status) {
        print('Updated $uuid');
      });
    }
  }
}
