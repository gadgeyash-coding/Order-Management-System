import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order_managment_system/core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../domain/models/order_model.dart';

class OrderController extends GetxController {
  final OrderRepository repo = OrderRepository();

  var orders = <OrderModel>[].obs;
  var isLoading = true.obs;
  var selectedStatus = AppConstants.all.obs;
  var customerNameFilterCtrl = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  final customerNameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  var newStatus = AppConstants.orderStatuses[0].obs;

  late Stream<List<OrderModel>> stream;

  @override
  void onInit() {
    super.onInit();
    applyFilters();
  }

  void applyFilters() {
    isLoading(true);
    stream = repo.getOrders(
      status: selectedStatus.value == AppConstants.all
          ? null
          : selectedStatus.value,
      startDate: startDate,
      endDate: endDate,
      customerName: customerNameFilterCtrl.text.isEmpty
          ? null
          : customerNameFilterCtrl.text,
    );
    stream.listen((list) {
      orders.value = list;
      isLoading(false);
    });
  }

  Future<void> addOrder() async {
    try {
      final order = OrderModel(
        id: '',
        customerName: customerNameCtrl.text,
        status: newStatus.value,
        totalAmount: double.parse(amountCtrl.text),
        note: noteCtrl.text,
        createdAt: Timestamp.now(),
      );
      await repo.createOrder(order);
      Get.back();
      customerNameCtrl.clear();
      amountCtrl.clear();
      Get.snackbar(
        AppConstants.success,
        AppConstants.orderAdded,
        backgroundColor: AppColors.green,
      );
    } catch (e) {
      Get.snackbar(
        AppConstants.error,
        e.toString(),
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<void> updateOrder(OrderModel updatedOrder) async {
    await repo.updateOrder(updatedOrder);

    final index = orders.indexWhere((e) => e.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
      orders.refresh();
    }

    Get.snackbar(
      AppConstants.updated,
      AppConstants.orderUpdated,
      backgroundColor: AppColors.green,
    );
  }

  Future<void> deleteOrder(String id) async {
    await repo.deleteOrder(id);
    Get.snackbar(
      AppConstants.deleted,
      AppConstants.orderRemoved,
      backgroundColor: AppColors.error,
    );
  }

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      if (isStart) {
        startDate = date;
      } else {
        endDate = date;
      }
      applyFilters();
    }
  }

  void clearFilters() {
    selectedStatus(AppConstants.all);
    startDate = null;
    endDate = null;
    customerNameFilterCtrl.clear();
    applyFilters();
  }
}
