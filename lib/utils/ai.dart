import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:flutter/services.dart';
//ignore_for_file:
import 'package:flutter_pytorch_lite/flutter_pytorch_lite.dart';

class Ai {
  static const modelPath = 'assets/models/my_optimized_model.ptl';
  static const labelsPath = 'assets/json/new_names.json';

  final Int64List inputShape = Int64List.fromList([1, 3, 224, 224]);
  final Int64List outputShape = Int64List.fromList([1, 1000]);
  Map<String, dynamic>? labels;
  List<String>? labelsList;
  Module? mModule;

  // Load model
  Future<void> _loadModel() async {
    final filePath = '${Directory.systemTemp.path}/my_optimized_model.ptl';
    File(filePath).writeAsBytesSync(await _getBuffer(modelPath));
    mModule = await FlutterPytorchLite.load(filePath);
    // mModule = await FlutterPytorchLite.load('notExistPath.ptl');

    print('Interpreter loaded successfully');
  }

  /// Get byte buffer
  static Future<Uint8List> _getBuffer(String assetFileName) async {
    ByteData rawAssetFile = await rootBundle.load(assetFileName);
    final rawBytes = rawAssetFile.buffer.asUint8List();
    return rawBytes;
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    if (labels == null) {
      final path = await rootBundle.loadString(labelsPath);
      final labelTxt = await jsonDecode(path) as Map<String, dynamic>;
      labels = labelTxt;
      labelsList = labels!.entries.map((entry) => entry.key).toList();
    }
  }

  Future<void> initHelper() async {
    await _loadLabels();
    await _loadModel();
  }

  // MobileNetV2 ImageNet normalization
  static const List<double> _mean = [0.485, 0.456, 0.406];
  static const List<double> _std = [0.229, 0.224, 0.225];

  // inference still image
  Future<Map<String, double>> inferenceImage(ui.Image image) async {
    // Convert image to float32 tensor with normalization
    Tensor inputTensor = await TensorImageUtils.imageToFloat32Tensor(
      image,
      width: inputShape[3].toInt(),
      height: inputShape[2].toInt(),
    );

    // Apply ImageNet normalization to the tensor data
    final tensorData = inputTensor.dataAsFloat32List.toList();
    for (int i = 0; i < tensorData.length; i++) {
      int channelIndex = (i ~/ (224 * 224)) % 3;
      tensorData[i] = (tensorData[i] - _mean[channelIndex]) / _std[channelIndex];
    }
    
    // Create IValue from normalized tensor
    IValue input = IValue.from(inputTensor);
    IValue output = await mModule!.forward([input]);

    // Get output tensor
    Tensor outputTensor = output.toTensor();
    final result = outputTensor.dataAsFloat32List;

    // Apply softmax for probabilities
    final prob = softmax(result);

    // Set classification map {label: points}
    var classification = <String, double>{};
    //print("Prob: ${prob.length}, Labels: ${labelsList.length}");
    for (var i = 0; i < labelsList!.length; i++) {
      if (prob[i] != 0) {
        // Set label: points
        classification[labelsList![i]] = prob[i];
      }
    }

    // top 5 indices
    final top5i =
        (classification.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)))
            .getRange(0, 5)
            //.map((e) => MapEntry(e.key, (e.value * 100).toInt() / 100))
            .toList();
    String probs = "";
    for (var elemnt in top5i) {
      probs += "(${elemnt.key}: ${(elemnt.value * 10000).truncate() / 100}%) ";
    }

    print("probs: $probs");
    return Map.fromEntries(top5i);
  }

  /// Normalize image data using ImageNet statistics
  /// Formula: (pixel / 255 - mean) / std
  List<double> _normalizeImageNet(List<double> data) {
    List<double> normalized = List<double>.empty(growable: true);
    
    // Process each pixel (assuming NCHW format: [batch, channels, height, width])
    // Data is already in 0-1 range from imageToFloat32Tensor
    for (int i = 0; i < data.length; i++) {
      int channelIndex = (i ~/ (224 * 224)) % 3; // Get channel (0, 1, or 2)
      double normalized_value = (data[i] - _mean[channelIndex]) / _std[channelIndex];
      normalized.add(normalized_value);
    }
    
    return normalized;
  }

  List<double> softmax(List<double> logits) {
    // Step 1: Compute the exponential of each element
    List<double> expValues = logits.map((x) => exp(x)).toList();

    // Step 2: Compute the sum of all exponentials
    double sumExpValues = expValues.reduce((a, b) => a + b);

    // Step 3: Normalize each value by the sum of exponentials
    List<double> probabilities = expValues
        .map((x) => x / sumExpValues)
        .toList();

    return probabilities;
  }

  Future<List<String>> getNames(ui.Image image) async {
    Set<String> uniqueNames = {};
    
    try {
      final result = await inferenceImage(image);
      
      result.forEach((label, confidence) {
        if (labels != null && labels!.containsKey(label)) {
          final labelData = labels![label];
          if (labelData is Map && labelData.containsKey('nomes_populares')) {
            List<dynamic> popularNames = labelData['nomes_populares'];
            for (var name in popularNames) {
              if (name is String) {
                uniqueNames.add(name);
              }
            }
          }
        }
      });
      
      return uniqueNames.toList();
    } catch (e) {
      print('Error getting names: $e');
      return [];
    }
  }

  Future<void> close() async {
    await mModule?.destroy();
  }
}
