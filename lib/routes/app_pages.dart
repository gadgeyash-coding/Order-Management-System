import 'package:get/get.dart';
import '../presentation/auth/bindings/auth_binding.dart';
import '../presentation/auth/views/login_screen.dart';
import '../presentation/auth/views/splash_screen.dart';
import '../presentation/orders/bindings/order_binding.dart';
import '../presentation/orders/views/order_list_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => SplashScreen(), binding: AuthBinding()),
    GetPage(name: AppRoutes.LOGIN, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(
      name: AppRoutes.ORDER_LIST,
      page: () => const OrderListScreen(),
      binding: OrderBinding(),
    ),
  ];
}