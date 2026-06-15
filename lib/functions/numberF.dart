import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

List<double> getCenter(List<dynamic> points) {
  double x = 0.0;
  double y = 0.0;
  int n = points.length;
  for (var p in points) {
    if (p is List) {
      x += (p[0] as double);
      y += (p[1] as double);
    }
  }
  x /= n;
  y /= n;
  return [x, y];
}

//Essa função converte um vetor de 8 bits para um de 64, por motivos de memória no banco de dados
List<int> compress8bit(Uint8List list) {
  List<int> optimized = List.empty(growable: true);

  for (int i = 0; i < list.length; i += 6) {
    int num = 0;
    for (int j = 0; j < 6; j++) {
      if (i + j >= list.length) break;
      num |= list[i + j] << (8 * j);
    }

    optimized.add(num);
  }
  return optimized;
}

/*
*/
Uint8List decompress64bit(List<int> list) {
  final byte = Uint8List(list.length * 6 - 2);
  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < 6; j++) {
      if (i * 3 + j >= list.length) break;
      byte[i * 3 + j] = (list[i] & (0xff >> (j * 8)));
    }
  }
  return byte;
}
img.Image applyBilateralFilter(img.Image src, double sigmaSpace, double sigmaColor) {
  final int width = src.width;
  final int height = src.height;
  final img.Image dest = img.Image.from(src);
  final int radius = (sigmaSpace * 3).ceil();

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      double sumR = 0, sumG = 0, sumB = 0, sumW = 0;
      final pixel = src.getPixel(x, y);

      for (int ky = -radius; ky <= radius; ky++) {
        for (int kx = -radius; kx <= radius; kx++) {
          int nx = x + kx;
          int ny = y + ky;

          if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
            final neighbor = src.getPixel(nx, ny);
            
            // 1. Spatial weight (Gaussian)
            double distSq = (kx * kx + ky * ky).toDouble();
            double weightSpace = exp(-distSq / (2 * sigmaSpace * sigmaSpace));

            // 2. Range weight (Color similarity)
            num colorDistSq = pow(pixel.r - neighbor.r, 2) + 
                                pow(pixel.g - neighbor.g, 2) + 
                                pow(pixel.b - neighbor.b, 2);
            double weightColor = exp(-colorDistSq / (2 * sigmaColor * sigmaColor));

            double weight = weightSpace * weightColor;
            sumR += neighbor.r * weight;
            sumG += neighbor.g * weight;
            sumB += neighbor.b * weight;
            sumW += weight;
          }
        }
      }
      dest.setPixel(x, y, img.ColorRgb8((sumR / sumW).round(), (sumG / sumW).round(), (sumB / sumW).round()));
    }
  }
  return dest;
}
