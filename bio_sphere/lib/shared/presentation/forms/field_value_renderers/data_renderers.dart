import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/models/data/attachment.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/utils/adapters/field_meta.dart';
import 'package:bio_sphere/shared/utils/adapters/value_coercers.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_icon_button.dart';

/// --------------- Base Render class definition --------------- ///

abstract class BaseFieldRenderer<T> extends StatelessWidget {
  final T data;
  final GenericFieldConfig config;

  const BaseFieldRenderer({
    super.key,
    required this.data,
    required this.config,
  });
}

/// --------------- Generic data renderer --------------- ///

class GenericDataRenderer extends BaseFieldRenderer {
  const GenericDataRenderer({
    super.key,
    required super.data,
    required super.config,
  });

  dynamic _coercedValue() {
    final coercer = ValueCoercer.withDefaults();

    return coercer.coerce(
      data,
      CoercionContext(
        type: config.type,
        meta: FieldMeta(extra: {'config': config}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic cleanedValue = _coercedValue();

    if (cleanedValue == null) return FieldValueFallback(config: config);

    switch (config.type) {
      case GenericFieldType.checkbox:
        return BooleanFieldRenderer(data: cleanedValue, config: config);
      case GenericFieldType.date:
      case GenericFieldType.time:
      case GenericFieldType.dateTime:
        return DateFieldRenderer(data: cleanedValue, config: config);
      case GenericFieldType.radio:
      case GenericFieldType.select:
      case GenericFieldType.dropdown:
        return OptionFieldRenderer(data: cleanedValue, config: config);
      case GenericFieldType.url:
        return URLFieldRenderer(data: cleanedValue, config: config);
      case GenericFieldType.file:
        return FileFiledRenderer(data: cleanedValue, config: config);
      default:
        break;
    }

    if (cleanedValue is! String) cleanedValue = cleanedValue.toString();

    return TextUI(cleanedValue, level: TextLevel.bodySmall);
  }
}

/// --------------- Text & primitive data renderer --------------- ///

class TextFieldRenderer extends BaseFieldRenderer<String> {
  const TextFieldRenderer({
    super.key,
    required super.data,
    required super.config,
  });

  @override
  Widget build(BuildContext context) {
    String finalRenderValue = data;

    if (config.type == GenericFieldType.password) {
      finalRenderValue = '* * * * * * * * * * *';
    }

    return TextUI(finalRenderValue, level: TextLevel.bodySmall);
  }
}

/// --------------- URL/Uri data renderer --------------- ///

class URLFieldRenderer extends BaseFieldRenderer<Uri> {
  const URLFieldRenderer({
    super.key,
    required super.data,
    required super.config,
  });

  Future<void> _handleURLClick() async {
    /// TODO add logic to open the link
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextUI(data.origin, level: TextLevel.bodySmall)),
        GenericIconButton(
          type: ButtonType.text,
          onPressed: _handleURLClick,
          icon: FontAwesome.link_solid,
        ),
      ],
    );
  }
}

/// --------------- GenericFieldOption data renderer --------------- ///

class OptionFieldRenderer extends BaseFieldRenderer<GenericFieldOption> {
  const OptionFieldRenderer({
    super.key,
    required super.data,
    required super.config,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withAlpha(180);

    return Row(
      spacing: 8.sp,
      children: [
        if (data.iconConfig != null)
          Icon(
            color: color,
            size: 16.sp,
            FontAwesomeIconData(data.iconConfig!),
          ),
        Column(
          spacing: 10.sp,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextUI(
              data.label,
              color: color,
              align: TextAlign.start,
              level: TextLevel.bodySmall,
            ),

            if (!Global.isEmptyString(data.description))
              TextUI(
                data.description!,
                align: TextAlign.start,
                level: TextLevel.bodySmall,
                color: color.withAlpha(180),
              ),
          ],
        ),
      ],
    );
  }
}

/// --------------- Boolean renderer --------------- ///

class BooleanFieldRenderer extends BaseFieldRenderer<bool> {
  const BooleanFieldRenderer({
    super.key,
    required super.data,
    required super.config,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = 18.sp;

    return Row(
      spacing: 12.sp,
      children: [
        if (!Global.isEmptyString(config.hintText))
          Expanded(
            child: TextUI(config.hintText!, level: TextLevel.labelSmall),
          ),

        data
            ? Icon(
                size: iconSize,
                FontAwesome.circle_check_solid,
                color: Theme.of(context).primaryColor,
              )
            : Icon(
                size: iconSize,
                FontAwesome.circle_xmark_solid,
                color: Theme.of(context).colorScheme.error,
              ),
      ],
    );
  }
}

/// --------------- DateTime & Time data renderer --------------- ///
class DateFieldRenderer extends BaseFieldRenderer<DateTime> {
  const DateFieldRenderer({
    super.key,
    required super.data,
    required super.config,
  });

  String _buildDateTimeValue(dynamic dateTime) {
    String formattedValue;

    if (config.type == GenericFieldType.time) {
      formattedValue = Global.formatters.dateTime.formattedTime(dateTime);
    } else {
      formattedValue = Global.formatters.dateTime.formattedDate(
        dateTime,
        includeTime: config.type == GenericFieldType.dateTime,
      );
    }

    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    final renderValue = _buildDateTimeValue(data);

    return TextUI(renderValue, level: TextLevel.bodySmall);
  }
}

/// --------------- File data renderer --------------- ///
class FileFiledRenderer extends BaseFieldRenderer<List<Attachment>> {
  final Function(BuildContext, Attachment)? onDeleteHandler;

  const FileFiledRenderer({
    super.key,
    required super.data,
    this.onDeleteHandler,
    required super.config,
  });

  Widget _buildAttachmentIcon(String name) {
    final Widget icon;
    final fExt = name.split('.').last.toLowerCase();

    switch (fExt) {
      case 'pdf':
        icon = Brand(Brands.adobe_acrobat_reader);
        break;
      case 'png':
      case 'jpg':
      case 'jpeg':
        icon = const Icon(Bootstrap.images, color: Colors.green);
        break;
      case 'doc':
      case 'docx':
        icon = Brand(Brands.microsoft_word);
        break;
      case 'ppt':
      case 'pptx':
        icon = Brand(Brands.microsoft_powerpoint);
        break;
      case 'xls':
      case 'xlsx':
        icon = Brand(Brands.microsoft_excel);
        break;
      case 'json':
        icon = const Icon(FontAwesome.file_code, color: Colors.green);
        break;
      default:
        icon = const Icon(FontAwesome.notdef_solid, color: Colors.blue);
    }

    return SizedBox(width: 30, height: 30, child: icon);
  }

  Widget _buildAttachmentItem(BuildContext ctx, int index) {
    final item = data[index];

    return Container(
      key: ValueKey(item.id),
      padding: EdgeInsets.fromLTRB(8.sp, 6.sp, 0.sp, 6.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.sp),
        border: Border.all(
          color: Theme.of(ctx).colorScheme.onSurface.withAlpha(80),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: Row(
          spacing: 12.0,
          children: [
            _buildAttachmentIcon(item.name),
            Expanded(
              child: Column(
                spacing: 2.0.sp,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUI(item.name, level: TextLevel.labelSmall),
                  TextUI(
                    level: TextLevel.caption,
                    Global.formatters.unit.bytes(item.size.toInt()),
                  ),
                ],
              ),
            ),
            if (onDeleteHandler != null)
              GenericIconButton(
                icon: Icons.delete,
                type: ButtonType.text,
                variant: ButtonVariant.error,
                onPressed: () => onDeleteHandler!(ctx, item),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackUI(BuildContext ctx) {
    final color = Theme.of(ctx).disabledColor;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: color, width: 0.5)),
      height: 150,
      child: Column(
        spacing: 12.sp,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TextUI('No attachments found!', level: TextLevel.bodyMedium),
          Icon(FontAwesome.folder_open_solid, size: 35.sp, color: color),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _buildFallbackUI(context);

    return SingleChildScrollView(
      child: Column(
        spacing: 6.0,
        children: List.generate(
          data.length,
          (index) => _buildAttachmentItem(context, index),
        ),
      ),
    );
  }
}

/// --------------- Data fallback renderer --------------- ///
class FieldValueFallback extends StatelessWidget {
  final GenericFieldConfig config;

  const FieldValueFallback({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return TextUI('- Not filled', level: TextLevel.caption);
  }
}
