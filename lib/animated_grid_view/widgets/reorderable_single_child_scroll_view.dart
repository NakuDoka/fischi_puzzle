import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/entities/reordable_entity.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/animated_draggable_item.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/draggable_item.dart';

/// Represents the copied children of a [Wrap] or [GridView] and displays them.
///
/// This widget builts all his children inside a [SingleChildScrollView] and positions
/// all children.
class ReorderableSingleChildScrollView extends StatelessWidget {
  final double height;
  final double width;
  final Clip clipBehavior;
  final ReorderableEntity reorderableEntity;
  final ScrollPhysics? physics;

  final Key? sizedBoxKey;

  const ReorderableSingleChildScrollView({
    required this.reorderableEntity,
    required this.height,
    required this.width,
    this.physics,
    this.clipBehavior = Clip.hardEdge,
    this.sizedBoxKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = reorderableEntity.children;
    return SingleChildScrollView(
      physics: physics,
      clipBehavior: clipBehavior,
      child: SizedBox(
        key: sizedBoxKey,
        height: height,
        width: width,
        child: Stack(
          clipBehavior: clipBehavior,
          children: reorderableEntity.idMap.entries
              .map(
                (e) => AnimatedDraggableItem(
                  key: children[e.value.orderId].key,
                  enableAnimation: true,
                  entry: e,
                  child: children[e.value.orderId],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
