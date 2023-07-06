/*
 * File name: maps_binding.dart
 * Last modified: 2022.02.10 at 22:29:48
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../controllers/maps_controller.dart';

class MapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsController>(
      () => MapsController(),
    );
  }
}
