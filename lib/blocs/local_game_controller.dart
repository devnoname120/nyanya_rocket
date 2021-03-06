
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LocalGameController extends GameTicker {
  final ValueNotifier<Game> gameStream;

  LocalGameController(Game game)
      : gameStream = ValueNotifier(game),
        super(game) {
    updateGame();
  }

  @protected
  void updateGame() {
    gameStream.value = game;
  }

  @override
  @mustCallSuper
  void afterTick() {
    updateGame();
  }

  @mustCallSuper
  @override
  void close() {
    super.close();

    gameStream.dispose();
  }
}
