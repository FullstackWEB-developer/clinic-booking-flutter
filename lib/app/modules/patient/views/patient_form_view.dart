import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../models/media_model.dart';
import '../../global_widgets/gender_field_widget.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../profile/widgets/delete_account_widget.dart';
import '../controllers/patient_controller.dart';
import '../controllers/patient_form_controller.dart';
import '../widgets/delete_patient_widget.dart';

class PatientFormView extends GetView<PatientFormController> {

  @override
  Widget build(BuildContext context) {
    controller.patientForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Patient".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back()
          ),
          elevation: 0,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    controller.updatePatientForm();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                ),
              ),
              SizedBox(width: 10),
              MaterialButton(
                onPressed: () {
                  controller.resetPatientForm();
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Reset".tr, style: Get.textTheme.bodyText2),
                elevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.patientForm,
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Patient details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Change the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImagesFieldWidget(
                    label: "Images".tr,
                    field: 'image',
                    tag: controller.patientForm.hashCode.toString(),
                    initialImages: controller.patient.value.images,
                    uploadCompleted: (uuid) {
                      controller.patient.update((val) {
                        val.images = val.images ?? [];
                        val.images.add(new Media(id: uuid));
                      });
                    },
                    reset: (uuids) {
                      controller.patient.update((val) {
                        val.images.clear();
                      });
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.patient.value.first_name = input,
                  // onChanged: (input) => controller.patient.value.first_name = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.patient.value.first_name,
                  hintText: "John Doe".tr,
                  labelText: "First Name".tr,
                  iconData: Icons.person_outline,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.patient.value.last_name = input,
                  // onChanged: (input) => controller.patient.value.last_name = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.patient.value.last_name,
                  hintText: "John Doe".tr,
                  labelText: "Last Name".tr,
                  iconData: Icons.person_outline,
                ),
                PhoneFieldWidget(
                  labelText: "Phone Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: Helper.getPhoneNumber(controller.patient.value.phone_number)?.countryISOCode,
                  initialValue: Helper.getPhoneNumber(controller.patient.value.phone_number)?.number,
                  onSaved: (phone) {
                    return controller.patient.value.phone_number = phone.completeNumber;
                  },
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.patient.value.age = input,
                  // onChanged: (input) => controller.patient.value.age = input,
                  validator: (input) => input.length < 1 ? "Should be more than 1 number".tr : null,
                  initialValue: controller.patient.value.age,
                  keyboardType: TextInputType.numberWithOptions(),
                  hintText: "55".tr,
                  labelText: "Age".tr,
                  iconData: Icons.account_box,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.patient.value.height = input,
                  // onChanged: (input) => controller.patient.value.height = input,
                  validator: (input){
                    if (input.length < 2) {
                      return "Should be more than 2 numbers".tr;
                    }
                    else if (double.parse(input) < 3) {
                      return "Enter Your Height on CM".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.patient.value.height,
                  keyboardType: TextInputType.numberWithOptions(),
                  hintText: "180".tr,
                  labelText: "Height".tr,
                  iconData: Icons.height,
                  suffixIcon: Text(
                      "CM".tr,
                      style: Get.textTheme.caption,
                  ).marginOnly(top: 14),
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.patient.value.weight = input,
                  validator: (input) => input.length < 1 ? "Should be more than 1 number".tr : null,
                  initialValue: controller.patient.value.weight,
                  keyboardType: TextInputType.numberWithOptions(),
                  hintText: "60".tr,
                  labelText: "Weight".tr,
                  iconData: Icons.monitor_weight_outlined,
                  suffixIcon: Text(
                    "KG".tr,
                    style: Get.textTheme.caption,
                  ),
                ),
               Obx((){
                 return GenderFieldWidget(
                   items: controller.getSelectGenderItem(),
                   iconData: Icons.male_rounded,
                   onChanged: (selectedValue) {
                     controller.selectedGender.value = selectedValue.toString();
                   },
                   onSaved: (selectedValue) {
                     controller.patient.value.gender = selectedValue.toString();
                   },
                   value: controller.selectedGender.value,
                   labelText:"Gender".tr,
                 );
               }),
                DeletePatientWidget(),

              ],
            ),

          ),
        ));
  }
}
