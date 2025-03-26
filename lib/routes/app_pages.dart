import 'package:get/get.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/customer/add_customer_screen.dart';
import '../screens/customer/customer_list_screen.dart';
import '../screens/customer/customer_details_screen.dart';
import '../screens/splash/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.addCustomer,
      page: () => const AddCustomerScreen(),
    ),
    GetPage(
      name: Routes.customerList,
      page: () => const CustomerListScreen(),
    ),
    GetPage(
      name: Routes.customerDetails,
      page: () => const CustomerDetailsScreen(),
    ),
  ];
} 