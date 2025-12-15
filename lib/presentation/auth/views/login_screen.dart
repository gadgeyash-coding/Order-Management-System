import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_managment_system/core/utils/colors.dart';
import 'package:order_managment_system/core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/common_button.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  AppConstants.logoPath,

                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Text(
                    controller.isLoginMode.value
                        ? AppConstants.welcomeBack
                        : AppConstants.createAccount,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: controller.emailCtrl,
                  decoration: const InputDecoration(
                    labelText: AppConstants.email,
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => TextFormField(
                    controller: controller.passCtrl,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: AppConstants.password,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => controller.errorMsg.value.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.errorMsg.value,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => CommonButton(
                      text: controller.isLoginMode.value
                          ? AppConstants.login
                          : AppConstants.signUp,
                      loading: controller.isLoading.value,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.isLoginMode.value
                              ? controller.login()
                              : controller.signup();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.isLoginMode.value
                            ? AppConstants.doNotHaveAnAccount
                            : AppConstants.alreadyHaveAnAccount,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.isLoginMode.value =
                              !controller.isLoginMode.value;
                          controller.errorMsg('');
                        },
                        child: Text(
                          controller.isLoginMode.value
                              ? AppConstants.signUp
                              : AppConstants.login,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
