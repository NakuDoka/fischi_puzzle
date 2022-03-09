import 'package:flutter/cupertino.dart';

// ignore: public_member_api_docs
class GridItemEntity {
  final Offset localPosition;
  final Size size;
  final int orderId;

  // ignore: public_member_api_docs
  const GridItemEntity({
    required this.localPosition,
    required this.size,
    required this.orderId,
  });

  GridItemEntity copyWith({
    Offset? localPosition,
    int? orderId,
    Size? size,
  }) =>
      GridItemEntity(
        localPosition: localPosition ?? this.localPosition,
        size: size ?? this.size,
        orderId: orderId ?? this.orderId,
      );
}
