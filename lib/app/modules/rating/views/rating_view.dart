import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/rating_controller.dart';

class RatingView extends GetView<RatingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave a Review".tr,
          style: Get.textTheme.headline6,
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
      body: ListView(
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20),
        children: [
          Column(
            children: [
              Wrap(children: [
                Text("Hi,".tr),
                Text(
                  Get.find<AuthService>().user.value.name,
                  style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                )
              ]),
              SizedBox(height: 10),
              Text(
                "How do you feel this doctor?".tr,
                style: Get.textTheme.bodyText2,
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: Get.width,
              decoration: Ui.getBoxDecoration(),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: controller.appointment.value.doctor.firstImageUrl,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 160,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      controller.appointment.value.doctor.name,
                      style: Get.textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Click on the stars to rate this doctor".tr,
                      style: Get.textTheme.caption,
                    ),
                    SizedBox(height: 6),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap: () {
                              controller.doctorReview.update((val) {
                                val.rate = (index + 1).toDouble();
                              });
                            },
                            child: index < controller.doctorReview.value.rate
                                ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                                : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
                          );
                        }),
                      );
                    }),
                    SizedBox(height: 30)
                  ],
                ),
              )),
          TextFieldWidget(
            labelText: "Write your review".tr,
            hintText: "Tell us somethings about this doctor".tr,
            iconData: Icons.description_outlined,
            onChanged: (text) {
              controller.doctorReview.update((val) {
                val.review = text;
              });
            },
          ),

          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: Get.width,
              decoration: Ui.getBoxDecoration(),
              child: Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: controller.appointment.value.clinic.firstImageUrl,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 160,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      controller.appointment.value.doctor.name,
                      style: Get.textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Click on the stars to rate this doctor".tr,
                      style: Get.textTheme.caption,
                    ),
                    SizedBox(height: 6),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap: () {
                              controller.clinicReview.update((val) {
                                val.rate = (index + 1).toDouble();
                              });
                            },
                            child: index < controller.clinicReview.value.rate
                                ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                                : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
                          );
                        }),
                      );
                    }),
                    SizedBox(height: 30)
                  ],
                ),
              )),
          TextFieldWidget(
            labelText: "Write your review".tr,
            hintText: "Tell us somethings about this clinic".tr,
            iconData: Icons.description_outlined,
            onChanged: (text) {
              controller.clinicReview.update((val) {
                val.review = text;
              });
            },
          ),
          BlockButtonWidget(
              text: Text(
                "Submit Review".tr,
                style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () {
                controller.addDoctorReview();
                controller.addClinicReview();
              }).marginSymmetric(vertical: 10, horizontal: 20)
        ],
      ),
    );
  }
}
