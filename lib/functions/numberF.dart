import 'dart:typed_data';

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
