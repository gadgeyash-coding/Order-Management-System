import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_managment_system/core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key}) {
    Future.delayed(const Duration(seconds: 3), () {
      final user = AuthRepository().currentUser;
      if (user != null) {
        Get.offAllNamed(AppRoutes.ORDER_LIST);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppConstants.logoPath, width: 150),
            const SizedBox(height: 30),
            const Text(
              AppConstants.appName,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.primary,),
          ],
        ),
      ),
    );
  }
}