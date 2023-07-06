/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../appointments/widgets/appointment_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required Appointment appointment,
  })  : _appointment = appointment,
        super(key: key);

  final Appointment _appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // decoration: Ui.getBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: _appointment.doctor.firstImageUrl,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      _appointment.doctor.name ?? '',
                      style: Get.textTheme.bodyText2,
                      maxLines: 3,
                      // textAlign: TextAlign.end,
                    ),
                  ],
                ),
                Divider(height: 8, thickness: 1),
                AppointmentRowWidget(
                  description: "Tax Amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_appointment.getTaxesValue(), style: Get.textTheme.subtitle2),
                  ),
                ),
                AppointmentRowWidget(
                  description: "Subtotal".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_appointment.getSubtotal(), style: Get.textTheme.subtitle2),
                  ),
                ),
                if ((_appointment.coupon?.discount ?? 0) > 0)
                  AppointmentRowWidget(
                    description: "Coupon".tr,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: [
                          Text(' - ', style: Get.textTheme.bodyText1),
                          Ui.getPrice(_appointment.coupon?.discount ?? 0, style: Get.textTheme.bodyText1, unit: _appointment.coupon.discountType == 'percent' ? "%" : null),
                        ],
                      ),
                    ),
                    hasDivider: false,
                  ),
                AppointmentRowWidget(
                  description: "Total Amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_appointment.getTotal(), style: Get.textTheme.headline6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
