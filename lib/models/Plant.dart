import 'package:geo_leaf/models/User.dart';
import 'package:uuid/uuid.dart';

class Plant {
  final String id;
  final String name;
  final DateTime createdTime;
  final DateTime editedTime;
  final User? author;

  Plant({
    required this.name,
    required this.createdTime,
    required this.editedTime,
    required this.author,
  }) : id = Uuid().v4();

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'],
      createdTime: json['createdTime'],
      editedTime: json['editedTime'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "createdTime": createdTime,
      "editedTime": editedTime,
      "author": author,
    };
  }
  Map<String, dynamic> toProperties() {
    return {
      "id": id,
      "name": name,
      "createdTime": createdTime.toString(),
      "editedTime": editedTime.toString(),
      "author": author?.ra
    };
  }
}
