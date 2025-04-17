import 'package:party/games/Monopoly/models/property.dart';

import '../../../host/player.dart';

enum spaceType{property, chance, community, tax, jail, police, start, station, company, parking}

class Space{
  Property? property;
  spaceType type;
  Space? previous;
  Space? next;
  int? rent;
  Player? owner;

  Space({required this.type, this.previous, this.next, this.property, this.rent});
}