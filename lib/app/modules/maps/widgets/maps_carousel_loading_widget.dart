/*
 * File name: maps_carousel_loading_widget.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MapsCarouselLoadingWidget extends StatelessWidget {
  const MapsCarouselLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (_, index) {
          return Shimmer.fromColors(
            baseColor: Get.theme.scaffoldBackgroundColor.withOpacity(0.4),
            highlightColor: Get.theme.primaryColor.withOpacity(0.6),
            child: Column(
              children: [
                Container(
                  width: 280,
                  height: 265,
                  margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
