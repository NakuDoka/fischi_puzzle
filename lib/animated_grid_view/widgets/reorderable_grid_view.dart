import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/entities/reordable_type.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/reordable_grid_view_layout.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/reorderable.dart';

class ReorderableGridView extends ReorderableGridViewLayout {
  const ReorderableGridView.count({
    required List<Widget> children,
    required int crossAxisCount,
    required ReorderCallback onReorder,
    List<int> lockedChildren = const [],
    bool enableAnimation = true,
    bool enableLongPress = true,
    bool enableReorder = true,
    Duration longPressDelay = kLongPressTimeout,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsetsGeometry? padding,
    Clip clipBehavior = Clip.hardEdge,
    ScrollPhysics physics = const AlwaysScrollableScrollPhysics(),
    Key? key,
  }) : super(
          key: key,
          children: children,
          reorderableType: ReorderableType.gridViewCount,
          longPressDelay: longPressDelay,
          enableLongPress: enableLongPress,
          enableAnimation: enableAnimation,
          onReorder: onReorder,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          padding: padding,
          clipBehavior: clipBehavior,
          physics: physics,
          enableReorder: enableReorder,
        );

  @override
  Widget build(BuildContext context) {
    return Reorderable(
      reorderableType: reorderableType,
      children: children,
      onReorder: onReorder,
      enableAnimation: enableAnimation,
      enableLongPress: enableLongPress,
      longPressDelay: longPressDelay,
      clipBehavior: clipBehavior,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      physics: physics,
      maxCrossAxisExtent: maxCrossAxisExtent,
      crossAxisCount: crossAxisCount,
      gridDelegate: gridDelegate,
      padding: padding,
      childAspectRatio: childAspectRatio,
      dragChildBoxDecoration: dragChildBoxDecoration,
      enableReorder: enableReorder,
    );
  }
}
