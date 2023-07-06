import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/doctor_model.dart';
import '../../../routes/app_routes.dart';

class ServicesCarouselWidget extends StatelessWidget {
  final List<Doctor> doctors;

  const ServicesCarouselWidget({Key key, List<Doctor> this.doctors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 10),
          primary: false,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: doctors.length,
          itemBuilder: (_, index) {
            var _doctor = doctors.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.DOCTOR, arguments: {'doctor': _doctor, 'heroTag': 'doctors_carousel'});
              },
              child: Container(
                width: 220,
                margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                ),
                child: Column(
                  //alignment: AlignmentDirectional.topStart,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: _doctor.firstImageUrl,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            _doctor.name,
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                          ),
                          Wrap(
                            children: Ui.getStarsList(_doctor.rate),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 5,
                            alignment: WrapAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              Text(
                                "Start from".tr,
                                style: Get.textTheme.caption,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (_doctor.getOldPrice > 0)
                                    Ui.getPrice(
                                      _doctor.getOldPrice,
                                      style: Get.textTheme.bodyText1.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                                    ),
                                  Ui.getPrice(
                                    _doctor.getPrice,
                                    style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
