import 'dart:math';

class MathUtils {
  static double logWithBase(num number, {int base = 10}) {
    return log(number) / log(base);
  }

  static double power(num base, num exponent) {
    return pow(base, exponent).toDouble();
  }
}
