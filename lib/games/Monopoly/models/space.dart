import 'package:party/games/Monopoly/models/property.dart';

import '../../../host/player.dart';

enum SpaceType{property, chance, community, tax, jail, police, start, station, company, parking}
enum Side{top, right, left, bottom}

class Space{
  Property? property;
  SpaceType type;
  late Space previous;
  late Space next;
  int? rent;
  Player? owner;
  late Side side;

  Space({required this.type, this.property, this.rent});

  @override
  String toString() {
    String string = type.name;
    return string;
  }
}