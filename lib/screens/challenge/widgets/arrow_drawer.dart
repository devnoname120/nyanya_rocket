import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ArrowDrawer extends StatelessWidget {
  final ChallengeGameController challengeGameController;

  const ArrowDrawer({Key key, @required this.challengeGameController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: MediaQuery.of(context).orientation == Orientation.landscape
            ? Axis.vertical
            : Axis.horizontal,
        children: List<Widget>.generate(
            4,
            (i) => Expanded(
                  child: Draggable<Direction>(
                      maxSimultaneousDrags:
                          challengeGameController.running ? null : 0,
                      feedback: const SizedBox.shrink(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ArrowImage(
                            player: PlayerColor.Blue,
                            direction: Direction.values[i]),
                      ),
                      data: Direction.values[i]),
                )));
  }
}
