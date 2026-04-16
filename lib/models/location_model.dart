import 'package:geo_leaf/models/plant_map_model.dart';

class Location {
  final String name;
  final List<PlantMap> plant;

  Location({required this.name, required this.plant});

  int getTotalPlants()
  {
    int sum = 0;
    for(final PlantMap _plant in plant)
    {
      sum += _plant.registeredPlants!.length;
    }
    return sum;
  }
}
