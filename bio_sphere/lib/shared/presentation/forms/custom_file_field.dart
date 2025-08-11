import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/services/file_service.dart';
import 'package:bio_sphere/models/data/attachment.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';
import 'package:bio_sphere/shared/presentation/ui_feedback/in_app_feedback.dart';

class CustomFileField extends StatelessWidget {
  final GenericFieldController<List<Attachment>> controller;

  const CustomFileField(this.controller, {super.key});

  ///
  List<Attachment> _data() => (controller.data ?? []);

  String _computeTotalFilesSize() {
    final sum = _data().fold(0.0, (prev, item) => prev + item.size);
    return Global.formatters.unit.bytes(sum.toInt(), precision: 2);
  }

  _onDeleteHandler(BuildContext ctx, Attachment item) async {
    if (await InAppFeedback.popups.confirm(
      ctx,
      'You want to delete the attachment ${item.name}',
    )) {
      if (item.url.isNotEmpty) {
        /// Deleting the saved item but depends on how we are saving the item.
      }
      // setState(() {
      //   _mutableDataState.removeWhere((i) => i.id == item.id);
      // });
    }
  }

  _onAddHandler(BuildContext ctx) async {
    final pickedFiles = await FileService.pickMultiple();

    if (pickedFiles.isNotEmpty) {
      final List<Attachment> newState = [];

      for (final pFile in pickedFiles) {
        if (pFile.error.isEmpty) {
          newState.add(
            Attachment(
              id: 'new_##_${pFile.config.name}',
              url: '',
              name: pFile.config.name,
              size: pFile.config.size.toDouble(),
              uploadDate: DateTime.now(),
            ),
          );
        } else if (ctx.mounted) {
          InAppFeedback.snackBars.error(ctx, pFile.error);
        }
      }

      /// Update the file list
      controller.didChange([...newState, ..._data()]);
    }
  }

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
    final item = _data()[index];
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
            GenericButton(
              isCircular: true,
              type: ButtonType.text,
              variant: ButtonVariant.error,
              prefixIcon: Icons.delete,
              onPressed: () => _onDeleteHandler(ctx, item),
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
    final data = _data();

    return SizedBox(
      height: 200,
      child: Column(
        spacing: 12.0,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: data.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      spacing: 6.0,
                      children: List.generate(
                        data.length,
                        (index) => _buildAttachmentItem(context, index),
                      ),
                    ),
                  )
                : _buildFallbackUI(context),
          ),
          Row(
            spacing: 12.0,
            children: [
              Expanded(
                child: TextUI(
                  'Total size : ${_computeTotalFilesSize()}',
                  level: TextLevel.bodyMedium,
                ),
              ),
              Expanded(
                child: GenericButton(
                  label: 'Add attachement',
                  onPressed: () => _onAddHandler(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
