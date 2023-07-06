import 'package:get/get.dart';

import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/book_doctor_controller.dart';

class BookDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookDoctorController>(
      () => BookDoctorController(),
    );
  }
}
