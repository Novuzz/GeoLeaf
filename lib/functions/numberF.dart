List<double> getCenter(List<dynamic> points) {
  double x = 0.0;
  double y = 0.0;
  int n = points.length;
  for (var p in points) {
    if(p is List)
    {
      x += (p[0] as double);
      y += (p[1] as double);

    }

    
  }
  x /= n;
  y /= n;
  return [x, y];
}
