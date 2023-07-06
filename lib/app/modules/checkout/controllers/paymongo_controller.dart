import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/appointment_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class PayMongoController extends GetxController {
  WebViewController webView;
  PaymentRepository _paymentRepository;
  final url = "".obs;
  final progress = 0.0.obs;
  final appointment = new Appointment().obs;

  PayMongoController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    appointment.value = Get.arguments['appointment'] as Appointment;
    getUrl();
    super.onInit();
  }

  void getUrl() {
    url.value = _paymentRepository.getPayMongoUrl(appointment.value);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}payments/paymongo";
    if (url == _doneUrl) {
      Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
      if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
        Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(50).id;
      }
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
