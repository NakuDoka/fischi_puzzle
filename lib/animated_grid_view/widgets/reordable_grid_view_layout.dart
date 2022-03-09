import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:very_good_slide_puzzle/animated_grid_view/entities/reordable_type.dart';

abstract class ReorderableGridViewLayout extends StatelessWidget {
  const ReorderableGridViewLayout({
    required this.children,
    required this.reorderableType,
    required this.onReorder,
    this.enableAnimation = true,
    this.enableLongPress = true,
    this.enableReorder = true,
    this.longPressDelay = kLongPressTimeout,
    this.mainAxisSpacing = 0.0,
    this.clipBehavior = Clip.hardEdge,
    this.maxCrossAxisExtent = 0.0,
    this.crossAxisSpacing = 0.0,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
    this.childAspectRatio = 1.0,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.crossAxisCount,
    this.padding,
    this.dragChildBoxDecoration,
    Key? key,
  }) : super(key: key);

  @override
  final List<Widget> children;

  @override
  final bool enableAnimation;

  @override
  final bool enableLongPress;

  @override
  final Duration longPressDelay;

  @override
  final ReorderCallback onReorder;

  @override
  final ReorderableType reorderableType;

  @override
  final int? crossAxisCount;

  @override
  final double mainAxisSpacing;

  @override
  final ScrollPhysics? physics;

  @override
  final double maxCrossAxisExtent;

  @override
  final Clip clipBehavior;

  @override
  final double crossAxisSpacing;

  @override
  final SliverGridDelegate gridDelegate;

  @override
  final EdgeInsetsGeometry? padding;

  @override
  final double childAspectRatio;

  @override
  final BoxDecoration? dragChildBoxDecoration;

  @override
  final bool enableReorder;

  @override
  Widget build(BuildContext context);
}
