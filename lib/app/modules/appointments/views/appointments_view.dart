import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/appointments_controller.dart';
import '../widgets/appointments_list_widget.dart';

class AppointmentsView extends GetView<AppointmentsController> {
  AppointmentsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            if (!Get.find<LaravelApiClient>().isLoading(task: 'getAppointments')) {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshAppointments(showMessage: true, statusId: controller.currentStatus.value);
              Get.find<LaravelApiClient>().unForceRefresh();
            }
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              Obx(() {
                return SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: 120,
                  elevation: 0.5,
                  floating: false,
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  title: Text(
                    Get.find<SettingsService>().setting.value.appName,
                    style: Get.textTheme.headline6,
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.sort, color: Colors.black87),
                    onPressed: () => {Scaffold.of(context).openDrawer()},
                  ),
                  actions: [NotificationsButtonWidget()],
                  bottom: controller.appointmentStatuses.isEmpty
                      ? TabBarLoadingWidget()
                      : TabBarWidget(
                          tag: 'appointments',
                          initialSelectedId: controller.appointmentStatuses.elementAt(0).id,
                          tabs: List.generate(controller.appointmentStatuses.length, (index) {
                            var _status = controller.appointmentStatuses.elementAt(index);
                            return ChipWidget(
                              tag: 'appointments',
                              text: _status.status,
                              id: _status.id,
                              onSelected: (id) {
                                controller.changeTab(id);
                              },
                            );
                          }),
                        ),
                );
              }),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AppointmentsListWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
