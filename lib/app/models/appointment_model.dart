import 'patient_model.dart';

import 'address_model.dart';
import 'appointment_status_model.dart';
import 'coupon_model.dart';
import 'clinic_model.dart';
import 'doctor_model.dart';
import 'parents/model.dart';
import 'payment_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Appointment extends Model {
  String id;
  String hint;
  bool cancel;
  bool online;
  double duration;
  AppointmentStatus status;
  User user;
  Doctor doctor;
  Clinic clinic;
  Patient patient;
  List<Tax> taxes;
  Address address;
  Coupon coupon;
  DateTime appointmentAt;
  DateTime startAt;
  DateTime endsAt;
  Payment payment;

  Appointment(
      {this.id,
      this.hint,
      this.cancel,
      this.online,
      this.duration,
      this.status,
      this.user,
      this.doctor,
      this.clinic,
      this.patient,
      this.taxes,
      this.address,
      this.coupon,
      this.appointmentAt,
      this.startAt,
      this.endsAt,
      this.payment});

  Appointment.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    hint = stringFromJson(json, 'hint');
    cancel = boolFromJson(json, 'cancel');
    online = boolFromJson(json, 'online');
    duration = doubleFromJson(json, 'duration');
    status = objectFromJson(json, 'appointment_status', (v) => AppointmentStatus.fromJson(v));
    user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    doctor = objectFromJson(json, 'doctor', (v) => Doctor.fromJson(v));
    clinic = objectFromJson(json, 'clinic', (v) => Clinic.fromJson(v));
    patient = objectFromJson(json, 'patient', (v) => Patient.fromJson(v));
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    coupon = objectFromJson(json, 'coupon', (v) => Coupon.fromJson(v));
    payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    appointmentAt = dateFromJson(json, 'appointment_at', defaultValue: null);
    startAt = dateFromJson(json, 'start_at', defaultValue: null);
    endsAt = dateFromJson(json, 'ends_at', defaultValue: null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.hint != null) {
      data['hint'] = this.hint;
    }
    if (this.duration != null) {
      data['duration'] = this.duration;
    }
    if (this.cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this.online != null) {
      data['online'] = this.online;
    }
    if (this.status != null) {
      data['appointment_status_id'] = this.status.id;
    }
    if (this.coupon != null && this.coupon.code != null) {
      data['coupon'] = this.coupon.toJson();
    }
    if (this.coupon != null && this.coupon.id != null) {
      data['coupon_id'] = this.coupon.id;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes.map((e) => e.toJson()).toList();
    }
    if (this.user != null) {
      data['user_id'] = this.user.id;
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.clinic != null) {
      data['clinic'] = this.clinic.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.appointmentAt != null) {
      data['appointment_at'] = appointmentAt.toUtc().toString();
    }
    if (this.startAt != null) {
      data['start_at'] = startAt.toUtc().toString();
    }
    if (this.endsAt != null) {
      data['ends_at'] = endsAt.toUtc().toString();
    }
    return data;
  }

  double getTotal() {
    double total = getSubtotal();
    total += getTaxesValue();
    total += getCouponValue();
    return total;
  }

  double getTaxesValue() {
    double total = getSubtotal();
    double taxValue = 0.0;
    taxes?.forEach((element) {
      if (element.type == 'percent') {
        taxValue += (total * element.value / 100);
      } else {
        taxValue += element.value;
      }
    });
    return taxValue;
  }

  double getCouponValue() {
    double total = getSubtotal();
    if (coupon == null || !(coupon?.hasData ?? false)) {
      return 0;
    } else {
      if (coupon.discountType == 'percent') {
        return -(total * coupon.discount / 100);
      } else {
        return -coupon.discount;
      }
    }
  }

  double getSubtotal() {
    double total = 0.0;
    total = doctor.getPrice;
    return total;
  }

  bool get canAppointmentAtClinic {
    return this.doctor.enableAtClinic;
  }

  bool get canOnlineConsultation{
    return this.doctor.enableOnlineConsultation;
  }

  bool get canAppointmentAtCustomerAddress {
    return this.doctor.enableAtCustomerAddress;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Appointment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hint == other.hint &&
          cancel == other.cancel &&
          online == other.online &&
          duration == other.duration &&
          status == other.status &&
          user == other.user &&
          doctor == other.doctor &&
          clinic == other.clinic &&
          patient == other.patient &&
          taxes == other.taxes &&
          address == other.address &&
          coupon == other.coupon &&
          appointmentAt == other.appointmentAt &&
          startAt == other.startAt &&
          endsAt == other.endsAt &&
          payment == other.payment;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hint.hashCode ^
      cancel.hashCode ^
      online.hashCode ^
      duration.hashCode ^
      status.hashCode ^
      user.hashCode ^
      doctor.hashCode ^
      clinic.hashCode ^
      patient.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      coupon.hashCode ^
      appointmentAt.hashCode ^
      startAt.hashCode ^
      endsAt.hashCode ^
      payment.hashCode;
}
