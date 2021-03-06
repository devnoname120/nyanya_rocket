import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/options_holder.dart';

class WhatsNew extends StatelessWidget {
  void _dismissWelcomeCard(BuildContext context) {
    OptionsHolder.of(context).options =
        OptionsHolder.of(context).options.copyWith(firstRun: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Visibility(
          visible: OptionsHolder.of(context).options.firstRun,
          child: Flexible(
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                _dismissWelcomeCard(context);
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        NyaNyaLocalizations.of(context).firstTimeWelcome,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Text(NyaNyaLocalizations.of(context).firstTimeText),
                    RaisedButton(
                      child: Text(
                          NyaNyaLocalizations.of(context).firstTimeButtonLabel),
                      onPressed: () {
                        _dismissWelcomeCard(context);
                        Navigator.pushNamed(context, '/tutorial');
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(
                    'articles_${Intl.shortLocale(Intl.getCurrentLocale())}')
                .orderBy('date', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child:
                          Text(NyaNyaLocalizations.of(context).loadingLabel));
                default:
                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return ExpansionTile(
                        title: Text(document['title']),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document['body']),
                          )
                        ],
                        trailing: Text(MaterialLocalizations.of(context)
                            .formatMediumDate(document['date'])),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        )
      ],
    );
  }
}
