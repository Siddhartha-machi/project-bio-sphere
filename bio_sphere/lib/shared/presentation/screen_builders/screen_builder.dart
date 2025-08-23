import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/models/widget_models/bread_crumb.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';
import 'package:bio_sphere/shared/presentation/components/bread_crumbs.dart';

/// A reusable screen scaffold widget with gradient app bar, breadcrumbs, and optional FAB.
///
/// [title] - The main title of the screen.
/// [child] - The main content widget.
/// [paths] - Optional breadcrumb path strings.
/// [onAddPressed] - Callback for FAB (add button).
/// [appBarActions] - Widgets for app bar actions.
/// [onHomePressed] - Custom callback for home/back button.
class ScreenBuilder extends StatelessWidget {
  final String title;
  final Widget child;
  final List<String>? paths;
  final VoidCallback? onAddPressed;
  final List<Widget> appBarActions;
  final void Function(BuildContext)? onHomePressed;

  /// Creates a [ScreenBuilder] widget.
  const ScreenBuilder({
    super.key,
    this.paths,
    this.onAddPressed,
    this.onHomePressed,
    required this.title,
    required this.child,
    this.appBarActions = const [],
  });

  /// Builds the title section with optional breadcrumbs.
  Widget _buildTitle(BuildContext context) {
    return Column(
      spacing: 3.sp,
      children: [
        TextUI(
          title,
          level: TextLevel.titleLarge,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        if (!Global.isEmptyList(paths))
          Breadcrumbs(crumbs: BreadCrumb.fromList(paths!), size: 13.sp),
      ],
    );
  }

  /// Returns a gradient decoration for the app bar background.
  Decoration _gradientDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Style.darken(Theme.of(context).primaryColor),
          Theme.of(context).primaryColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// Handles the home/back button press.
  void _onHomePressed(BuildContext context) {
    void Function(BuildContext) popFun = Navigator.of(context).pop;

    if (onHomePressed != null) {
      popFun = onHomePressed!;
    }

    popFun(context);
  }

  /// Builds the custom app bar with gradient, title, breadcrumbs, and actions.
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: appBarActions,
      title: _buildTitle(context),
      toolbarHeight: kToolbarHeight + 12.sp,
      leading: GenericButton(
        isCircular: true,
        type: ButtonType.text,
        variant: ButtonVariant.secondary,
        onPressed: () => _onHomePressed(context),
        prefixIcon: Icons.arrow_back_ios_new_sharp,
      ),
      flexibleSpace: Container(decoration: _gradientDecoration(context)),
    );
  }

  /// Builds the floating action button if [onAddPressed] is provided.
  Widget? _buildFAB() {
    if (onAddPressed != null) {
      return GenericButton(
        isCircular: true,
        onPressed: onAddPressed!,
        prefixIcon: Icons.add,
      );
    }
    return null;
  }

  /// Builds the main scaffold for the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: _appBar(context),
      floatingActionButton: _buildFAB(),
    );
  }
}
