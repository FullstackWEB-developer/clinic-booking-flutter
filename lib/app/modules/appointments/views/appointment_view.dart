import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/appointment_controller.dart';
import '../controllers/appointments_controller.dart';
import '../widgets/appointment_actions_widget.dart';
import '../widgets/appointment_row_widget.dart';
import '../widgets/appointment_til_widget.dart';
import '../widgets/appointment_title_bar_widget.dart';

class AppointmentView extends GetView<AppointmentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppointmentActionsWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshAppointment(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 370,
                elevation: 0,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () async {
                    Get.find<AppointmentsController>().refreshAppointments();
                    Get.back();
                  },
                ),
                bottom: buildAppointmentTitleBarWidget(controller.appointment),
                flexibleSpace: Obx(() {
                  if (controller.appointment.value.address == null)
                    return SizedBox();
                  else
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: MapsUtil.getStaticMaps(controller.appointment.value.address.getLatLng(), height: 600, size: '700x600', zoom: 14),
                    );
                }).marginOnly(bottom: 68),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx((){
                      if(controller.appointment.value.hasData){
                        return buildContactDoctor(controller.appointment);
                      }else{
                        return SizedBox();
                      }

                    }),
                    Obx(() {
                      if (controller.appointment.value.status == null)
                        return SizedBox();
                      else
                        return AppointmentTilWidget(
                          title: Text("Appointment Details".tr, style: Get.textTheme.subtitle2),
                          actions: [Text("#" + controller.appointment.value.id, style: Get.textTheme.subtitle2)],
                          content: Column(
                            children: [
                              AppointmentRowWidget(
                                  descriptionFlex: 1,
                                  valueFlex: 2,
                                  description: "Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.appointment.value.status.status,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              AppointmentRowWidget(
                                  descriptionFlex: 1,
                                  valueFlex: 2,
                                  description: "Type".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child:
                                          Obx(() {
                                            if(controller.appointment.value.online){
                                              return Text(
                                                "Online".tr,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: TextStyle(color: Get.theme.hintColor),
                                              );
                                            } else if(controller.appointment.value.canAppointmentAtClinic){
                                              return Text(
                                                "At Your Address".tr,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: TextStyle(color: Get.theme.hintColor),
                                              );
                                            } else{
                                              return Text(
                                                "At Clinic".tr,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: TextStyle(color: Get.theme.hintColor),
                                              );
                                            }
                                          }),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              AppointmentRowWidget(
                                  description: "Payment Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          color: Get.theme.focusColor.withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.appointment.value.payment?.paymentStatus?.status ?? "Not Paid".tr,
                                          style: TextStyle(color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              if (controller.appointment.value.payment?.paymentMethod != null)
                                AppointmentRowWidget(
                                    description: "Payment Method".tr,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            color: Get.theme.focusColor.withOpacity(0.1),
                                          ),
                                          child: Text(
                                            controller.appointment.value.payment?.paymentMethod?.getName(),
                                            style: TextStyle(color: Get.theme.hintColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    hasDivider: true),
                              AppointmentRowWidget(
                                description: "Hint".tr,
                                child: Ui.removeHtml(controller.appointment.value.hint, alignment: Alignment.centerRight, textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        );
                    }),
                    Obx(() {
                      if (controller.appointment.value.duration == null)
                        return SizedBox();
                      else
                        return AppointmentTilWidget(
                          title: Text("Appointment Date & Time".tr, style: Get.textTheme.subtitle2),
                          actions: [
                            Container(
                              padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Get.theme.focusColor.withOpacity(0.1),
                              ),
                              child: Obx(() {
                                return Text(
                                  controller.getTime(),
                                  style: Get.textTheme.bodyText2,
                                );
                              }),
                            )
                          ],
                          content: Obx(() {
                            return Column(
                              children: [
                                if (controller.appointment.value.appointmentAt != null)
                                  AppointmentRowWidget(
                                      description: "Appointment At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.appointment.value.appointmentAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: controller.appointment.value.startAt != null || controller.appointment.value.endsAt != null),
                                if (controller.appointment.value.startAt != null)
                                  AppointmentRowWidget(
                                      description: "Started At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.appointment.value.startAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: false),
                                if (controller.appointment.value.endsAt != null)
                                  AppointmentRowWidget(
                                    description: "Ended At".tr,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormat('d, MMMM y  HH:mm', Get.locale.toString()).format(controller.appointment.value.endsAt),
                                          style: Get.textTheme.caption,
                                          textAlign: TextAlign.end,
                                        )),
                                  ),
                              ],
                            );
                          }),
                        );
                    }),
                    Obx(() {
                      if (controller.appointment.value.doctor == null)
                        return SizedBox();
                      else
                        return AppointmentTilWidget(
                          title: Text("Pricing".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              AppointmentRowWidget(
                                  descriptionFlex: 2,
                                  valueFlex: 1,
                                  description: controller.appointment.value.doctor.name,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(controller.appointment.value.doctor.getPrice, style: Get.textTheme.subtitle2),
                                  ),
                                  hasDivider: true),
                                  // Column(
                                  //   children: List.generate(controller.appointment.value.options.length, (index) {
                                  //     var _option = controller.appointment.value.options.elementAt(index);
                                  //     return AppointmentRowWidget(
                                  //         descriptionFlex: 2,
                                  //         valueFlex: 1,
                                  //         description: _option.name,
                                  //         child: Align(
                                  //           alignment: Alignment.centerRight,
                                  //           child: Ui.getPrice(_option.price, style: Get.textTheme.bodyText1),
                                  //         ),
                                  //         hasDivider: (controller.appointment.value.options.length - 1) == index);
                                  //   }),
                                  // ),
                              Column(
                                children: List.generate(controller.appointment.value.taxes.length, (index) {
                                  var _tax = controller.appointment.value.taxes.elementAt(index);
                                  return AppointmentRowWidget(
                                      description: _tax.name,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: _tax.type == 'percent'
                                            ? Text(_tax.value.toString() + '%', style: Get.textTheme.bodyText1)
                                            : Ui.getPrice(
                                                _tax.value,
                                                style: Get.textTheme.bodyText1,
                                              ),
                                      ),
                                      hasDivider: (controller.appointment.value.taxes.length - 1) == index);
                                }),
                              ),
                              Obx(() {
                                return AppointmentRowWidget(
                                  description: "Tax Amount".tr,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(controller.appointment.value.getTaxesValue(), style: Get.textTheme.subtitle2),
                                  ),
                                  hasDivider: false,
                                );
                              }),
                              Obx(() {
                                return AppointmentRowWidget(
                                    description: "Subtotal".tr,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Ui.getPrice(controller.appointment.value.getSubtotal(), style: Get.textTheme.subtitle2),
                                    ),
                                    hasDivider: true);
                              }),
                              if ((controller.appointment.value.coupon?.discount ?? 0) > 0)
                                AppointmentRowWidget(
                                    description: "Coupon".tr,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Wrap(
                                        children: [
                                          Text(' - ', style: Get.textTheme.bodyText1),
                                          Ui.getPrice(controller.appointment.value.coupon.discount,
                                              style: Get.textTheme.bodyText1, unit: controller.appointment.value.coupon.discountType == 'percent' ? "%" : null),
                                        ],
                                      ),
                                    ),
                                    hasDivider: true),
                              Obx(() {
                                return AppointmentRowWidget(
                                  description: "Total Amount".tr,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Ui.getPrice(controller.appointment.value.getTotal(), style: Get.textTheme.headline6),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                    })
                  ],
                ),
              ),
            ],
          )),
    );
  }

  AppointmentTitleBarWidget buildAppointmentTitleBarWidget(Rx<Appointment> _appointment) {
    return AppointmentTitleBarWidget(
      title: Obx(() {
        return Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _appointment.value.doctor?.name ?? '',
                    style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Obx((){
                        return Row(
                          children: [
                            Text(
                              _appointment.value?.patient?.last_name ?? '',
                              style: Get.textTheme.bodyText1,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                            SizedBox(width: 3,),
                            Text(
                              _appointment.value?.patient?.first_name ?? '',
                              style: Get.textTheme.bodyText1,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        );
                      })

                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(_appointment.value?.address?.address ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodyText1),
                      ),
                    ],
                    // spacing: 8,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                ],
              ),
            ),
            if (_appointment.value?.appointmentAt == null)
              Container(
                width: 80,
                child: SizedBox.shrink(),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
            if (_appointment.value?.appointmentAt != null)
              Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('HH:mm', Get.locale.toString()).format(_appointment.value.appointmentAt),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1.4),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(DateFormat('dd', Get.locale.toString()).format(_appointment.value.appointmentAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.headline3.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(DateFormat('MMM', Get.locale.toString()).format(_appointment.value.appointmentAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(color: Get.theme.colorScheme.secondary, height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
          ],
        );
      }),
    );
  }

  Container buildContactDoctor(Rx<Appointment> _appointment) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Doctor".tr, style: Get.textTheme.subtitle2),
                Text(_appointment.value.doctor?.user?.phoneNumber ?? '', style: Get.textTheme.caption),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  launchUrlString("tel:${_appointment.value.doctor?.user?.phoneNumber ?? ''}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
              MaterialButton(
                onPressed: () {
                  controller.startChat();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                padding: EdgeInsets.zero,
                height: 44,
                minWidth: 44,
                child: Icon(
                  Icons.chat_outlined,
                  color: Get.theme.colorScheme.secondary,
                ),
                elevation: 0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
