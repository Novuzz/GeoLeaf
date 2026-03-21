import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Uri url({String url = ""}) => Uri.parse('http://localhost:3000/$url');

Future<String> get path async {
  return (await getApplicationDocumentsDirectory()).path;
}

Future<File> file(String f) async {
  final p = await path;
  return File('$p/$f');
}

Future<List<dynamic>> _openData(String f) async {
  List<dynamic> arr = [];
  if (await (await file(f)).exists()) {
    final content = await (await file(f)).readAsString();
    arr = jsonDecode(content) as List<dynamic>;
  }
  return arr;
}

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

Future<User?> signupUser(Map<String, dynamic> user) async {
  List<dynamic> arr = await _openData("users.json");
  arr.add(user);
  (await file("users.json")).writeAsString(jsonEncode(arr));
  return User.fromJson(user);
}

Future<User?> loginUser(String email, String password) async {
  try {
    Map<String, dynamic> user = (await _openData(
      "users.json",
    )).firstWhere((u) => u['email'] == email);
    return User.fromJson(user);
  } catch (e) {
    return null;
  }
}

Future<void> updatePlant(String id, Map<String, String> obj) async {
  final response = await http.Client().patch(url(url: "plants/$id"), body: obj);
  print(response);
}

Future<void> deletePlant(String id, String userId) async {
  print(id);
  print(userId);

  final response = await http.Client().delete(
    url(url: "plants/$id"),
    body: {"id": userId},
  );
  print(response.statusCode);
}

Future<List<Plant>> getPlants({bool onlyData = false}) async {
  List<Plant> plants = List.empty(growable: true);
  for (final plant in await _openData("plants.json")) {
    Plant plantModel = Plant.fromJson(plant);
    print(plantModel.name);
    plants.add(plantModel);
  }
  return plants;
}

Future<Plant?> getPlantById(String id) async {
  final data = await _openData("plants.json");
  final result = data.firstWhere((u) => u["_id"] == id);
  return Plant.fromJson(result);
}

Future<int> postPlant(Plant plant) async {
  final arr = await _openData("plants.json");
  arr.add(await plant.toJson());
  (await file("plants.json")).writeAsString(jsonEncode(arr));
  return 201;
}
