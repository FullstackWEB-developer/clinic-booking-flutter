import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/award_model.dart';
import '../../../models/clinic_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/experience_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/review_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/clinic_repository.dart';
import '../../../routes/app_routes.dart';

class ClinicController extends GetxController {
  final clinic = Clinic().obs;
  final reviews = <Review>[].obs;
  final awards = <Award>[].obs;
  final galleries = <Media>[].obs;
  final experiences = <Experience>[].obs;
  final featuredDoctors = <Doctor>[].obs;
  final currentSlide = 0.obs;
  String heroTag = "";
  ClinicRepository _clinicRepository;

  ClinicController() {
    _clinicRepository = new ClinicRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    clinic.value = arguments['clinic'] as Clinic;
    heroTag = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshClinic();
    super.onReady();
  }

  Future refreshClinic({bool showMessage = false}) async {
    await getClinic();
    await getFeaturedDoctors();
    await getAwards();
    //await getExperiences();
    await getGalleries();
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: clinic.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getClinic() async {
    try {
      clinic.value = await _clinicRepository.get(clinic.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedDoctors() async {
    try {
      featuredDoctors.assignAll(await _clinicRepository.getFeaturedDoctors(clinic.value.id, page: 1));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _clinicRepository.getReviews(clinic.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAwards() async {
    try {
      awards.assignAll(await _clinicRepository.getAwards(clinic.value.id));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  // Future getExperiences() async {
  //   try {
  //     experiences.assignAll(await _clinicRepository.getExperiences(clinic.value.id));
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future getGalleries() async {
    try {
      final _galleries = await _clinicRepository.getGalleries(clinic.value.id);
      galleries.assignAll(_galleries.map((e) {
        e.image.name = e.description;
        return e.image;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void startChat() {
    List<User> _employees = clinic.value.employees.map((e) {
      e.avatar = clinic.value.images[0];
      return e;
    }).toList();
    Message _message = new Message(_employees, name: clinic.value.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
