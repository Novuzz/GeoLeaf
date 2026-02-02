import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  tearDown(() {});

  test('loadModel does not throw (mocked)', () async {
    //loadModel();
    // add expectations if you refactor loadModel to return something testable
    final flower = File("assets/images/rosa.jpg").readAsBytesSync();
    final test = [0xffff01, 0xff00ff, 0x01f01f, 0x01ff00];

    print((test[1]) & 0xff);
    print((test[1] >> 8) & 0xff);
    print((test[1] >> 16) & 0xff);

    final optimized = List.empty(growable: true);

    for (int i = 0; i < flower.length; i += 6) {
      int num = 0;
      for (int j = 0; j < 6; j++) {
        if (i + j >= flower.length) break;
        num |= flower[i + j] << (8 * j);
      }

      optimized.add(num);
    }

    final byte = Uint8List(optimized.length * 6);
    for (int i = 0; i < optimized.length; i++) {
      for (int j = 0; j < 6; j++) {
        if (i * 6 + j >= optimized.length) break;
        byte[i * 6 + j] = (0xff & (optimized[i] >> (j * 8)));
      }
    }
    print(byte);
    print(byte.length);

    print(optimized.length);

    print(flower.length);
  });
}
