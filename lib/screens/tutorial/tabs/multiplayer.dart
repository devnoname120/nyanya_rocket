import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class Multiplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TilesDrawer.tileView(
                          Generator(direction: Direction.Up)),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  )
                ],
              )),
        ),
        Card(
          child: Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntitiesDrawer.entityView(
                        EntityType.SpecialMouse, Direction.Right),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                ],
              )),
        ),
        Card(
          child: Container(
            height: 100,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EntitiesDrawer.entityView(
                      EntityType.GoldenMouse, Direction.Down),
                )),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(''),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
