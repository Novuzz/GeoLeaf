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
  final response = await http.Client().get(url(url: "users?=$id"));
  if(response.statusCode == 200)
  {
    print(response.body);
    final json = jsonDecode(response.body);
    return User.fromJson(json[0]);
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

Future<List<Plant>> getPlants() async {
  final response = await http.Client().get(url(url: "plants"));
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);

    for(final plant in json)
    {
      final user =  plant['user'];
      plant['user'] = await getUsersById(user);
    }

    return List<Plant>.from(
      json.map((e) {
        return Plant.fromJson(e);
      }),
    );
  }
  return [];
}

Future<int> postPlant(Plant plant) async {
  final response = await http.Client().post(
    url(url: "plants"),
    body: plant.toJson(),
  );
  return response.statusCode;
}
