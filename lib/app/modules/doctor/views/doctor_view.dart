import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/ui.dart';
import '../../../models/doctor_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/doctor_controller.dart';
import '../widgets/clinic_item_widget.dart';
import '../widgets/doctor_til_widget.dart';
import '../widgets/doctor_title_bar_widget.dart';
import '../widgets/review_item_widget.dart';

class DoctorView extends GetView<DoctorController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _doctor = controller.doctor.value;
      if (!_doctor.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          bottomNavigationBar: buildBottomWidget(_doctor),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshDoctor(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    actions: [
                      new IconButton(
                        icon: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Get.theme.primaryColor.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ]),
                          child: (_doctor?.isFavorite ?? false) ? Icon(Icons.favorite, color: Colors.redAccent) : Icon(Icons.favorite_outline, color: Get.theme.hintColor),
                        ),
                        onPressed: () {
                          if (!Get.find<AuthService>().isAuth) {
                            Get.toNamed(Routes.LOGIN);
                          } else {
                            if (_doctor?.isFavorite ?? false) {
                              controller.removeFromFavorite();
                            } else {
                              controller.addToFavorite();
                            }
                          }
                        },
                      ).marginSymmetric(horizontal: 10),
                    ],
                    bottom: buildDoctorTitleBarWidget(_doctor),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_doctor),
                            buildCarouselBullets(_doctor),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  //WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildSpecialities(_doctor),
                        DoctorTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Obx(() {
                            if (controller.doctor.value.description == '') {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_doctor.description, style: Get.textTheme.bodyText1);
                          }),
                        ),
                        buildContactUs(),
                        buildDoctorClinic(_doctor),
                        if (_doctor.images.isNotEmpty)
                          DoctorTilWidget(
                            horizontalPadding: 0,
                            title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                            content: Container(
                              height: 120,
                              child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _doctor.images.length,
                                  itemBuilder: (_, index) {
                                    var _media = _doctor.images.elementAt(index);
                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.GALLERY, arguments: {'media': _doctor.images, 'current': _media, 'heroTag': 'doctors_galleries'});
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                                        child: Stack(
                                          alignment: AlignmentDirectional.topStart,
                                          children: [
                                            Hero(
                                              tag: 'doctors_galleries' + (_media?.id ?? ''),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: _media.thumb,
                                                  placeholder: (context, url) => Image.asset(
                                                    'assets/img/loading.gif',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 100,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                                              child: Text(
                                                _media.name ?? '',
                                                maxLines: 2,
                                                style: Get.textTheme.bodyText2.merge(TextStyle(
                                                  color: Get.theme.primaryColor,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 6.0,
                                                      color: Get.theme.hintColor.withOpacity(0.6),
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            actions: [
                              // TODO View all galleries
                            ],
                          ),
                        buildExperiences(),
                        DoctorTilWidget(
                          title: Text("Reviews & Ratings".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              Text(_doctor.rate.toString(), style: Get.textTheme.headline1),
                              Wrap(
                                children: Ui.getStarsList(_doctor.rate, size: 32),
                              ),
                              Text(
                                "Reviews (%s)".trArgs([_doctor.totalReviews.toString()]),
                                style: Get.textTheme.caption,
                              ).paddingOnly(top: 10),
                              Divider(height: 35, thickness: 1.3),
                              Obx(() {
                                if (controller.reviews.isEmpty) {
                                  return CircularLoadingWidget(height: 100);
                                }
                                return ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return ReviewItemWidget(review: controller.reviews.elementAt(index));
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(height: 35, thickness: 1.3);
                                  },
                                  itemCount: controller.reviews.length,
                                  primary: false,
                                  shrinkWrap: true,
                                );
                              }),
                            ],
                          ),
                          actions: [
                            // TODO view all reviews
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Container buildContactUs() {
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
                Text("Contact us".tr, style: Get.textTheme.subtitle2),
                Text("If your have any question!".tr, style: Get.textTheme.caption),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                onPressed: () {
                  launchUrlString("tel:${controller.doctor.value.user.phoneNumber}");
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
                  launchUrlString("tel:${controller.doctor.value.user.phoneNumber}");
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                child: Icon(
                  Icons.call_outlined,
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

  Widget buildExperiences() {
    return Obx(() {
      if (controller.experiences.isEmpty) {
        return SizedBox(height: 0);
      }
      return DoctorTilWidget(
        title: Text("Experiences".tr, style: Get.textTheme.subtitle2),
        content: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.experiences.length,
          separatorBuilder: (context, index) {
            return Divider(height: 16, thickness: 0.8);
          },
          itemBuilder: (context, index) {
            var _experience = controller.experiences.elementAt(index);
            return Column(
              children: [
                Text(_experience.title ?? '').paddingSymmetric(vertical: 5),
                Ui.applyHtml(
                  _experience.description ?? '',
                  style: Get.textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            );
          },
        ),
      );
    });
  }

  CarouselSlider buildCarouselSlider(Doctor _doctor) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _doctor.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _doctor.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Doctor _doctor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _doctor.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _doctor.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  DoctorTitleBarWidget buildDoctorTitleBarWidget(Doctor _doctor) {
    return DoctorTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _doctor.name ?? '',
                  style: Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (_doctor.clinic == null)
                Container(
                  child: Text("  .  .  .  ".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_doctor.clinic != null  && _doctor.available)
                Container(
                  child: Text("Available".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_doctor.clinic != null && !_doctor.available)
                Container(
                  child: Text("Offline".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: List.from(Ui.getStarsList(_doctor.rate))),
                    Text(
                      "Reviews (%s)".trArgs([_doctor.totalReviews.toString()]),
                      style: Get.textTheme.caption,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_doctor.getOldPrice > 0)
                    Ui.getPrice(
                      _doctor.getOldPrice,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                    ),
                  Ui.getPrice(
                    _doctor.getPrice,
                    style: Get.textTheme.headline3.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSpecialities(Doctor _doctor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_doctor.specialities.length, (index) {
              var _speciality = _doctor.specialities.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_speciality.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: _speciality.color))),
                decoration: BoxDecoration(
                    color: _speciality.color.withOpacity(0.2),
                    border: Border.all(
                      color: _speciality.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_doctor.subSpecialities.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_doctor.subSpecialities.elementAt(index).name, style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildDoctorClinic(Doctor _doctor) {
    if (_doctor?.clinic?.hasData ?? false) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.CLINIC, arguments: {'clinic': _doctor.clinic, 'heroTag': 'doctor_details'});
        },
        child: DoctorTilWidget(
          title: Text("Clinic".tr, style: Get.textTheme.subtitle2),
          content: ClinicItemWidget(clinic: _doctor.clinic),
          actions: [
            Text("View More".tr, style: Get.textTheme.subtitle1),
          ],
        ),
      );
    } else {
      return DoctorTilWidget(
        title: Text("Clinic".tr, style: Get.textTheme.subtitle2),
        content: SizedBox(
          height: 60,
        ),
        actions: [],
      );
    }
  }

  Widget buildBottomWidget(Doctor _doctor) {
    if (_doctor.enableAppointment == null || !_doctor.enableAppointment)
      return SizedBox();
    else
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
              Expanded(
              child: BlockButtonWidget(
                  text: Container(
                    height: 24,
                    alignment: Alignment.center,
                    child: Text(
                      "Book This Doctor".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  color: Get.theme.colorScheme.secondary,
                  onPressed: () {
                    Get.toNamed(Routes.BOOK_DOCTOR, arguments: {'doctor': _doctor});
                  }),
            ),
          ],
        ).paddingOnly(right: 20, left: 20),
      );
  }


}
