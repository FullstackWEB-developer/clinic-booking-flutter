import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/book_doctor_controller.dart';
import '../widgets/payment_details_widget.dart';

class AppointmentSummaryView extends GetView<BookDoctorController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Appointment Summary".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBottomWidget(controller.appointment.value),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Appointment At".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(controller.appointment.value.appointmentAt)}', style: Get.textTheme.bodyText2),
                              Text('${DateFormat('HH:mm', Get.locale.toString()).format(controller.appointment.value.appointmentAt)}', style: Get.textTheme.bodyText2),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Patient".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.group_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                                controller.appointment.value.patient.first_name,
                                style: Get.textTheme.bodyText2
                              // textAlign: TextAlign.end,
                            ),
                            SizedBox(width: 3,),
                            Text(
                                controller.appointment.value.patient.last_name,
                                style: Get.textTheme.bodyText2
                              // textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Doctor".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.assignment_ind_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                          child:Text(controller.appointment.value.doctor.name, style: Get.textTheme
                              .bodyText2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: Ui.getBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.appointment.value.clinic.name, style: Get.textTheme.bodyText1),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.place_outlined, color: Get.theme.focusColor),
                        SizedBox(width: 15),
                        Expanded(
                          child: Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                (controller.appointment.value.clinic.address != null)
                                    ? Text(controller.appointment.value.clinic.address.address, style: Get.textTheme.bodyText2)
                                    : Text("Unknown Address".tr, style: Get.textTheme.bodyText2),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Obx((){
              if(controller.appointment.value.online) return SizedBox();
              else {
                return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: Ui.getBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Address".tr, style: Get.textTheme.bodyText1),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.place_outlined, color: Get.theme.focusColor),
                        SizedBox(width: 15),
                        Expanded(
                          child: Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                (controller.appointment.value.address != null)
                                    ? Text(controller.appointment.value.address?.address, style: Get.textTheme.subtitle2)
                                    : Text("Your Appointment at The Clinic Address.".tr, style: Get.textTheme.bodyText2),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              );}

            }),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("A Hint for the Doctor".tr, style: Get.textTheme.bodyText1),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.description_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(controller.appointment.value.hint ?? "".tr, style: Get.textTheme.bodyText2);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildBottomWidget(Appointment _appointment) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(appointment: _appointment),
          Obx(() {
            return BlockButtonWidget(
                text: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Confirm the Appointment".tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline6.merge(
                          TextStyle(color: Get.theme.primaryColor),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
                  ],
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed: Get.find<LaravelApiClient>().isLoading(task: "addAppointment")
                    ? null
                    : () {
                        controller.createAppointment();
                      });
          }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
