import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/models/User.dart';

class Plant {
  final String? id;
  final String name;
  final double longitude;
  final double latitude;
  final User? author;
  final Image? image;
  final Uint8List? rawImage;
  final String? date;

  Plant({
    this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    this.rawImage,
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
      image: json['image'] != null
          ? Image.memory(base64Decode(json['image']))
          : null,
      date: json['created'],
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    String b64;
    if (rawImage == null) {
      ui.Image img = await TensorImageUtils.imageProviderToImage(image!.image);
      final u8 = await img.toByteData();
      Uint8List uint8list = u8!.buffer.asUint8List();
      b64 = base64Encode(uint8list);
    }
    b64 = base64Encode(rawImage!);

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
