import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/editor/screens/challenge_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/multiplayer_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/puzzle_editor.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class CreateTab extends StatefulWidget {
  @override
  CreateTabState createState() {
    return new CreateTabState();
  }
}

class CreateTabState extends State<CreateTab>
    with AutomaticKeepAliveClientMixin<CreateTab> {
  String _name;
  EditorMode _mode;
  ChallengeType _challengeType;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _name = '';
    _mode = EditorMode.Puzzle;
    _challengeType = ChallengeType.GetMice;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Spacer(flex: 2),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: NyaNyaLocalizations.of(context).nameLabel,
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLength: 32,
                  onSaved: (String value) {
                    _name = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return NyaNyaLocalizations.of(context).invalidNameText;
                    }
                  },
                ),
                DropdownButtonFormField<EditorMode>(
                  value: _mode,
                  items: <DropdownMenuItem<EditorMode>>[
                    DropdownMenuItem(
                      child: Text(NyaNyaLocalizations.of(context).puzzleType),
                      value: EditorMode.Puzzle,
                    ),
                    DropdownMenuItem(
                      child:
                          Text(NyaNyaLocalizations.of(context).challengeType),
                      value: EditorMode.Challenge,
                    ),
                    DropdownMenuItem(
                      child:
                          Text(NyaNyaLocalizations.of(context).multiplayerType),
                      value: EditorMode.Multiplayer,
                    ),
                  ],
                  onChanged: (EditorMode value) => setState(() {
                        _mode = value;
                      }),
                  onSaved: (EditorMode value) => _mode = value,
                ),
                Visibility(
                  visible: _mode == EditorMode.Challenge,
                  child: DropdownButtonFormField<ChallengeType>(
                    value: _challengeType,
                    items: <DropdownMenuItem<ChallengeType>>[
                      DropdownMenuItem(
                        child: Text(ChallengeType.GetMice.toString()),
                        value: ChallengeType.GetMice,
                      ),
                      DropdownMenuItem(
                        child: Text(ChallengeType.RunAway.toString()),
                        value: ChallengeType.RunAway,
                      ),
                      DropdownMenuItem(
                        child: Text(ChallengeType.LunchTime.toString()),
                        value: ChallengeType.LunchTime,
                      ),
                      DropdownMenuItem(
                        child: Text(ChallengeType.OneHundredMice.toString()),
                        value: ChallengeType.OneHundredMice,
                      ),
                    ],
                    onChanged: (ChallengeType value) => setState(() {
                          _challengeType = value;
                        }),
                    onSaved: (ChallengeType value) => _challengeType = value,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(NyaNyaLocalizations.of(context).createLabel),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            switch (_mode) {
                              case EditorMode.Puzzle:
                                return PuzzleEditor(
                                    puzzle: PuzzleData.withBorder(name: _name));
                                break;

                              case EditorMode.Challenge:
                                return ChallengeEditor(
                                  challenge: ChallengeData.withBorder(
                                      name: _name,
                                      author: 'Anonymous',
                                      type: _challengeType),
                                );
                                break;

                              case EditorMode.Multiplayer:
                                return MultiplayerEditor(
                                  board: MultiplayerBoard.withBorder(
                                      name: _name, maxPlayer: 2),
                                );
                                break;
                            }
                          }));
                        }
                      }),
                ),
              ],
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
