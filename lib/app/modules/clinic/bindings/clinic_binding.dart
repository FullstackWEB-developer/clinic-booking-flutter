import 'package:get/get.dart';

import '../../messages/controllers/messages_controller.dart';
import '../controllers/clinic_controller.dart';
import '../controllers/doctors_controller.dart';

class ClinicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicController>(
      () => ClinicController(),
    );
    Get.lazyPut<DoctorsController>(
      () => DoctorsController(),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
  }
}
