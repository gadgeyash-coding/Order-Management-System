import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_managment_system/core/utils/constants.dart';
import '../../domain/models/order_model.dart';

class OrderRepository {
  final orders = FirebaseFirestore.instance.collection(AppConstants.orders);

  Stream<List<OrderModel>> getOrders({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? customerName,
  }) {
    Query query = orders.orderBy(AppConstants.createdAat, descending: true);

    if (status != null && status != AppConstants.all) {
      query = query.where(AppConstants.status, isEqualTo: status);
    }

    if (startDate != null) {
      query = query.where(
        AppConstants.createdAat,
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      final endOfDay = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );
      query = query.where(
        AppConstants.createdAat,
        isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
      );
    }

    if (customerName != null && customerName.trim().isNotEmpty) {
      query = query.where(
        AppConstants.customerName,
        isEqualTo: customerName.trim(),
      );
    }

    return query
        .snapshots()
        .handleError((error) {})
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => OrderModel.fromSnapshot(e)).toList(),
        );
  }

  Future<void> createOrder(OrderModel order) {
    return orders.add(order.toCreateMap());
  }

  Future<void> updateOrder(OrderModel order) {
    return orders.doc(order.id).update(order.toUpdateMap());
  }

  Future<void> deleteOrder(String id) {
    return orders.doc(id).delete();
  }
}
