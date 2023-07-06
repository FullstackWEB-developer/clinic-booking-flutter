import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/clinic_model.dart';
import '../../../models/speciality_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/clinic_repository.dart';
import '../../../repositories/speciality_repository.dart';
import '../../../repositories/doctor_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  SliderRepository _sliderRepo;
  SpecialityRepository _specialityRepository;
  DoctorRepository _doctorRepository;
  ClinicRepository _clinicRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final clinics = <Clinic>[].obs;
  final doctors = <Doctor>[].obs;
  final specialities = <Speciality>[].obs;
  final featured = <Speciality>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _specialityRepository = new SpecialityRepository();
    _doctorRepository = new DoctorRepository();
    _clinicRepository = new ClinicRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    await getSlider();
    await getSpecialities();
    await getFeatured();
    await getRecommendedDoctors();
    await getRecommendedClinics();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
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

  Future getFeatured() async {
    try {
      featured.assignAll(await _specialityRepository.getFeatured());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedDoctors() async {
    try {
      doctors.assignAll(await _doctorRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future getRecommendedClinics() async {
    try {
      clinics.assignAll(await _clinicRepository.getRecommended());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
