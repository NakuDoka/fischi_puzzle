import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/entities/grid_item_entity.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/draggable_item.dart';

/// This widget acts like a copy of the original child.
///
/// It's possible to disable the animation after changing the position.
/// Also when the child was added or will be removed, it's animated with a
/// fade in or out effect.
class AnimatedDraggableItem extends StatefulWidget {
  static const animationDuration = Duration(milliseconds: 300);

  final Widget child;
  final MapEntry<int, GridItemEntity> entry;
  final bool enableAnimation;

  final bool enabled;

  const AnimatedDraggableItem({
    required this.child,
    required this.entry,
    required this.enableAnimation,
    this.enabled = true,
    Key? key,
  })  : assert(key != null, 'Key of child was null. You need to add a unique key to the child!'),
        super(key: key);

  @override
  State<AnimatedDraggableItem> createState() => _AnimatedDraggableItemState();
}

class _AnimatedDraggableItemState extends State<AnimatedDraggableItem> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller); // Animation for the first time

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draggableItem = SizedBox(
      height: widget.entry.value.size.height,
      width: widget.entry.value.size.width,
      child: widget.child,
    );

    return AnimatedPositioned(
      duration: AnimatedDraggableItem.animationDuration,
      top: widget.entry.value.localPosition.dy,
      left: widget.entry.value.localPosition.dx,
      height: widget.entry.value.size.height,
      width: widget.entry.value.size.width,
      curve: Curves.easeInOutSine,
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(_animation),
        child: draggableItem,
      ),
    );
  }
}
