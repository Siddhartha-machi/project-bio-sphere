import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/models/widget_models/bread_crumb.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/presentation/components/bread_crumbs.dart';
import 'package:bio_sphere/shared/presentation/buttons/generic_icon_button.dart';

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
  final (double, double, double, double) padding;
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
    this.padding = (12, 12, 12, 12),
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
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final adapterFun = theme.brightness == Brightness.light
        ? Style.lighter
        : Style.darken;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary,
          primary,
          adapterFun(primary, 0.5),
          adapterFun(primary, 0.8),
        ],
        stops: const [0.0, 0.2, 0.6, 1.0],
      ),
    );
  }

  /// Handles the home/back button press.
  void _onHomePressed(BuildContext context) {
    /// TODO: create a util class for safe navigation.
    void Function(BuildContext) popFun = Navigator.of(context).pop;

    if (onHomePressed != null) {
      popFun = onHomePressed!;
    }

    if (context.canPop()) popFun(context);
  }

  /// Builds the custom app bar with gradient, title, breadcrumbs, and actions.
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: appBarActions,
      title: _buildTitle(context),
      toolbarHeight: kToolbarHeight + 12.sp,
      backgroundColor: Colors.transparent,
      leading: GenericIconButton(
        type: ButtonType.text,
        variant: ButtonVariant.secondary,
        icon: Icons.arrow_back_ios_new_sharp,
        onPressed: () => _onHomePressed(context),
      ),
    );
  }

  /// Builds the floating action button if [onAddPressed] is provided.
  Widget? _buildFAB() {
    if (onAddPressed != null) {
      return GenericIconButton(icon: Icons.add, onPressed: onAddPressed!);
    }
    return null;
  }

  /// Builds the main scaffold for the screen.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _gradientDecoration(context),

      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            padding.$1.sp,
            padding.$2.sp,
            padding.$3.sp,
            padding.$4.sp,
          ),
          child: child,
        ),
        appBar: _appBar(context),
        floatingActionButton: _buildFAB(),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
