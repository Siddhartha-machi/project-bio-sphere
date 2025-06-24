import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';

class _SnackBarNotifier {
  void success(BuildContext context, String message) {
    _show(
      context,
      message,
      Theme.of(context).colorScheme.primary,
      Icons.check_circle,
    );
  }

  void error(BuildContext context, String message) {
    _show(context, message, Theme.of(context).colorScheme.error, Icons.error);
  }

  void info(BuildContext context, String message) {
    _show(context, message, Colors.blue, Icons.info);
  }

  void _show(BuildContext context, String message, Color color, IconData icon) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    final snackBar = SnackBar(
      content: Row(
        spacing: 12.0,
        children: [
          Icon(icon, color: textColor),
          Expanded(child: Text(message)),
        ],
      ),
      showCloseIcon: true,
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(12),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class _DialogNotifier {
  Future<void> success(BuildContext context, String message) async {
    await _showDialog(
      context: context,
      title: 'Success!',
      message: message,
      icon: Icons.check_circle,
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }

  Future<void> error(BuildContext context, String message) async {
    _showDialog(
      context: context,
      title: 'Uh oh!',
      message: message,
      icon: Icons.error_sharp,
      variant: ButtonVariant.error,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }

  Future<void> info(BuildContext context, String message) async {
    _showDialog(
      context: context,
      title: 'Heads up!',
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue,
    );
  }

  Future<bool> confirm(
    BuildContext context,
    String message, {
    String? title,
  }) async {
    bool result = false;

    await _showDialog(
      context: context,
      message: message,
      icon: Icons.warning,
      cancelText: 'No, cancel',
      variant: ButtonVariant.error,
      onConfirm: () => result = true,
      onCancel: () => result = false,
      confirmText: 'Yes, I am sure',
      title: title ?? 'Are you sure?',
      iconColor: Theme.of(context).colorScheme.error,
    );

    return result;
  }

  /// Private methods
  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _showDialog({
    required String title,
    required IconData icon,
    required String message,
    required Color iconColor,
    required BuildContext context,

    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    String confirmText = 'Okay',
    String cancelText = 'Cancel',
    ButtonVariant variant = ButtonVariant.primary,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 18.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIcon(icon, iconColor),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  spacing: 8.0,
                  children: [
                    if (onCancel != null)
                      Expanded(
                        child: GenericButton(
                          fullwidth: true,
                          label: cancelText,
                          variant: variant,
                          type: ButtonType.outlined,
                          onPressed: () {
                            _closeDialog(dialogContext);
                            onCancel();
                          },
                        ),
                      ),
                    Expanded(
                      child: GenericButton(
                        fullwidth: true,
                        variant: variant,
                        label: confirmText,
                        onPressed: () {
                          onConfirm?.call();
                          _closeDialog(dialogContext);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class InAppFeedback {
  static final popups = _DialogNotifier();
  static final snackBars = _SnackBarNotifier();
}
