import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:order_managment_system/core/utils/colors.dart';

import '../../../core/utils/constants.dart';
import '../../../core/widgets/shimmer_order_list.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/order_controller.dart';
import 'add_order_screen.dart';
import 'edit_order_screen.dart';

class OrderListScreen extends GetView<OrderController> {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.ordersTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const ShimmerOrderList();
              }

              if (controller.orders.isEmpty) {
                return const Center(child: Text(AppConstants.noOrdersFound));
              }

              return RefreshIndicator(
                onRefresh: () async => controller.applyFilters(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, i) {
                    final order = controller.orders[i];

                    final shortId = order.id.length > 10
                        ? '${order.id.substring(0, 10)}...'
                        : order.id;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ORDER DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppConstants.orderId}: $shortId',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${AppConstants.customer}: ${order.customerName}',
                                  ),
                                  const SizedBox(height: 4),
                                  Chip(
                                    label: Text(order.status),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppConstants.amount}: ₹${order.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (order.note.isNotEmpty)
                                    Text(
                                      '${AppConstants.noteLabel} : ${order.note}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${AppConstants.date}: ${DateFormat(AppConstants.ddmmyyyy).format(order.createdAt.toDate())}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    Get.to(() => EditOrderScreen(order: order));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: AppConstants.deleted,
                                      middleText:
                                          AppConstants.deleteConfirmation,
                                      textConfirm: AppConstants.delete,
                                      textCancel: AppConstants.cancel,
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        controller.deleteOrder(order.id);
                                        Get.back();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddOrderScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedStatus.value,
                items: [AppConstants.all, ...AppConstants.orderStatuses]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  controller.selectedStatus.value = v!;
                  controller.applyFilters();
                },
              ),
            ),
            const SizedBox(width: 12),

            SizedBox(
              width: 150,
              child: TextField(
                controller: controller.customerNameFilterCtrl,
                decoration: const InputDecoration(
                  labelText: AppConstants.customerNameLabel,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => controller.applyFilters(),
              ),
            ),
            const SizedBox(width: 12),

            // START DATE PICKER
            ElevatedButton(
              onPressed: () => controller.pickDate(context, true),
              child: Text(
                controller.startDate == null
                    ? AppConstants.startDate
                    : DateFormat(
                        AppConstants.ddmmyyyySlash,
                      ).format(controller.startDate!),
              ),
            ),
            const SizedBox(width: 12),

            // END DATE PICKER
            ElevatedButton(
              onPressed: () => controller.pickDate(context, false),
              child: Text(
                controller.endDate == null
                    ? AppConstants.endDate
                    : DateFormat(
                        AppConstants.ddmmyyyySlash,
                      ).format(controller.endDate!),
              ),
            ),
            const SizedBox(width: 12),

            // CLEAR BUTTON
            ElevatedButton(
              onPressed: controller.clearFilters,
              child: const Text(AppConstants.clear),
            ),
          ],
        ),
      ),
    );
  }
}
