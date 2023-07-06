import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/patient_model.dart';
import '../../../repositories/patient_repository.dart';
import '../../../services/auth_service.dart';

class PatientsController extends GetxController {
  final patients = <Patient>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  ScrollController scrollController = ScrollController();
  PatientRepository _patientRepository;

  PatientsController() {
    _patientRepository = new PatientRepository();
  }

  @override
  void onInit() async {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        await getPatients(Get.find<AuthService>().user.value.id);
      }
    });
    super.onInit();
  }

  Future refreshPatients({bool showMessage = false}) async {
    this.patients.clear();
    page.value = 0;
    await getPatients(Get.find<AuthService>().user.value.id);
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Patients refreshed successfully".tr));
    }
  }

  Future getPatients(String UserID) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Patient> _patients = [];
      _patients = await _patientRepository.getWithUserId(UserID,page:page.value);
      if (_patients.isNotEmpty) {
        patients.addAll(_patients);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      isLoading.value = false;
    }
  }
}
