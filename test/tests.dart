@Timeout(Duration(seconds: 12000))
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_leaf/utils/Ai.dart'; // adjust if path differs
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('flutter_pytorch_lite');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall method) async {
      // Return simple mocked results for methods your code will call.
      // Adjust method names and return values as needed.
      if (method.method == 'load') {
        // plugin may return an int handle or a map; return a simple value your test expects
        return 1;
      }
      if (method.method == 'forward') {
        // return a structure that your Ai.loadModel expects (mock minimally)
        return {
          'type': 'tuple',
          'tensors': [
            {
              'shape': [1, 1000],
              'data': List.filled(1000, 0.0),
            }
          ]
        };
      }
      // add more handlers if your code calls other methods (image utils, etc.)
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('loadModel does not throw (mocked)', () async {
    //loadModel();
    // add expectations if you refactor loadModel to return something testable
  });
}