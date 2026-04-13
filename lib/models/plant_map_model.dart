import 'package:geo_leaf/models/plant_model.dart';

class PlantMap {
  final String name;
  final String scientificName;
  final List<Plant>? registeredPlants;

  PlantMap({
    required this.name,
    required this.scientificName,
    this.registeredPlants,
  });
  factory PlantMap.fromJson(Map<String, dynamic> json) {
    List<Plant> plants = List.empty(growable: true);
    for( var plant in json["plants"] )
    {
      plants.add(Plant.fromJson(plant));
    }
    return PlantMap(
      name: json["name"],
      scientificName: json["scientificName"],
      registeredPlants: plants,
    );
  }
  Map<String, dynamic> toJson()
  {
    return {
      "name": name,
      "scientificName": scientificName,
      "plants": registeredPlants
    };
  }
}
