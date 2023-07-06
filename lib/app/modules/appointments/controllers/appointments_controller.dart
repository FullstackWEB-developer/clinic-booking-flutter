import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../../models/appointment_status_model.dart';
import '../../../repositories/appointment_repository.dart';
import '../../../services/global_service.dart';

class AppointmentsController extends GetxController {
  AppointmentRepository _appointmentsRepository;

  final appointments = <Appointment>[].obs;
  final appointmentStatuses = <AppointmentStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;

  ScrollController scrollController = ScrollController();

  AppointmentsController() {
    _appointmentsRepository = new AppointmentRepository();
  }

  @override
  Future<void> onInit() async {
    await getAppointmentStatuses();
    currentStatus.value = getStatusByOrder(1).id;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadAppointmentsOfStatus(statusId: currentStatus.value);
      }
    });
    super.onInit();
  }

  Future refreshAppointments({bool showMessage = false, String statusId}) async {
    changeTab(statusId);
    if (showMessage) {
      await getAppointmentStatuses();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Appointments page refreshed successfully".tr));
    }
  }

  void changeTab(String statusId) async {
    this.appointments.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadAppointmentsOfStatus(statusId: currentStatus.value);
  }

  Future getAppointmentStatuses() async {
    try {
      appointmentStatuses.assignAll(await _appointmentsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  AppointmentStatus getStatusByOrder(int order) => appointmentStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Appointment status not found".tr));
        return AppointmentStatus();
      });

  Future loadAppointmentsOfStatus({String statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Appointment> _appointments = [];
      if (appointmentStatuses.isNotEmpty) {
        _appointments = await _appointmentsRepository.all(statusId, page: page.value);
      }
      if (_appointments.isNotEmpty) {
        appointments.addAll(_appointments);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointmentService(Appointment appointment) async {
    try {
      if (appointment.status.order < Get.find<GlobalService>().global.value.onTheWay) {
        final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _appointment = new Appointment(id: appointment.id, cancel: true, status: _status);
        await _appointmentsRepository.update(_appointment);
        appointments.removeWhere((element) => element.id == appointment.id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
