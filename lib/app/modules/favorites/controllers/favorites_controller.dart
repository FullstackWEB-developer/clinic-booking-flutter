import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/favorite_model.dart';
import '../../../repositories/doctor_repository.dart';

class FavoritesController extends GetxController {
  final favorites = <Favorite>[].obs;
  DoctorRepository _doctorRepository;

  FavoritesController() {
    _doctorRepository = new DoctorRepository();
  }

  @override
  void onInit() async {
    await refreshFavorites();
    super.onInit();
  }

  Future refreshFavorites({bool showMessage}) async {
    await getFavorites();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of Doctors refreshed successfully".tr));
    }
  }

  Future getFavorites() async {
    try {
      favorites.assignAll(await _doctorRepository.getFavorites());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
