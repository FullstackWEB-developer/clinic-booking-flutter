import 'patients_list_item_widget.dart';
import 'patients_empty_list_widget.dart';
import 'patients_list_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/patients_controller.dart';

class PatientsListWidget extends GetView<PatientsController> {
  PatientsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if (Get.find<LaravelApiClient>().isLoading(task: 'getPatientsWithUserId')&& controller.page.value == 1) {
        return PatientsListLoaderWidget();
      } else if (controller.patients.isEmpty ) {
        return PatientsEmptyListWidget();
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.patients.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.patients.length) {
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
            }
            else {
              var _patient = controller.patients.elementAt(index);
              return PatientsListItemWidget(patient: _patient);
            }

          }),
        );
      }
    });

  }
}
