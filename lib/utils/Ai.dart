import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_pytorch_lite/flutter_pytorch_lite.dart';

class Ai {
  static const modelPath = 'assets/models/my_optimized_model.ptl';
  static const labelsPath = 'assets/json/new_names.json';

  final Int64List inputShape = Int64List.fromList([1, 3, 256, 256]);
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

  // inference still image
  Future<Map<String, double>> inferenceImage(ui.Image image) async {
    // input tensor
    Tensor inputTensor = await TensorImageUtils.imageToFloat32Tensor(
      image,
      width: inputShape[3],
      height: inputShape[2],
    );
    // Forward
    IValue input = IValue.from(inputTensor);
    IValue output = await mModule!.forward([input]);

    // output tensor
    Tensor outputTensor = output.toTensor();

    // Get output tensor
    final result = outputTensor.dataAsFloat32List;

    // probabilities
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
            // .map((e) => MapEntry(e.key, (e.value * 100).toInt() / 100))
            .toList();
    return Map.fromEntries(top5i);
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

  Future<List<dynamic>> getNames(ui.Image image) async
  {
    List<dynamic> pos = List<dynamic>.empty(growable: true);
    final result = await inferenceImage(image);
    result.forEach((key, value) 
    {
      List<dynamic> pos0 = labels?[key]["nomes_populares"];
      pos.addAll(pos0);
      });
    return pos;
  }

  Future<void> close() async {
    await mModule?.destroy();
  }

}
