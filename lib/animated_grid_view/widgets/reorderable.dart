import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/entities/grid_item_entity.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/entities/reordable_entity.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/entities/reordable_type.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/draggable_item.dart';
import 'package:very_good_slide_puzzle/animated_grid_view/widgets/reorderable_single_child_scroll_view.dart';

/// Ordering [children] in a [Wrap] that can be drag and dropped.
///
/// Simple way of drag and drop [children] that were built inside a [Wrap].
///
/// To enable the possibility of the drag and drop, it's important to build
/// all [children] inside a [Wrap]. After that every child is added to the
/// entity [GridItemEntity] that contains the position and orderId of the build
/// item.
/// When all items are added to new map animatedChildren, the widget is
/// reconstructing the wrap inside a [Container]. This [Container] has the same
/// size as the [Wrap]. Inside the [Container], all children are rebuild with a
/// [Positioned] widget.
/// At the end, the same widget is build without a [Wrap] but now it's possible
/// to update the positions of the widgets with a drag and drop.
///
/// A list of [children] that are build inside a [Wrap].
///
/// Using [spacing] adds a space in vertical direction between [children].
/// The default value is 8.
///
/// Using [runSpacing] adds a space in horizontal direction between [children].
/// The default value is 8.
///
/// [enableAnimation] is enabling the animation of changing the positions of
/// [children] after drag and drop. The default value is true.
///
/// With [enableLongPress] you can decide if the user needs a long press to move
/// the item around. The default value is true.
///
/// [onReorder] always give you the old and new index of the moved children.
/// Make sure to update your list of children that you used to display your data.
/// See more on the example.
class Reorderable extends StatefulWidget {
  const Reorderable({
    required this.children,
    required this.reorderableType,
    this.lockedChildren = const [],
    this.spacing = 8.0,
    this.runSpacing = 8.0,
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
    this.crossAxisCount,
    this.physics,
    this.padding,
    this.dragChildBoxDecoration,
    Key? key,
    required ReorderCallback onReorder,
  }) : super(key: key);

  ///
  /// Default Parameter
  ///
  @override
  final List<Widget> children;

  @override
  final List<int> lockedChildren;

  @override
  final bool enableAnimation;

  @override
  final bool enableLongPress;

  @override
  final Duration longPressDelay;

  ///
  /// Wrap
  ///
  @override
  final double spacing;

  @override
  final double runSpacing;

  ///
  /// GridView
  ///
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

  ///
  /// Other
  ///
  @override
  final ReorderableType reorderableType;

  @override
  final BoxDecoration? dragChildBoxDecoration;

  @override
  final bool enableReorder;

  @override
  State<Reorderable> createState() => _ReorderableState();
}

class _ReorderableState extends State<Reorderable> with WidgetsBindingObserver {
  var _reorderableEntity = ReorderableEntity.create();
  final _removedReorderableEntity = ReorderableEntity.create();
  var _proxyReorderableEntity = ReorderableEntity.create();

  /// Bool to know if all children were build and updated.
  bool hasBuiltItems = false;

  /// Key of the [Wrap] or [GridView] that was used to build the widget
  final _reorderableKey = GlobalKey();

  /// Important for detecting the correct position of the dragged child inside Content
  final _reorderableContentKey = GlobalKey();

  /// Size of the [Wrap] that was used to build the widget
  Size _wrapSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _updateWrapSize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Reorderable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // childrenCopy has to get an update
    if (oldWidget.children != widget.children) {
      // resetting maps to built all children correctly when children size changes
      if (oldWidget.children.length != widget.children.length) {
        setState(() {
          _proxyReorderableEntity = _proxyReorderableEntity.copyWith(idMap: {});
          hasBuiltItems = false;
          if (widget.children.isEmpty) {
            _reorderableEntity.clear();
          }
        });
      } else {
        setState(() {
          _reorderableEntity.children = List<Widget>.from(widget.children);
        });
      }
    }
  }

  @override
  void didChangeMetrics() {
    final orientationBefore = MediaQuery.of(context).orientation;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final orientationAfter = MediaQuery.of(context).orientation;
      if (orientationBefore != orientationAfter) {
        setState(() {
          hasBuiltItems = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (!widget.enableReorder)
          Opacity(
            opacity: 1,
            child: ReorderableSingleChildScrollView(
              reorderableEntity: _reorderableEntity,
              sizedBoxKey: _reorderableContentKey,
              physics: widget.physics,
              height: _wrapSize.height,
              width: _wrapSize.width,
              clipBehavior: widget.clipBehavior,
            ),
          ),
        if (!widget.enableReorder)
          Opacity(
            opacity: 0,
            child: ReorderableSingleChildScrollView(
              reorderableEntity: _removedReorderableEntity,
              height: _wrapSize.height,
              width: _wrapSize.width,
              clipBehavior: widget.clipBehavior,
            ),
          ),
        Builder(
          builder: (context) {
            if (!widget.enableReorder) {
              final generatedChildren = List.generate(
                widget.children.length,
                (index) => Opacity(
                  opacity: 0,
                  child: DraggableItem(
                    child: widget.children[index],
                    enableLongPress: widget.enableLongPress,
                    orderId: index,
                    enabled: false,
                    onCreated: _handleCreated,
                  ),
                ),
              );
              return _getReorderableWidget(children: generatedChildren);
            }
            // after all children are added to animatedChildren
            else {
              return const SingleChildScrollView();
            }
          },
        ),
      ],
    );
  }

  Widget _getReorderableWidget({required List<Widget> children}) {
    return SingleChildScrollView(
      child: GridView.count(
        key: _reorderableKey,
        shrinkWrap: true,
        crossAxisCount: widget.crossAxisCount!,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        children: children,
        clipBehavior: widget.clipBehavior,
        padding: widget.padding,
      ),
    );
  }

  /// Looking for the current size of the [Wrap] and updates it.
  void _updateWrapSize() {
    final wrapBox = _reorderableKey.currentContext!.findRenderObject()! as RenderBox;
    _wrapSize = wrapBox.size;
  }

  /// Creates [GridItemEntity] that contains all information for this widget.
  ///
  /// There are two different ways when a child was created.
  ///
  /// One would be that it already exists and was just updated, e. g. after an
  /// orientation change. Then the existing child gets an update in terms of
  /// position.
  ///
  /// If the item does not exist, then a new [GridItemEntity] is created.
  /// That includes the size and position (global and locally inside [Wrap]
  /// of the widget. Also an id and orderId is added that are important to
  /// know where the item is ordered and to identify the original item
  /// after changing the position.
  void _handleCreated(
    BuildContext context,
    GlobalKey key,
    int orderId,
    Widget child,
  ) {
    final renderObject = key.currentContext?.findRenderObject();

    if (renderObject != null) {
      final wrapBox = _reorderableKey.currentContext!.findRenderObject()! as RenderBox;
      final _wrapPosition = wrapBox.localToGlobal(Offset.zero);

      final box = renderObject as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;

      final localPosition = Offset(
        position.dx - _wrapPosition.dx,
        position.dy - _wrapPosition.dy,
      );

      final proxyIdMap = _proxyReorderableEntity.idMap;
      // in this case id is equal to orderId and _childrenOrderIdMap must be used
      MapEntry<int, GridItemEntity>? existingEntry;
      for (final entry in proxyIdMap.entries) {
        if (entry.value.orderId == orderId) {
          existingEntry = entry;
          break;
        }
      }

      // if exists update position related to the orderId
      if (existingEntry != null) {
        final updatedGridItemEntity = existingEntry.value.copyWith(
          localPosition: localPosition,
          size: size,
        );
        proxyIdMap[existingEntry.key] = updatedGridItemEntity;

        // finished building all entries
        if (orderId == proxyIdMap.entries.length - 1) {
          _updateWrapSize();
          setState(() {
            hasBuiltItems = true;
          });
        }
      } else {
        final gridItemEntity = GridItemEntity(
          localPosition: localPosition,
          size: size,
          orderId: orderId,
        );
        proxyIdMap[orderId] = gridItemEntity;

        // checking if all widgets were built in proxy map
        if (proxyIdMap.length == widget.children.length) {
          // that means that at least one child were removed
          if (proxyIdMap.length < _reorderableEntity.idMap.length) {}
          _updateWrapSize();

          setState(() {
            hasBuiltItems = true;
            _reorderableEntity = _reorderableEntity.copyWith(
              children: List<Widget>.from(widget.children),
              idMap: proxyIdMap,
            );
          });
        }
      }
    }
  }

  /// Searching for removed children and updates [_removedChildrenMap].
  ///
  /// Compares [_childrenIdMapProxy] that represents all new children and
  /// [_childrenIdMap] that represents the children before the update. When one
  /// child in [_childrenIdMapProxy] wasn't found, then that means it was removed.

}
