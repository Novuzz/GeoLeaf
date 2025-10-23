import 'dart:math';

double easeInCirc(double x)
{
  return 1 - sqrt(1 - pow(x, 2));
}

double easeOutCubic(double x)
{
  return 1.0 - pow(1 - x, 3);
}

double sine(double x, [double t = 1.25])
{
  return min(sin(x * pi)*t, 1);
}