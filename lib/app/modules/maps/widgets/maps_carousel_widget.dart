/*
 * File name: maps_carousel_widget.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/clinic_availability_badge_widget.dart';
import '../../home/widgets/clinic_level_badge_widget.dart';
import '../controllers/maps_controller.dart';
import 'maps_carousel_loading_widget.dart';

class MapsCarouselWidget extends GetWidget<MapsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 315,
      child: Obx(() {
        if (controller.clinics.isEmpty) return MapsCarouselLoadingWidget();
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 18),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.clinics.length,
            itemBuilder: (_, index) {
              var _clinic = controller.clinics.elementAt(index);
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.CLINIC, arguments: {'clinic': _clinic, 'heroTag': 'maps_carousel'});
                },
                child: Container(
                  width: 280,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: _clinic.firstImageUrl,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error_outline),
                            ),
                          ),
                          //ClinicLevelBadgeWidget(clinic: _clinic),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        height: 115,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _clinic.name ?? '',
                                    maxLines: 2,
                                    style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                                  ),
                                  Text(
                                    Ui.getDistance(_clinic.distance),
                                    style: Get.textTheme.bodyText1,
                                  ),
                                  SizedBox(height: 10),
                                  Wrap(
                                    children: Ui.getStarsList(_clinic.rate),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    MapsUtil.openMapsSheet(context, _clinic.address.getLatLng(), _clinic.name);
                                  },
                                  height: 38,
                                  minWidth: 60,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                                  child: Icon(
                                    Icons.directions_outlined,
                                    size: 22,
                                    color: Get.theme.colorScheme.secondary,
                                  ),
                                  elevation: 0,
                                ),
                                ClinicAvailabilityBadgeWidget(clinic: _clinic),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
