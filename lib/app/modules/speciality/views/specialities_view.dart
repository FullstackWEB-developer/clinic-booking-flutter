import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../controllers/specialities_controller.dart';
import '../widgets/speciality_grid_item_widget.dart';
import '../widgets/speciality_list_item_widget.dart';

class SpecialitiesView extends GetView<SpecialitiesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Specialities".tr,
            style: Get.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshSpecialities(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            primary: true,
            children: [
              HomeSearchBarWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      "Specialities of doctors".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          controller.layout.value = SpecialitiesLayout.LIST;
                        },
                        icon: Obx(() {
                          return Icon(
                            Icons.format_list_bulleted,
                            color: controller.layout.value == SpecialitiesLayout.LIST ? Get.theme.colorScheme.secondary : Get.theme.focusColor,
                          );
                        }),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.layout.value = SpecialitiesLayout.GRID;
                        },
                        icon: Obx(() {
                          return Icon(
                            Icons.apps,
                            color: controller.layout.value == SpecialitiesLayout.GRID ? Get.theme.colorScheme.secondary : Get.theme.focusColor,
                          );
                        }),
                      )
                    ],
                  ),
                ]),
              ),
              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != SpecialitiesLayout.GRID,
                  child: controller.specialities.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : MasonryGridView.count(
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: controller.specialities.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SpecialityGridItemWidget(speciality: controller.specialities.elementAt(index), heroTag: "heroTag");
                          },
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                        ),
                );
              }),
              Obx(() {
                return Offstage(
                  offstage: controller.layout.value != SpecialitiesLayout.LIST,
                  child: controller.specialities.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.specialities.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return SpecialityListItemWidget(
                              heroTag: 'speciality_list',
                              expanded: index == 0,
                              speciality: controller.specialities.elementAt(index),
                            );
                          },
                        ),
                );
              }),
              // Container(
              //   child: ListView(
              //       primary: false,
              //       shrinkWrap: true,
              //       children: List.generate(controller.specialities.length, (index) {
              //         return Obx(() {
              //           var _speciality = controller.specialities.elementAt(index);
              //           return Padding(
              //             padding: const EdgeInsetsDirectional.only(start: 20),
              //             child: Text(_speciality.name),
              //           );
              //         });
              //       })),
              // ),
            ],
          ),
        ));
  }
}
