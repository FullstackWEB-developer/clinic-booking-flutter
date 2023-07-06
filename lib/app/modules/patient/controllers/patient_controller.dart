import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/patient_model.dart';
import '../../../repositories/patient_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';


class PatientController extends GetxController {
  final patient = Patient().obs;
  GlobalKey<FormState> patientForm ;
  final loading = false.obs;
  var selectedGender = "Male".obs;
  List<String> genders = ["Male","Female"];
  PatientRepository _patientRepository;

  PatientController() {
    _patientRepository = new PatientRepository();
  }

@override
  void onInit() {
    super.onInit();
  }

  List<DropdownMenuItem<String>> getSelectGenderItem() {
    return genders.map((element) {
      return DropdownMenuItem(
          value:element,
          child:Text(element)
      );
    }).toList();
  }

  void createPatientForm() async {
    Get.focusScope.unfocus();
    if (patientForm.currentState.validate()) {
      try {
        patientForm.currentState.save();
        loading.value = true;
        patient.value.user_id = Get.find<AuthService>().user.value.id;
        var _patient = await _patientRepository.create(patient.value);
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Patient saved successfully".tr));
        Get.find<RootController>().changePage(3);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void resetPatientForm() {
    patientForm.currentState.reset();
  }

  // Future<void> deletePatient(String PatientID) async {
  //   try {
  //     await _patientRepository.deletePatient(PatientID);
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
}
