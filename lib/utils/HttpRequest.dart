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

Future<List<Plant>> getPlants() async {
  final response = await http.Client().get(url(url: "plants"));
  if(response.statusCode == 200)
  {
    final json = jsonDecode(response.body);
    return List<Plant>.from(json.map((e) =>  Plant.fromJson(e)));
  }
  return [];
}

Future<int> postPlant(Plant plant) async {
  final response = await http.Client().post(url(url: "plants"), body: plant.toJson());
  return response.statusCode;
}
