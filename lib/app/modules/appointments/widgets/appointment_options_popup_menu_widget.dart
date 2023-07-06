import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/appointment_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../controllers/appointments_controller.dart';

class AppointmentOptionsPopupMenuWidget extends GetView<AppointmentsController> {
  const AppointmentOptionsPopupMenuWidget({
    Key key,
    @required Appointment appointment,
  })  : _appointment = appointment,
        super(key: key);

  final Appointment _appointment;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (item) {
        switch (item) {
          case "cancel":
            {
              controller.cancelAppointmentService(_appointment);
            }
            break;
          case "view":
            {
              Get.toNamed(Routes.APPOINTMENT, arguments: _appointment);
            }
            break;
        }
      },
      itemBuilder: (context) {
        var list = <PopupMenuEntry<Object>>[];
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "ID #".tr + _appointment.id,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "View Details".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        if (!_appointment.cancel && _appointment.status.order < Get.find<GlobalService>().global.value.onTheWay) {
          list.add(PopupMenuDivider(
            height: 10,
          ));
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                  Text(
                    "Cancel".tr,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              value: "cancel",
            ),
          );
        }
        return list;
      },
      child: Icon(
        Icons.more_vert,
        color: Get.theme.hintColor,
      ),
    );
  }
}
