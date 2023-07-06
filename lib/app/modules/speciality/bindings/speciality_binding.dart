import 'package:get/get.dart';

import '../controllers/specialities_controller.dart';
import '../controllers/speciality_controller.dart';

class SpecialityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpecialityController>(
      () => SpecialityController(),
    );
    Get.lazyPut<SpecialitiesController>(
      () => SpecialitiesController(),
    );
  }
}
