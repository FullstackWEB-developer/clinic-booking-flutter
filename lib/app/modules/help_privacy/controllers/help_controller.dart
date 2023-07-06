import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/faq_category_model.dart';
import '../../../models/faq_model.dart';
import '../../../repositories/faq_repository.dart';

class HelpController extends GetxController {
  FaqRepository _faqRepository;
  final faqSpecialities = <FaqCategory>[].obs;
  final faqs = <Faq>[].obs;

  HelpController() {
    _faqRepository = new FaqRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshFaqs();
    super.onInit();
  }

  Future refreshFaqs({bool showMessage, String specialityId}) async {
    getFaqSpecialities().then((value) async {
      await getFaqs(specialityId: specialityId);
    });
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  Future getFaqs({String specialityId}) async {
    try {
      if (specialityId == null) {
        faqs.assignAll(await _faqRepository.getFaqs(faqSpecialities.elementAt(0).id));
      } else {
        faqs.assignAll(await _faqRepository.getFaqs(specialityId));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFaqSpecialities() async {
    try {
      faqSpecialities.assignAll(await _faqRepository.getFaqSpecialities());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
