import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/utils/misc/math_utils.dart';

class ChartUtils {
  static double getScaledMaxY(double maxValue) {
    /// Returns a visually appropriate max Y value that is a clean multiple
    /// of 5 or 10 based on the input maxValue.
    ///
    /// Example:
    /// - Input: 87 → Output: 100
    /// - Input: 6 → Output: 10
    /// - Input: 0 → Output: 5

    if (maxValue <= 0) return 5;

    // Calculate order of magnitude
    final log10 = MathUtils.logWithBase(maxValue, base: 10);
    final magnitude = MathUtils.power(10, log10.floor());

    // Calculate base-scaled value (e.g., round up to nearest multiple of 5 or 10)
    double rawScale = ((maxValue / magnitude).ceil()) * magnitude;

    // Round to nearest multiple of 5 or 10
    if (rawScale <= 10) {
      return ((rawScale / 5).ceil()) * 5;
    } else {
      return ((rawScale / 10).ceil()) * 10;
    }
  }

  static String formatValue(double value, ChartUnits units) {
    final encodedNum = Global.formatters.number.condense(value);

    switch (units) {
      case ChartUnits.percentage:
        return '${value.toStringAsFixed(0)}%';
      case ChartUnits.currency:
        return '\$$encodedNum';
      default:
        return value.toStringAsFixed(0);
    }
  }
}
