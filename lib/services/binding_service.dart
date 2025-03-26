import 'package:get/get.dart';
import 'package:shri_amareshwar_mahadev/controllers/auth_controller.dart';
import 'package:shri_amareshwar_mahadev/controllers/language_controller.dart';
import 'package:shri_amareshwar_mahadev/services/api_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  }
}
