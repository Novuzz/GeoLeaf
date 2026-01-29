import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geo_leaf/models/User.dart';

class Plant {
  final String? id;
  final String name;
  final double longitude;
  final double latitude;
  final User? author;
  final Image? image;

  Plant({
    this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.author,
    required this.image
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json["_id"],
      name: json['name'],
      longitude: json['long'],
      latitude: json['lat'],
      author: json['author'],
      image: Image.memory( Uint8List.fromList((json['image'] as List<dynamic>).cast<int>()))
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "long": longitude.toString(),
      "lat": latitude.toString(),
      "user": author!.id
    };
  }
  Map<String, dynamic> toProperties() {
    return {
      "name": name,
      "long": longitude,
      "lat": latitude,
      "user": author?.id
    };
  }
}
