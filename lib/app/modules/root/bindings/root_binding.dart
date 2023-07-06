import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../appointments/controllers/appointment_controller.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../patient/controllers/patients_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.put(HomeController(), permanent: true);
    Get.put(AppointmentsController(), permanent: true);

    Get.lazyPut<AppointmentController>(
      () => AppointmentController(),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
    Get.lazyPut<PatientsController>(
          () => PatientsController(),
    );
  }
}
