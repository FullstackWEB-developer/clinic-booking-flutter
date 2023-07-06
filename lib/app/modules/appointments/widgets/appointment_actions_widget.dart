import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/appointment_controller.dart';

class AppointmentActionsWidget extends GetView<AppointmentController> {
  const AppointmentActionsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appointment = controller.appointment;
    return Obx(() {
      if (_appointment.value.status == null) {
        return SizedBox(height: 0);
      }
      if (_appointment.value.status.order == Get.find<GlobalService>().global.value.onTheWay) {
        return SizedBox(height: 0);
      } else {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (_appointment.value.status.order == Get.find<GlobalService>().global.value.done && _appointment.value.payment == null)
              Expanded(
                child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Go to Checkout".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 22)
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () {
                      Get.toNamed(Routes.CHECKOUT, arguments: _appointment.value);
                    }),
              ),
            if (_appointment.value.status.order == Get.find<GlobalService>().global.value.ready && _appointment.value.online)
              Expanded(
                  child: BlockButtonWidget(
                      text: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Join Online Consultation".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor),
                              ),
                            ),
                          ),
                          Icon(Icons.video_call_outlined, color: Get.theme.primaryColor, size: 24)
                        ],
                      ),
                      color: Get.theme.colorScheme.primary,
                      onPressed: () {
                        controller.joinMeeting();
                      })),
            if (_appointment.value.status.order == Get.find<GlobalService>().global.value.ready && !_appointment.value.online)
              Expanded(
                  child: BlockButtonWidget(
                      text: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Start".tr,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor),
                              ),
                            ),
                          ),
                          Icon(Icons.play_arrow, color: Get.theme.primaryColor, size: 24)
                        ],
                      ),
                      color: Get.theme.colorScheme.primary,
                      onPressed: () {
                        controller.startAppointment();
                      })),
            if (_appointment.value.status.order == Get.find<GlobalService>().global.value.inProgress && !_appointment.value.online)
              Expanded(
                child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Finish".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        Icon(Icons.stop, color: Get.theme.primaryColor, size: 24)
                      ],
                    ),
                    color: Get.theme.colorScheme.primary,
                    onPressed: () {
                      controller.finishAppointment();
                    }),
              ),
            if (_appointment.value.status.order >= Get.find<GlobalService>().global.value.done && _appointment.value.payment != null)
              Expanded(
                child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Leave a Review".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        Icon(Icons.star_outlined, color: Get.theme.primaryColor, size: 22)
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () {
                      Get.toNamed(Routes.RATING, arguments: _appointment.value);
                    }),
              ),
            SizedBox(width: 10),
            if (!_appointment.value.cancel && _appointment.value.status.order < Get.find<GlobalService>().global.value.onTheWay)
              MaterialButton(
                onPressed: () {
                  controller.cancelAppointment();
                },
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Cancel".tr, style: Get.textTheme.bodyText2),
                elevation: 0,
              ),
          ]).paddingSymmetric(vertical: 10, horizontal: 20),
        );
      }
    });
  }
}
