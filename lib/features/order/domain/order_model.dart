import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_status.dart';

part 'order_model.freezed.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String title,
    required String description,
    required double price,
    required String distance,
    required String startLocation,
    required String endLocation,
    required OrderStatus status,
    required DateTime createdAt,
  }) = _Order;
}