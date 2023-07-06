import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../models/address_model.dart';
import '../models/appointment_model.dart';
import '../models/speciality_model.dart';
import '../models/clinic_model.dart';
import '../models/doctor_model.dart';
import '../models/faq_category_model.dart';
import '../models/notification_model.dart';
import '../models/review_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../models/user_model.dart';
import '../services/global_service.dart';

class MockApiClient {
  final _globalService = Get.find<GlobalService>();

  String get baseUrl => _globalService.global.value.mockBaseUrl;

  final Dio httpClient;
  final Options _options = buildCacheOptions(Duration(days: 3), forceRefresh: true);

  MockApiClient({@required this.httpClient}) {
    httpClient.interceptors.add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
  }

  Future<List<User>> getAllUsers() async {
    var response = await httpClient.get(baseUrl + "users/all.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    var response = await httpClient.get(baseUrl + "slides/home.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['results'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<User> getLogin() async {
    var response = await httpClient.get(baseUrl + "users/user.json", options: _options);
    if (response.statusCode == 200) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Address>> getAddresses() async {
    var response = await httpClient.get(baseUrl + "users/addresses.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getRecommendedDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/recommended.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getAllDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/all.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getAllDoctorsWithPagination(int page) async {
    var response = await httpClient.get(baseUrl + "doctors/all_page_$page.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getFavoritesDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/favorites.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<Doctor> getDoctor(String id) async {
    var response = await httpClient.get(baseUrl + "doctors/all.json", options: _options);
    if (response.statusCode == 200) {
      List<Doctor> _list = response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
      return _list.firstWhere((element) => element.id == id, orElse: () => new Doctor());
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<Clinic> getClinic(String clinicId) async {
    var response = await httpClient.get(baseUrl + "providers/eprovider.json", options: _options);
    if (response.statusCode == 200) {
      return Clinic.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getClinicReviews(String clinicId) async {
    var response = await httpClient.get(baseUrl + "providers/reviews.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getClinicFeaturedDoctors(String clinicId) async {
    var response = await httpClient.get(baseUrl + "doctors/featured.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  // getClinicMostRatedDoctors
  Future<List<Doctor>> getClinicPopularDoctors(String clinicId) async {
    var response = await httpClient.get(baseUrl + "doctors/popular.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getClinicAvailableDoctors(String clinicId) async {
    var response = await httpClient.get(baseUrl + "doctors/all.json", options: _options);
    if (response.statusCode == 200) {
      List<Doctor> _doctors = response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
      _doctors = _doctors.where((_doctor) {
        return _doctor.available;
      }).toList();
      return _doctors;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getClinicMostRatedDoctors(String clinicId) async {
    var response = await httpClient.get(baseUrl + "doctors/all.json", options: _options);
    if (response.statusCode == 200) {
      List<Doctor> _doctors = response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
      _doctors.sort((s1, s2) {
        return s2.rate.compareTo(s1.rate);
      });
      return _doctors;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getClinicDoctorsWithPagination(String clinicId, int page) async {
    var response = await httpClient.get(baseUrl + "doctors/all_page_$page.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getDoctorReviews(String doctorId) async {
    var response = await httpClient.get(baseUrl + "doctors/reviews.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getFeaturedDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/featured.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getPopularDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/popular.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getMostRatedDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/all.json", options: _options);
    if (response.statusCode == 200) {
      List<Doctor> _doctors = response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
      _doctors.sort((s1, s2) {
        return s2.rate.compareTo(s1.rate);
      });
      return _doctors;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Doctor>> getAvailableDoctors() async {
    var response = await httpClient.get(baseUrl + "doctors/all.json", options: _options);
    if (response.statusCode == 200) {
      List<Doctor> _doctors = response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
      _doctors = _doctors.where((_doctor) {
        return _doctor.available;
      }).toList();
      return _doctors;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Speciality>> getAllSpecialities() async {
    var response = await httpClient.get(baseUrl + "specialities/all2.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['results'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Speciality>> getAllWithSubSpecialities() async {
    var response = await httpClient.get(baseUrl + "specialities/subspecialities.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['results'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Speciality>> getFeaturedSpecialities() async {
    var response = await httpClient.get(baseUrl + "specialities/featured.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Appointment>> getAppointments(int page) async {
    var response = await httpClient.get(baseUrl + "tasks/all_page_$page.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Appointment>((obj) => Appointment.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<Appointment> getAppointment(String appointmentId) async {
    var response = await httpClient.get(baseUrl + "tasks/all.json", options: _options);
    if (response.statusCode == 200) {
      List<Appointment> _appointments = response.data['data'].map<Appointment>((obj) => Appointment.fromJson(obj)).toList();
      return _appointments.firstWhere((element) => element.id == appointmentId, orElse: () => new Appointment());
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Notification>> getNotifications() async {
    var response = await httpClient.get(baseUrl + "notifications/all.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<Notification>((obj) => Notification.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<FaqCategory>> getSpecialitiesWithFaqs() async {
    var response = await httpClient.get(baseUrl + "help/faqs.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data'].map<FaqCategory>((obj) => FaqCategory.fromJson(obj)).toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<Setting> getSettings() async {
    var response = await httpClient.get(baseUrl + "settings/all.json", options: _options);
    if (response.statusCode == 200) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }
}
