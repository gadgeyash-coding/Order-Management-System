import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/common_button.dart';
import '../controllers/order_controller.dart';

class AddOrderScreen extends GetView<OrderController> {
  AddOrderScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.addNewOrder),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
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
                TextFormField(
                  controller: controller.noteCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: AppConstants.noteLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.newStatus.value,
                    items: AppConstants.orderStatuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => controller.newStatus.value = v!,
                    decoration: const InputDecoration(
                      labelText: AppConstants.statusLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CommonButton(
                    text: AppConstants.addOrder,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.addOrder();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
