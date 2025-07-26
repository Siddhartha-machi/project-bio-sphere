import 'package:flutter/material.dart';

class GenericListView<D, W extends Widget> extends StatelessWidget {
  const GenericListView({
    super.key,
    this.title,
    this.gap = 12,
    this.itemSize,
    required this.data,
    required this.builder,

    /// Avoid shrinkWrap: true for large lists.
    this.shrinkWrap = false,
    this.direction = Axis.vertical,
    this.padding = const EdgeInsetsGeometry.all(0),
  });

  final double gap;
  final List<D> data;
  final String? title;
  final Axis direction;
  final bool shrinkWrap;
  final double? itemSize;
  final W Function(D) builder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: data.length,
      shrinkWrap: shrinkWrap,
      scrollDirection: direction,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox.square(dimension: gap),
      itemBuilder: (ctx, index) => itemSize != null
          ? SizedBox(
              height: direction == Axis.vertical ? itemSize : null,
              width: direction == Axis.horizontal ? itemSize : null,
              child: builder(data[index]),
            )
          : builder(data[index]),
    );
  }
}
