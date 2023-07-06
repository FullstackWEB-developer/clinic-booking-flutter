import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/doctor_model.dart';
import '../../../models/experience_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/message_model.dart';
import '../../../models/option_model.dart';
import '../../../models/review_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/doctor_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../favorites/controllers/favorites_controller.dart';

class DoctorController extends GetxController {
  final doctor = Doctor().obs;
  final reviews = <Review>[].obs;
  final experiences = <Experience>[].obs;
  final currentSlide = 0.obs;
  final heroTag = ''.obs;
  DoctorRepository _doctorRepository;

  DoctorController() {
    _doctorRepository = new DoctorRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    doctor.value = arguments['doctor'] as Doctor;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshDoctor();
    super.onReady();
  }

  Future refreshDoctor({bool showMessage = false}) async {
    await getDoctor();
    await getReviews();
    await getExperiences();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: doctor.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getDoctor() async {
    try {
      doctor.value = await _doctorRepository.get(doctor.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _doctorRepository.getReviews(doctor.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }


  Future getExperiences() async {
    try {
      experiences.assignAll(await _doctorRepository.getExperiences(doctor.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future addToFavorite() async {
    try {
      Favorite _favorite = new Favorite(
        doctor: this.doctor.value,
        userId: Get.find<AuthService>().user.value.id,
      );
      await _doctorRepository.addFavorite(_favorite);
      doctor.update((val) {
        val.isFavorite = true;
      });
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().refreshFavorites();
      }
      Get.showSnackbar(Ui.SuccessSnackBar(message: this.doctor.value.name + " Added to favorite list".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeFromFavorite() async {
    try {
      Favorite _favorite = new Favorite(
        doctor: this.doctor.value,
        userId: Get.find<AuthService>().user.value.id,
      );
      await _doctorRepository.removeFavorite(_favorite);
      doctor.update((val) {
        val.isFavorite = false;
      });
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().refreshFavorites();
      }
      Get.showSnackbar(Ui.SuccessSnackBar(message: this.doctor.value.name + " Removed from favorite list".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void startChat() {
    var _doctors = <User>[].obs;
    print(doctor.value.user);
    _doctors.add(doctor.value.user);
    Message _message = new Message(_doctors, name:  doctor.value.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
