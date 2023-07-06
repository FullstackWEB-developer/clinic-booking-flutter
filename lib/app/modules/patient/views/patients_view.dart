import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/patients_controller.dart';
import '../widgets/patients_list_widget.dart';

class PatientsView extends GetView<PatientsController> {
  PatientsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            if (!Get.find<LaravelApiClient>().isLoading(task: 'getPatientsWithUserId')) {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshPatients(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            }
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                floating: false,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                title: Text(
                  'Patients'.tr,
                  style: Get.textTheme.headline6,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [NotificationsButtonWidget()],
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    PatientsListWidget(),
                  ],
                ),
              ),
            ],
          )),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: () => {Get.toNamed(Routes.PATIENT)},
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
    );
  }
}
