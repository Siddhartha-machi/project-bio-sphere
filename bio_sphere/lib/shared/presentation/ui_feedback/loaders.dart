import 'package:flutter/material.dart';

class Loaders {
  static Widget spinner(Color color, {double width = 3, double size = 20}) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: width,
      ),
    );
  }

  static Widget appLoader(Color color, {double size = 30, double? width}) {
    final strokeWidth = width ?? (size * 0.05);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.square(
          dimension: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: strokeWidth,
          ),
        ),
        SizedBox.square(
          dimension: size * 0.7,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: strokeWidth,
          ),
        ),
      ],
    );
  }
}
