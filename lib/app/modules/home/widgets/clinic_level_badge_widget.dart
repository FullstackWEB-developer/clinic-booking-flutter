// /*
//  * File name: clinic_level_badge_widget.dart
//  * Last modified: 2022.02.13 at 15:44:07
//  * Author: SmarterVision - https://codecanyon.net/user/smartervision
//  * Copyright (c) 2022
//  */
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../models/clinic_model.dart';
//
// class ClinicLevelBadgeWidget extends StatelessWidget {
//   const ClinicLevelBadgeWidget({
//     Key key,
//     @required Clinic clinic,
//   })  : _clinic = clinic,
//         super(key: key);
//
//   final Clinic _clinic;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsetsDirectional.only(start: 12, top: 10),
//       child: Text(_clinic.type?.name ?? '',
//           maxLines: 1,
//           style: Get.textTheme.bodyText2.merge(
//             TextStyle(color: Get.theme.primaryColor, height: 1.4, fontSize: 10),
//           ),
//           softWrap: false,
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.fade),
//       decoration: BoxDecoration(
//         color: Get.theme.colorScheme.secondary.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     );
//   }
// }
