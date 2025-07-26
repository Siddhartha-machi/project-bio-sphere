import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';

class CondensedText extends StatelessWidget {
  final String text;
  final int maxLength;
  final TextAlign align;
  final TextStyle? style;

  /// Only show tooltip if the text is actually truncated.
  final bool onlyIfTruncated;

  const CondensedText(
    this.text, {
    super.key,
    this.style,
    this.maxLength = 5,
    this.onlyIfTruncated = false,
    this.align = TextAlign.center,
  });

  String _condenseText(String text) {
    if (text.length <= maxLength) return text;
    final int head = (maxLength / 2).floor();
    final int tail = maxLength - head;
    return '${text.substring(0, head)}...${text.substring(text.length - tail)}';
  }

  void _assertParameters() {
    assert(maxLength >= 2, 'Text max length cannot be less than 2.');
  }

  @override
  Widget build(BuildContext context) {
    _assertParameters();

    final preview = _condenseText(text);
    final showTooltip = !onlyIfTruncated || (preview != text);

    final textWidget = TextUI(
      preview,
      align: align,
      color: style?.color,
      height: style?.height,
      fontSize: style?.fontSize,
      fontStyle: style?.fontStyle,
      fontWeight: style?.fontWeight,
      overflow: TextOverflow.ellipsis,
      letterSpacing: style?.letterSpacing,
    );

    return showTooltip ? Tooltip(message: text, child: textWidget) : textWidget;
  }
}
