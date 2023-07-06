import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../controllers/appointments_controller.dart';
import 'appointments_empty_list_widget.dart';
import 'appointments_list_item_widget.dart';
import 'appointments_list_loader_widget.dart';

class AppointmentsListWidget extends GetView<AppointmentsController> {
  AppointmentsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>().isLoading(task: 'getAppointments') && controller.page.value == 1) {
        return AppointmentsListLoaderWidget();
      } else if (controller.appointments.isEmpty) {
        return AppointmentsEmptyListWidget();
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.appointments.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.appointments.length) {
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
              var _appointment = controller.appointments.elementAt(index);
              return AppointmentsListItemWidget(appointment: _appointment);
            }
          }),
        );
      }
    });
  }
}
