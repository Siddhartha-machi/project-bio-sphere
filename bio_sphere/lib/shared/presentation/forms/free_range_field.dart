import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

// A form field widget for entering a numeric range (min/max).
class FreeRangeField extends StatefulWidget {
  final GenericFieldController<RangeValues> controller;

  const FreeRangeField(this.controller, {super.key});

  @override
  State<FreeRangeField> createState() => _FreeRangeFieldState();
}

class _FreeRangeFieldState extends State<FreeRangeField> {
  late final FocusNode _minFocus; // Focus node for min field
  late final FocusNode _maxFocus; // Focus node for max field
  late final TextEditingController _minController; // Controller for min field
  late final TextEditingController _maxController; // Controller for max field

  // Get the current range from the controller, default to (0, 0)
  RangeValues get _range => widget.controller.data ?? const RangeValues(0, 0);

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current values
    _minController = TextEditingController(
      text: _range.start.round().toString(),
    );
    _maxController = TextEditingController(text: _range.end.round().toString());

    _minFocus = FocusNode();
    _maxFocus = FocusNode();

    // Normalize min value when focus is lost
    _minFocus.addListener(() {
      if (!_minFocus.hasFocus) {
        _normalize(isMin: true, value: _minController.text);
      }
    });

    // Normalize max value when focus is lost
    _maxFocus.addListener(() {
      if (!_maxFocus.hasFocus) {
        _normalize(isMin: false, value: _maxController.text);
      }
    });

    // Listen for controller changes to sync UI
    widget.controller.addListener(_syncFromController);
  }

  // Get min/max limits from controller config
  (double, double) _getMinMax() {
    final extra = widget.controller.config.extra;

    return (extra['min'] ?? 0.0, extra['max'] ?? 100.0);
  }

  // Sync text fields with controller data
  void _syncFromController() {
    final minText = _range.start.round().toString();
    final maxText = _range.end.round().toString();

    if (_minController.text != minText) _minController.text = minText;
    if (_maxController.text != maxText) _maxController.text = maxText;

    setState(() {});
  }

  // Normalize and clamp input values, update controller if changed
  void _normalize({required bool isMin, required String? value}) {
    final (minLimit, maxLimit) = _getMinMax();
    final parsed = double.tryParse(value ?? '');

    if (parsed == null) {
      // Reset to current value if input is invalid
      final resetValue = isMin ? _range.start : _range.end;
      (isMin ? _minController : _maxController).text = resetValue
          .round()
          .toString();
      return;
    }

    final current = _range;
    late RangeValues newRange;

    if (isMin) {
      // Clamp min value between minLimit and current.end
      final clamped = parsed.clamp(minLimit, current.end);
      _minController.text = clamped.round().toString();
      newRange = RangeValues(clamped, current.end);
    } else {
      // Clamp max value between current.start and maxLimit
      final clamped = parsed.clamp(current.start, maxLimit);
      _maxController.text = clamped.round().toString();
      newRange = RangeValues(current.start, clamped);
    }

    // Update controller if range changed
    if (newRange != current) {
      widget.controller.didChange(newRange);
    }
  }

  // Build a styled text field for min/max input
  Widget _buildTextField({
    required String hint,
    required BuildContext context,
    required FocusNode focusNode,
    required TextEditingController controller,
  }) {
    final theme = Theme.of(context);
    final radius = Style.themeBorderRadius(context) - 1;

    return Expanded(
      child: SizedBox(
        height: 40.sp,
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.number,
          style: theme.textTheme.labelMedium,
          decoration: InputDecoration(
            prefixIcon: Container(
              width: 50.sp,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 5.sp),
              padding: EdgeInsets.only(left: 12.sp),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(radius),
                ),
              ),

              child: TextUI(
                hint,
                level: TextLevel.labelSmall,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    _minController.dispose();
    _maxController.dispose();
    _minFocus.dispose();
    _maxFocus.dispose();
    widget.controller.removeListener(_syncFromController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the min/max input fields in a row
    return Column(
      spacing: 12.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 12.sp,
          children: [
            _buildTextField(
              hint: 'Min',
              context: context,
              focusNode: _minFocus,
              controller: _minController,
            ),
            _buildTextField(
              hint: 'Max',
              context: context,
              focusNode: _maxFocus,
              controller: _maxController,
            ),
          ],
        ),
      ],
    );
  }
}
