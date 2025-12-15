import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/common_button.dart';
import '../../../domain/models/order_model.dart';
import '../controllers/order_controller.dart';

class EditOrderScreen extends GetView<OrderController> {
  final OrderModel order;

  EditOrderScreen({super.key, required this.order});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.customerNameCtrl.text = order.customerName;
    controller.amountCtrl.text = order.totalAmount.toString();
    controller.noteCtrl.text = order.note;
    controller.newStatus.value = order.status;

    return WillPopScope(
      onWillPop: () async {
        clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.editOrder),
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              clear();
              Get.back();
            },
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: controller.customerNameCtrl,
                    decoration: const InputDecoration(
                      labelText: AppConstants.customerNameLabel,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        Validators.required(v, AppConstants.customerNameLabel),
                  ),
                  const SizedBox(height: 16),

                  // AMOUNT
                  TextFormField(
                    controller: controller.amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: AppConstants.totalAmountLabel,
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.amount,
                  ),
                  const SizedBox(height: 16),

                  // NOTE
                  TextFormField(
                    controller: controller.noteCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: AppConstants.noteLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // STATUS
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: controller.newStatus.value,
                      items: AppConstants.orderStatuses
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) => controller.newStatus.value = v!,
                      decoration: const InputDecoration(
                        labelText: AppConstants.statusLabel,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // UPDATE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      text: AppConstants.updateOrder,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedOrder = order.copyWith(
                            status: controller.newStatus.value,
                            totalAmount: double.parse(
                              controller.amountCtrl.text,
                            ),
                            note: controller.noteCtrl.text,
                          );
                          controller.updateOrder(updatedOrder);
                          clear();
                          Get.back();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    controller.customerNameCtrl.clear();
    controller.amountCtrl.clear();
    controller.noteCtrl.clear();
  }
}
