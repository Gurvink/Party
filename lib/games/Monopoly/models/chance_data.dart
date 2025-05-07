import 'package:flutter/cupertino.dart';

class Card {
  String Text;
  void Function() action;

  Card(this.Text, this.action);
}

List<Card> cards = [
  Card("Je bent derde geworden in een toernooi.\n Het prijzengeld is 100 euro", () {
    print('iets');
  }),
];