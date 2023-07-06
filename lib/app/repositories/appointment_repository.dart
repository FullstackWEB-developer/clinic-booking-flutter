import 'package:get/get.dart';

import '../models/appointment_model.dart';
import '../models/appointment_status_model.dart';
import '../models/coupon_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';

class AppointmentRepository {
  LaravelApiClient _laravelApiClient;

  AppointmentRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Appointment>> all(String statusId, {int page}) {
    return _laravelApiClient.getAppointments(statusId, page);
  }

  Future<List<AppointmentStatus>> getStatuses() {
    return _laravelApiClient.getAppointmentStatuses();
  }

  Future<Appointment> get(String appointmentId) {
    return _laravelApiClient.getAppointment(appointmentId);
  }

  Future<Appointment> add(Appointment appointment) {
    return _laravelApiClient.addAppointment(appointment);
  }

  Future<Appointment> update(Appointment appointment) {
    return _laravelApiClient.updateAppointment(appointment);
  }

  Future<Coupon> coupon(Appointment appointment) {
    return _laravelApiClient.validateCoupon(appointment);
  }

  Future<Review> addDoctorReview(Review review) {
    return _laravelApiClient.addDoctorReview(review);
  }

  Future<Review> addClinicReview(Review review) {
    return _laravelApiClient.addClinicReview(review);
  }
}
