import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/available_arrows.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/puzzle_game_controls.dart';
import 'package:nyanya_rocket/widgets/game_view/game_view.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzlePopData {
  final bool playNext;

  PuzzlePopData({@required this.playNext});
}

class Puzzle extends StatefulWidget {
  final PuzzleData puzzle;
  final void Function(bool starred) onWin;
  final void Function() playNext;

  Puzzle({this.puzzle, this.onWin, this.playNext});

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  PuzzleGameController _puzzleController;
  AvailableArrows _availableArrows;
  bool _ended = false;

  @override
  void initState() {
    super.initState();

    _puzzleController =
        PuzzleGameController(puzzle: widget.puzzle, onWin: _handleWin);
    _availableArrows = AvailableArrows(
      puzzleGameController: _puzzleController,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _puzzleController.close();
  }

  void _handleTap(int x, int y) {
    _puzzleController.removeArrow(x, y);
  }

  void _handleDropAndSwipe(int x, int y, Direction direction) {
    _puzzleController.placeArrow(x, y, direction);
  }

  void _handleWin() {
    setState(() {
      _ended = true;
    });

    if (widget.onWin != null) {
      bool starred = _puzzleController.remainingArrows(Direction.Right) > 0 ||
          _puzzleController.remainingArrows(Direction.Up) > 0 ||
          _puzzleController.remainingArrows(Direction.Left) > 0 ||
          _puzzleController.remainingArrows(Direction.Down) > 0;

      widget.onWin(starred);
    }
  }

  Widget _dragTileBuilder(BuildContext context, List<Direction> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.length == 0) return Container();
    return ArrowImage(
      direction: candidateData[0],
      player: PlayerColor.Blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool notNull(Object o) => o != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Flex(
            direction:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
            children: <Widget>[
              Spacer(),
              Divider(),
              Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                        aspectRatio: 12.0 / 9.0,
                        child: InputGridOverlay<Direction>(
                          child: StreamBuilder<Game>(
                              stream: _puzzleController.gameStream.stream,
                              initialData: Game(),
                              builder: (BuildContext context,
                                      AsyncSnapshot<Game> snapshot) =>
                                  GameView(
                                    board: snapshot.data.board,
                                    entities: snapshot.data.entities,
                                    mistake: _puzzleController.mistake,
                                  )),
                          onDrop: _handleDropAndSwipe,
                          onTap: _handleTap,
                          onSwipe: _handleDropAndSwipe,
                          previewBuilder: _dragTileBuilder,
                        )),
                  )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _availableArrows,
              )),
              Flexible(
                flex: 0,
                child: PuzzleGameControls(
                  puzzleController: _puzzleController,
                ),
              ),
            ],
          ),
          _ended ? SuccessOverlay(succeededName: widget.puzzle.name) : null,
        ].where(notNull).toList(),
      ),
    );
  }
}
