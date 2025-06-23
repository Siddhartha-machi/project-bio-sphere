import 'package:flutter/material.dart';

class Loaders {
  static Widget spinner(Color color, {double width = 2}) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: width,
    );
  }
}
