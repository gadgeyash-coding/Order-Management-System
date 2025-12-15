import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_managment_system/core/utils/constants.dart';

class OrderModel {
  final String id;
  final String customerName;
  final String status;
  final double totalAmount;
  final String note;
  final Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.status,
    required this.totalAmount,
    required this.note,
    required this.createdAt,
  });

  factory OrderModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return OrderModel(
      id: snap.id,
      customerName: data[AppConstants.customerName] ?? '',
      status: data[AppConstants.status] ?? AppConstants.pending,
      totalAmount: (data[AppConstants.totalAmount] ?? 0).toDouble(),
      note: data[AppConstants.note] ?? '',
      createdAt: data[AppConstants.createdAat] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      AppConstants.customerName  : customerName,
      AppConstants.status: status,
      AppConstants.totalAmount: totalAmount,
      AppConstants.note: note,
      AppConstants.createdAat: FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      AppConstants.status: status,
      AppConstants.totalAmount: totalAmount,
      AppConstants.note: note,
    };
  }

  OrderModel copyWith({
    String? status,
    double? totalAmount,
    String? note,
  }) {
    return OrderModel(
      id: id,
      customerName: customerName,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }
}
