import 'dart:ui' as ui;
import 'dart:typed_data';

class BilateralProcessor {
  /// Processes an image using a bilateral filter shader.
  static Future<Uint8List?> applyFilter({
    required ui.Image inputImage,
    double sigmaSpatial = 4.0,
    double sigmaRange = 0.15,
  }) async {
    // 1. Load the shader program from assets
    final program = await ui.FragmentProgram.fromAsset('shaders/bilateral.frag');
    final shader = program.fragmentShader();

    final int width = inputImage.width;
    final int height = inputImage.height;

    // 2. Set the uniforms (Must match the order in your .frag file)
    // uSize (vec2)
    shader.setFloat(0, width.toDouble());
    shader.setFloat(1, height.toDouble());
    // uSigmaSpatial (float)
    shader.setFloat(2, sigmaSpatial);
    // uSigmaRange (float)
    shader.setFloat(3, sigmaRange);
    // uTexture (sampler2D)
    shader.setImageSampler(0, inputImage);

    // 3. Create an off-screen recorder and canvas
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..shader = shader;

    // 4. Draw a rectangle covering the image area using the shader
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), 
      paint
    );

    // 5. Convert the drawing back into an image
    final picture = recorder.endRecording();
    final outputImage = await picture.toImage(width, height);

    // 6. Export as PNG bytes
    final byteData = await outputImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}