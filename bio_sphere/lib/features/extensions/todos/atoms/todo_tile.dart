import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/utils/misc/date_utils.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/features/extensions/todos/models/todo.dart';
import 'package:bio_sphere/shared/presentation/components/ui_chip.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile(this.todo, {super.key});

  Widget _buildPriorityChip(int priority) {
    Color color;
    String text;

    switch (priority) {
      case 0:
        text = 'Very Low';
        color = Colors.green;
      case 1:
        text = 'Low';
        color = Colors.blue;
      case 2:
        text = 'Medium';
        color = Colors.orange;
      default:
        text = 'High';
        color = Colors.red;
    }

    return UIChip(label: text, icon: Icons.flag, color: color);
  }

  Widget _buildDueDateChip(DateTime due) {
    String text;
    Color color = Colors.green;

    if (DTUtility.isAfter(DateTime.now(), due)) {
      final daysPassed = DTUtility.daysPassed(due);

      if (daysPassed > 0) {
        text = '$daysPassed days past due';
      } else {
        text = 'Due today';
      }

      color = Colors.red;
    } else {
      final fDate = Global.formatters.dateTime.formattedDate(
        due,
        includeTime: false,
      );
      text = 'Due $fDate';
    }

    return UIChip(label: text, color: color, icon: Icons.access_time_outlined);
  }

  @override
  Widget build(BuildContext context) {
    final radius = Style.themeBorderRadius(context);

    return GestureDetector(
      onLongPressStart: (details) {
        // Get the tap position
        final tapPosition = details.globalPosition;

        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            tapPosition.dx,
            tapPosition.dy,
            tapPosition.dx,
            tapPosition.dy,
          ),
          items: [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ).then((selectedValue) {
          if (selectedValue != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Selected: $selectedValue")));
          }
        });
      },

      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 12.sp),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(radius.sp),
          // gradient: LinearGradient(
          //   colors: [
          //     Theme.of(context).colorScheme.primary.withAlpha(25),
          //     Theme.of(context).colorScheme.primary.withAlpha(10),
          //   ],
          // ),
          border: Border.all(
            color: Theme.of(context).disabledColor.withAlpha(20),
          ),
        ),
        child: Column(
          spacing: 8.sp,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextUI(todo.title, level: TextLevel.labelMedium),

            if (!Global.isEmptyString(todo.description))
              TextUI(todo.description!, level: TextLevel.bodySmall),

            const SizedBox.shrink(),

            Wrap(
              spacing: 12.sp,
              runSpacing: 6.sp,
              children: [
                _buildPriorityChip(todo.priority),

                UIChip(label: 'Recurring', icon: Icons.repeat),

                if (todo.dueDate != null) _buildDueDateChip(todo.dueDate!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
