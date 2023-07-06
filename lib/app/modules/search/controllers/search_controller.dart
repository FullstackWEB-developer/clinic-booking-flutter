import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/speciality_model.dart';
import '../../../models/doctor_model.dart';
import '../../../repositories/speciality_repository.dart';
import '../../../repositories/doctor_repository.dart';

class SearchController extends GetxController {
  final heroTag = "".obs;
  final specialities = <Speciality>[].obs;
  final selectedSpecialities = <String>[].obs;
  TextEditingController textEditingController;

  final doctors = <Doctor>[].obs;
  DoctorRepository _doctorRepository;
  SpecialityRepository _specialityRepository;

  SearchController() {
    _doctorRepository = new DoctorRepository();
    _specialityRepository = new SpecialityRepository();
    textEditingController = new TextEditingController();
  }

  @override
  void onInit() async {
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    await getSpecialities();
    await searchDoctors();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of doctors refreshed successfully".tr));
    }
  }

  Future searchDoctors({String keywords}) async {
    try {
      if (selectedSpecialities.isEmpty) {
        doctors.assignAll(await _doctorRepository.search(keywords, specialities.map((element) => element.id).toList()));
      } else {
        doctors.assignAll(await _doctorRepository.search(keywords, selectedSpecialities.toList()));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSpecialities() async {
    try {
      specialities.assignAll(await _specialityRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedSpeciality(Speciality speciality) {
    return selectedSpecialities.contains(speciality.id);
  }

  void toggleSpeciality(bool value, Speciality speciality) {
    if (value) {
      selectedSpecialities.add(speciality.id);
    } else {
      selectedSpecialities.removeWhere((element) => element == speciality.id);
    }
  }
}
