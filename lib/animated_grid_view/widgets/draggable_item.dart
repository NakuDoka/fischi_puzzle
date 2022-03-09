import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef OnCreatedFunction = Function(
  BuildContext context,
  GlobalKey key,
  int orderId,
  Widget child,
);

typedef OnDragUpdateFunction = Function(
  int dragOrderId,
  Offset position,
  Size size,
);

class DraggableItem extends StatefulWidget {
  final Widget child;
  final int orderId;
  final bool enableLongPress;

  final Duration longPressDelay;
  final bool enabled;

  final BoxDecoration? dragBoxDecoration;
  final OnCreatedFunction? onCreated;
  final OnDragUpdateFunction? onDragUpdate;

  const DraggableItem({
    required this.child,
    required this.orderId,
    required this.enableLongPress,
    this.longPressDelay = kLongPressTimeout,
    this.enabled = true,
    this.dragBoxDecoration,
    this.onCreated,
    this.onDragUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<DraggableItem> createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> with TickerProviderStateMixin {
  late final DecorationTween _decorationTween;
  late final AnimationController _controller;

  final _globalKey = GlobalKey();
  final _dragKey = GlobalKey();
  final _defaultBoxDecoration = BoxDecoration(
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 6,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    final beginDragBoxDecoration = widget.dragBoxDecoration?.copyWith(
      color: Colors.transparent,
      boxShadow: [],
    );

    _decorationTween = DecorationTween(
      begin: beginDragBoxDecoration ?? const BoxDecoration(),
      end: widget.dragBoxDecoration ?? _defaultBoxDecoration,
    );

    // called only one time
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.onCreated != null) {
        widget.onCreated!(context, _globalKey, widget.orderId, widget.child);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      key: _globalKey,
      child: widget.child,
    );

    if (!widget.enabled) {
      return child;
    }

    final feedback = Material(
      key: _dragKey,
      color: Colors.transparent,
      child: DecoratedBoxTransition(
        position: DecorationPosition.background,
        decoration: _decorationTween.animate(_controller),
        child: widget.child,
      ),
    );

    return child;
  }
}
