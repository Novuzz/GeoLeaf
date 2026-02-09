import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/models/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Uri url({String url = ""}) => Uri.parse('http://localhost:3000/$url');

Future<List<User>> getUsers() async {
  final response = await http.Client().get(url(url: "users"));
  final json = jsonDecode(response.body);
  return List<User>.from(json.map((e) => User.fromJson(e)));
}

Future<User?> getUsersById(String id) async {
  final response = await http.Client().get(url(url: "users/$id"));
  if (response.statusCode == 200) {
    print(response.body);
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  }
  return null;
  //print(json);
}

Future<User?> loginUser(String email, String password) async {
  final response = await http.Client().post(
    url(url: "users/login"),
    body: {"email": email, "password": password},
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  } else {
    return null;
  }
}

Future<List<Plant>> getPlants({bool onlyData = false}) async {
  final response = await http.Client().get(
    url(url: "plants${onlyData ? "/data" : ""}"),
  );
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    List<Plant> plants = List.empty(growable: true);

    for (final plant in json) {
      final user = plant['user'];
      if (user != null) {
        plant['user'] = await getUsersById(user);
      } else {
        continue;
      }
      plants.add(Plant.fromJson(plant));
    }
    return plants;
  }
  return [];
}

Future<Plant?> getPlantById(String id) async {
  final response = await http.Client().get(url(url: "plants/$id"));
  if (response.statusCode == 200) {
    print(response.body);
    final json = jsonDecode(response.body);
    return Plant.fromJson(json);
  }
  return null;
}

Future<int> postPlant(Plant plant) async {
  final response = await http.Client().post(
    url(url: "plants"),
    body: ({"data": jsonEncode(await plant.toJson())}),
  );
  return response.statusCode;
}
