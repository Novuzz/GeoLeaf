import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_leaf/models/User.dart';
import 'package:image/image.dart' as img;
import 'package:geo_leaf/functions/numberF.dart';

class Plant {
  final String? id;
  final String name;
  final double longitude;
  final double latitude;
  final User? author;
  final Image? image;
  final String? date;

  Plant({
    this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    this.author,
    this.image,
    this.date,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json["_id"],
      name: json['name'],
      longitude: json['long'],
      latitude: json['lat'],
      author: json['author'],
      image: Image.memory(base64Decode(json['image'])),
      date: json['created'],
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    img.Image? imager = img.decodeImage(
      File("assets/icon.png").readAsBytesSync(),
    );
    img.Image resized = img.copyResize(imager!, width: 64, height: 64);
    final u8 = File(
      "assets/images/dahlias.jpg",
    ).readAsBytesSync(); //resized.buffer.asUint8List();
    final b64 = base64Encode(u8);
    final str = String.fromCharCodes(u8);
    List<int> u32 = compress8bit(u8);
    return {
      "name": name,
      "long": longitude.toString(),
      "lat": latitude.toString(),
      "user": author!.id,
      "image": b64,
    };
  }

  Map<String, dynamic> toProperties() {
    return {
      "name": name,
      "long": longitude,
      "lat": latitude,
      "user": author?.id,
    };
  }
}
