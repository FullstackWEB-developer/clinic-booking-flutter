import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/appointment_repository.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';

class RatingController extends GetxController {
  final appointment = Appointment().obs;
  final doctorReview = new Review(rate: 0).obs;
  final clinicReview = new Review(rate: 0).obs;
  AppointmentRepository _appointmentRepository;

  RatingController() {
    _appointmentRepository = new AppointmentRepository();
  }

  @override
  void onInit() {
    appointment.value = Get.arguments as Appointment;
    doctorReview.value.user = Get.find<AuthService>().user.value;
    doctorReview.value.doctor = appointment.value.doctor;
    clinicReview.value.clinic = appointment.value.clinic;
    super.onInit();
  }

  Future addDoctorReview() async {
    try {
      if (doctorReview.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this doctor by clicking on the stars".tr));
        return;
      }
      if (doctorReview.value.review == null || doctorReview.value.review.isEmpty) {
        //Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this doctor".tr));
        return;
      }
      await _appointmentRepository.addDoctorReview(doctorReview.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
      Timer(Duration(seconds: 2), () {
        Get.find<RootController>().changePage(0);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future addClinicReview() async {
    try {
      if (clinicReview.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please rate this doctor by clicking on the stars".tr));
        return;
      }
      if (clinicReview.value.review == null || clinicReview.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Tell us somethings about this clinic".tr));
        return;
      }
      await _appointmentRepository.addClinicReview(clinicReview.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Thank you! your review has been added".tr));
      Timer(Duration(seconds: 2), () {
        Get.find<RootController>().changePage(0);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
