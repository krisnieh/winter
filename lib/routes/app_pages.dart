import '../views/testing_line/testing_prepare_page.dart';
import '../controllers/testing_line/testing_prepare_controller.dart';
import '../bindings/testing_prepare_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/testing-prepare',
      page: () => const TestingPreparePage(),
      binding: TestingPrepareBinding(),
    ),
    // ... 其他路由
  ];
} 