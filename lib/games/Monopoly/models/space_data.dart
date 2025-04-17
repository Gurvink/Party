import 'package:party/games/Monopoly/models/property.dart';
import 'package:party/games/Monopoly/models/space.dart';

List<Space> standardSpaces = [
  Space(
      type: spaceType.start,
  ),
  Space(
      type: spaceType.property,
      property: Property(
        price: 60,
        rent: [2, 10, 30, 90, 160, 250],
        color: colorType.brown,
        name: "Dorpstraat",
        description: "De belangrijkste straat van iedere dorp",
        housePrice: 50,
        mortgage: 30,
      )
  ),
  Space(
      type: spaceType.community,
  ),
  Space(
      type: spaceType.property,
      property: Property(
          price: 60,
          rent: [],
          color: colorType.brown,
          name: "Brink",
          description: "Het mooiste plein in het dorp",
          housePrice: 50,
          mortgage: 30,
      )
  ),
  Space(
      type: spaceType.tax,
      rent: 200,
  ),
  Space(
      type: spaceType.station,
      property: Property(
          price: 200,
          rent: [25,50,100,200],
          color: colorType.station,
          name: "Station zuid",
          description: "Het oude station waarvan je denkt waarom bestaat dit",
          housePrice: 0,
          mortgage: 100),
  ),
  Space(
      type: spaceType.property,
      property: Property(
          price: 100,
          rent: [6,30,90,270,400,550],
          color: colorType.lightBlue,
          name: "Steenstraat",
          description: "Een prachtige winkelstraat met gezellige winkels",
          housePrice: 50,
          mortgage: 50
      ),
  ),
  Space(
      type: spaceType.chance
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 100,
        rent: [6,30,90,270,400,550],
        color: colorType.lightBlue,
        name: "Ketelstraat",
        description: "Een straat met veel karakter en winkels",
        housePrice: 50,
        mortgage: 50
    ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 100,
        rent: [8,40,100,300,450,600],
        color: colorType.lightBlue,
        name: "Velperplein",
        description: "Een prachtig plein in het centrum",
        housePrice: 50,
        mortgage: 50
    ),
  ),
  Space(
      type: spaceType.jail,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 140,
        rent: [10,50,150,450,625,750],
        color: colorType.pink,
        name: "Barteljorisstraat",
        description: "Een straat met allerlei mooie panden",
        housePrice: 100,
        mortgage: 70
    ),
  ),
  Space(
      type: spaceType.company,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 140,
        rent: [10,50,150,450,625,750],
        color: colorType.pink,
        name: "Zijlweg",
        description: "een weg die zich bevind in de zijlwegkwartier",
        housePrice: 100,
        mortgage: 70
    ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 160,
        rent: [12,60,180,500,700,900],
        color: colorType.pink,
        name: "Houtstraat",
        description: "De leukste winkelstraat van Nederland",
        housePrice: 100,
        mortgage: 70
    ),
  ),
  Space(
    type: spaceType.station,
    property: Property(
        price: 200,
        rent: [25,50,100,200],
        color: colorType.station,
        name: "Station west",
        description: "Een hyper modern station met veels te veel winkeltjes",
        housePrice: 0,
        mortgage: 100
    ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 180,
        rent: [14,70,200,550,750,950],
        color: colorType.orange,
        name: "Neude",
        description: "Een prachtig plein in het centrum",
        housePrice: 100,
        mortgage: 90
    ),
  ),
  Space(
      type: spaceType.community,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 180,
        rent: [14,70,200,550,750,950],
        color: colorType.orange,
        name: "Biltstraat",
        description: "De straat tussen noordoost en oost",
        housePrice: 100,
        mortgage: 90
    ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 200,
        rent: [14,70,200,550,750,950],
        color: colorType.orange,
        name: "Vreeburg",
        description: "Een groot plein bij het station",
        housePrice: 100,
        mortgage: 90
    ),
  ),
  Space(
      type: spaceType.parking,
  ),
  Space(
      type: spaceType.property,
    property: Property(
        price: 220,
        rent: [18,90,250,700,875,1050],
        color: colorType.red,
        name: "A-Kerkhof",
        description: "de plek met de prachtige Der Aa-Kerk",
        housePrice: 150,
        mortgage: 110
    ),
  ),
  Space(
      type: spaceType.chance,
  ),
  Space(
      type: spaceType.property,
      property: Property(
        price: 220,
        rent: [18,90,250,700,875,1050],
        color: colorType.red,
        name: "Grote markt",
        description: "Het prachtige plein aan de voet van de Martinitoren",
        housePrice: 150,
        mortgage: 110
      ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 240,
        rent: [20,100,300,750,925,1100],
        color: colorType.red,
        name: "Herestraat",
        description: "Een zeer belangrijke winkelstraat",
        housePrice: 150,
        mortgage: 120
    ),
  ),
  Space(
    type: spaceType.station,
    property: Property(
        price: 200,
        rent: [25,50,100,200],
        color: colorType.station,
        name: "Station noord",
        description: "Een lekker standaard station waar niet veel te bleven is",
        housePrice: 0,
        mortgage: 100
    ),
  ),
  Space(
      type: spaceType.property,
      property: Property(
        price: 260,
        rent: [22,110,330,800,975,1150],
        color: colorType.yellow,
        name: "Spui",
        description: "Een mooie straat waar vroeger een gracht lag",
        housePrice: 150,
        mortgage: 130
      ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 260,
        rent: [22,110,330,800,975,1150],
        color: colorType.yellow,
        name: "Plein",
        description: "Een prachtige plein vlak bij het Binnenhof",
        housePrice: 150,
        mortgage: 130
    ),
  ),
  Space(
      type: spaceType.company,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 280,
        rent: [24,120,360,850,1025,1200],
        color: colorType.yellow,
        name: "Lange poten",
        description: "De verbindingsweg tussen het centrum en het centraal station",
        housePrice: 150,
        mortgage: 130
    ),
  ),
  Space(
      type: spaceType.police,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 300,
        rent: [26,130,390,900,1100,1275],
        color: colorType.green,
        name: "Hofplein",
        description: "Een verkeersplein met de Hofpleinfontein in het midden",
        housePrice: 200,
        mortgage: 150
    ),
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 300,
        rent: [26,130,390,900,1100,1275],
        color: colorType.green,
        name: "Blaak",
        description: "Een straat in het zakencentrum",
        housePrice: 200,
        mortgage: 150
    ),
  ),
  Space(
      type: spaceType.community,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 320,
        rent: [28,150,450,1000,1200,1400],
        color: colorType.green,
        name: "Coolsingel",
        description: "Het punt van samenkomst voor grote vreugde",
        housePrice: 200,
        mortgage: 160
    ),
  ),
  Space(
    type: spaceType.station,
    property: Property(
        price: 200,
        rent: [25,50,100,200],
        color: colorType.station,
        name: "Station oost",
        description: "Een klein station waar maar één trein komt",
        housePrice: 0,
        mortgage: 100
    ),
  ),
  Space(
      type: spaceType.chance,
  ),
  Space(
    type: spaceType.property,
    property: Property(
        price: 350,
        rent: [35,175,500,1100,1300,1500],
        color: colorType.darkBlue,
        name: "Leidschestraat",
        description: "een drukke winkelstraat met leuke winkels",
        housePrice: 200,
        mortgage: 175,
    ),
  ),
  Space(
      type: spaceType.tax,
      rent: 100
  ),
  Space(
    type: spaceType.property,
    property: Property(
      price: 400,
      rent: [50,200,600,1400,1700,2000],
      color: colorType.darkBlue,
      name: "Kalverstraat",
      description: "een winkelstraat met veel monumenten",
      housePrice: 200,
      mortgage: 200,
    ),
  ),
];