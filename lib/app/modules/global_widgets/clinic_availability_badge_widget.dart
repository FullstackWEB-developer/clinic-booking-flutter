/*
 * File name: clinic_availability_badge_widget.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/clinic_model.dart';

class ClinicAvailabilityBadgeWidget extends StatelessWidget {
  const ClinicAvailabilityBadgeWidget({
    Key key,
    @required Clinic clinic,
    bool withImage = false,
  })  : _clinic = clinic,
        _withImage = withImage,
        super(key: key);

  final Clinic _clinic;
  final bool _withImage;

  @override
  Widget build(BuildContext context) {
    if (_clinic?.available ?? true)
      return Container(
        width: _withImage ? 80 : null,
        child: Text("Closed".tr.substring(0, min("Closed".tr.length, 12)),
            maxLines: 1,
            style: Get.textTheme.bodyText2.merge(
              TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
            ),
            softWrap: false,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: _withImage ? BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)) : BorderRadius.circular(8),
        ),
        padding: _withImage ? EdgeInsets.symmetric(horizontal: 5, vertical: 6) : EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      );
    return Container(
      width: _withImage ? 80 : null,
      child: Text("Open".tr.substring(0, min("Open".tr.length, 12)),
          maxLines: 1,
          style: Get.textTheme.bodyText2.merge(
            TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
          ),
          softWrap: false,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: _withImage ? BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)) : BorderRadius.circular(8),
      ),
      padding: _withImage ? EdgeInsets.symmetric(horizontal: 5, vertical: 6) : EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
