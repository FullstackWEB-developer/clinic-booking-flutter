import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/common/ui.dart';
import '../models/appointment_model.dart';
import '../models/message_model.dart';
import '../modules/appointments/controllers/appointment_controller.dart';
import '../modules/appointments/controllers/appointments_controller.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true);
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    return this;
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Get.isRegistered<RootController>()) {
        Get.find<RootController>().getNotificationsCount();
      }
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _appointmentNotification(message);
      }
    });
  }

  Future fcmOnLaunchListeners() async {
    RemoteMessage message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    } else {
      _newAppointmentNotificationBackground(message);
    }
  }

  void _newAppointmentNotificationBackground(message) {
    if (Get.isRegistered<RootController>()) {
      Get.toNamed(Routes.APPOINTMENT, arguments: new Appointment(id: message.data['appointmentId']));
    }
  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    if (message.data['messageId'] != null) {
      Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
    }
  }

  Future<void> setDeviceToken() async {
    Get.find<AuthService>().user.value.deviceToken = await FirebaseMessaging.instance.getToken();
  }

  void _appointmentNotification(RemoteMessage message) {
    if (Get.currentRoute == Routes.ROOT) {
      Get.find<AppointmentsController>().refreshAppointments();
    }
    if (Get.currentRoute == Routes.APPOINTMENT) {
      Get.find<AppointmentController>().refreshAppointment();
    }
    RemoteNotification notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification.title,
      message: notification.body,
      mainButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: message.data != null ? message.data['icon'] : "",
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
        ),
      ),
      onTap: (getBar) async {
        if (message.data['appointmentId'] != null) {
          await Get.back();
          Get.toNamed(Routes.APPOINTMENT, arguments: new Appointment(id: message.data['appointmentId']));
        }
      },
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    if (Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title,
        message: notification.body,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null ? message.data['icon'] : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
            ),
          ),
        ),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
            await Get.back();
            Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
          }
        },
      ));
    }
  }
}
