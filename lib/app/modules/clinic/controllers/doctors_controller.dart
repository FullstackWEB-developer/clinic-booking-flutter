import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/clinic_model.dart';
import '../../../models/doctor_model.dart';
import '../../../repositories/clinic_repository.dart';

enum SpecialityFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class DoctorsController extends GetxController {
  final clinic = new Clinic().obs;
  final selected = Rx<SpecialityFilter>(SpecialityFilter.ALL);
  final doctors = <Doctor>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  ClinicRepository _clinicRepository;
  ScrollController scrollController = ScrollController();

  DoctorsController() {
    _clinicRepository = new ClinicRepository();
  }

  @override
  Future<void> onInit() async {
    clinic.value = Get.arguments as Clinic;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadDoctorsOfSpeciality(filter: selected.value);
      }
    });
    await refreshDoctors();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshDoctors({bool showMessage}) async {
    toggleSelected(selected.value);
    await loadDoctorsOfSpeciality(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of doctors refreshed successfully".tr));
    }
  }

  bool isSelected(SpecialityFilter filter) => selected == filter;

  void toggleSelected(SpecialityFilter filter) {
    this.doctors.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = SpecialityFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadDoctorsOfSpeciality({SpecialityFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Doctor> _doctors = [];
      switch (filter) {
        case SpecialityFilter.ALL:
          _doctors = await _clinicRepository.getDoctors(clinic.value.id, page: this.page.value);
          break;
        case SpecialityFilter.FEATURED:
          _doctors = await _clinicRepository.getFeaturedDoctors(clinic.value.id, page: this.page.value);
          break;
        case SpecialityFilter.POPULAR:
          _doctors = await _clinicRepository.getPopularDoctors(clinic.value.id, page: this.page.value);
          break;
        case SpecialityFilter.RATING:
          _doctors = await _clinicRepository.getMostRatedDoctors(clinic.value.id, page: this.page.value);
          break;
        case SpecialityFilter.AVAILABILITY:
          _doctors = await _clinicRepository.getAvailableDoctors(clinic.value.id, page: this.page.value);
          break;
        default:
          _doctors = await _clinicRepository.getDoctors(clinic.value.id, page: this.page.value);
      }
      if (_doctors.isNotEmpty) {
        this.doctors.addAll(_doctors);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
