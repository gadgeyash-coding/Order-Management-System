import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_managment_system/core/utils/colors.dart';
import 'package:order_managment_system/core/utils/constants.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository repo = AuthRepository();

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  var isLoading = false.obs;
  var errorMsg = ''.obs;
  var isPasswordVisible = false.obs;
  var isLoginMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    repo.authState().listen((user) {
      if (user != null) Get.offAllNamed(AppRoutes.ORDER_LIST);
    });
  }

  Future<void> login() async {
    isLoading(true);
    errorMsg('');

    try {
      await repo.signIn(emailCtrl.text.trim(), passCtrl.text);
      Get.offAllNamed(AppRoutes.ORDER_LIST);
      Get.snackbar(
        AppConstants.success,
        AppConstants.loggedInSuccessfully,
        backgroundColor: AppColors.green,
      );
    } on FirebaseAuthException catch (e) {
      String msg = AppConstants.invalidEmailPassword;

      if (e.code == AppConstants.invalidCredential ||
          e.code == AppConstants.wrongPassword ||
          e.code == AppConstants.invalidEmail) {
        msg = AppConstants.invalidEmailPasswordCheck;
      } else if (e.code == AppConstants.userNotFound) {
        msg = AppConstants.userNotFoundPleaseCreate;
      } else if (e.code == AppConstants.tooManyRequests) {
        msg = AppConstants.tooManyAttempts;
      } else {
        msg = AppConstants.loginFailed;
      }

      errorMsg(msg);
      Get.snackbar(
        AppConstants.loginError,
        msg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> signup() async {
    isLoading(true);
    errorMsg('');

    try {
      await repo.createUser(emailCtrl.text.trim(), passCtrl.text);
      Get.offAllNamed(AppRoutes.ORDER_LIST);
      Get.snackbar(
        AppConstants.success,
        AppConstants.createdSuccessfully,
        backgroundColor: AppColors.green,
      );
    } on FirebaseAuthException catch (e) {
      String msg = AppConstants.signupFailed;
      switch (e.code) {
        case AppConstants.emailAlreadyInUse:
          msg = AppConstants.emailAlreadyExist;
          break;
        case AppConstants.weakPassword:
          msg = AppConstants.passwordTooWeak;
          break;
        case AppConstants.invalidEmail:
          msg = AppConstants.invalidEmailFormat;
          break;
        default:
          msg = AppConstants.anErrorOccurred;
      }
      errorMsg(msg);
      Get.snackbar(
        AppConstants.error,
        msg,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> logout() async {
    await repo.signOut();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
