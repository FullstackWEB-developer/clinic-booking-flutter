import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../controllers/doctors_controller.dart';
import 'doctors_empty_list_widget.dart';
import 'doctors_list_item_widget.dart';
import 'doctors_list_loader_widget.dart';

class DoctorsListWidget extends GetView<DoctorsController> {
  DoctorsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>().isLoading(tasks: [
            'getClinicDoctors',
            'getClinicPopularDoctors',
            'getClinicMostRatedDoctors',
            'getClinicAvailableDoctors',
            'getClinicFeaturedDoctors'
          ]) &&
          controller.page == 1) {
        return ServicesListLoaderWidget();
      } else if (controller.doctors.isEmpty) {
        return DoctorsEmptyListWidget();
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.doctors.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.doctors.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _doctor = controller.doctors.elementAt(index);
              return DoctorsListItemWidget(doctor: _doctor);
            }
          }),
        );
      }
    });
  }
}
