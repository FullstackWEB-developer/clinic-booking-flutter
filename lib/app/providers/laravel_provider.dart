import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';

import '../../common/uuid.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/appointment_model.dart';
import '../models/appointment_status_model.dart';
import '../models/patient_model.dart';
import '../models/speciality_model.dart';
import '../models/coupon_model.dart';
import '../models/custom_page_model.dart';
import '../models/clinic_model.dart';
import '../models/doctor_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/favorite_model.dart';
import '../models/gallery_model.dart';
import '../models/notification_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../services/settings_service.dart';
import 'api_provider.dart';
import 'dio_client.dart';

class LaravelApiClient extends GetxService with ApiClient {
  DioClient _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = DioClient(this.baseUrl, new dio.Dio());
  }

  Future<LaravelApiClient> init() async {
    _optionsNetwork = _httpClient.optionsNetwork;
    _optionsCache = _httpClient.optionsCache;
    return this;
  }

  bool isLoading({String task, List<String> tasks}) {
    return _httpClient.isLoading(task: task, tasks: tasks);
  }

  void setLocale(String locale) {
    _optionsNetwork.headers['Accept-Language'] = locale;
    _optionsCache.headers['Accept-Language'] = locale;
  }

  void forceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsCache = dio.Options(headers: _optionsCache.headers);
      _optionsNetwork = dio.Options(headers: _optionsNetwork.headers);
    }
  }

  void unForceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsNetwork = buildCacheOptions(Duration(days: 3), forceRefresh: true, options: _optionsNetwork);
      _optionsCache = buildCacheOptions(Duration(minutes: 10), forceRefresh: false, options: _optionsCache);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    Uri _uri = getApiBaseUri("slides");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("login");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("register");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("send_reset_link_email");
    Get.log(_uri.toString());
    // to remove other attributes from the user object
    user = new User(email: user.email);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("users/${user.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("users").replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'orderBy': 'id',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getRecommendedDoctors() async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      //'with': 'clinic;id;name;price;discount_price;price_unit;has_media;media;total_reviews;rate',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getAllDoctorsWithPagination(String specialityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'specialities.id:$specialityId',
      'searchFields': 'specialities.id:=',
      'limit': '4',
      'all': 'true',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> searchDoctors(String keywords, List<String> specialities, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'specialities.id:${specialities.join(',')};name:$keywords',
      'searchFields': 'specialities.id:in;name:like',
      'searchJoin': 'and',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Favorite>> getFavoritesDoctors() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFavoritesDoctors() ]");
    }
    var _queryParameters = {
      'with': 'doctor;options;doctor.clinic',
      'search': 'user_id:${authService.user.value.id}',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Favorite>((obj) => Favorite.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Favorite> addFavoriteDoctor(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception("You must have an account to be able to add doctors to favorite".tr + "[ addFavoriteDoctor() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return Favorite.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> removeFavoriteDoctor(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception("You must have an account to be able to add doctors to favorite".tr + "[ removeFavoriteDoctor() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("favorites/1").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Doctor> getDoctor(String id) async {
    var _queryParameters = {
      'with': 'clinic;clinic.taxes;clinic.address;specialities;user',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("doctors/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Doctor.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Clinic> getClinic(String clinicId) async {
    const _queryParameters = {
      'with': 'taxes;address;appointments;users',
    };
    Uri _uri = getApiBaseUri("clinics/$clinicId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Clinic.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Clinic>> getRecommendedClinics() async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      'only': 'id;name;has_media;media;total_reviews;rate;distance;available',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("clinics").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Clinic>((obj) => Clinic.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Clinic>> getNearClinics(LatLng latLng, LatLng areaLatLng) async {
    var _queryParameters = {
      'only': 'id;name;has_media;media;total_reviews;rate;address;distance;available',
      'with': 'address',
      'limit': '6',
    };
    _queryParameters['myLat'] = latLng.latitude.toString();
    _queryParameters['myLon'] = latLng.longitude.toString();
    _queryParameters['areaLat'] = areaLatLng.latitude.toString();
    _queryParameters['areaLon'] = areaLatLng.longitude.toString();

    Uri _uri = getApiBaseUri("clinics").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Clinic>((obj) => Clinic.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getClinicReviews(String clinicId) async {
    var _queryParameters = {'with': 'clinicReviews;clinicReviews.user', 'only': 'clinicReviews.id;clinicReviews.review;clinicReviews.rate;clinicReviews.user;'};
    Uri _uri = getApiBaseUri("clinics/$clinicId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['clinic_reviews'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Gallery>> getClinicGalleries(String clinicId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("galleries").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Gallery>((obj) => Gallery.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getClinicAwards(String clinicId) async {
    var _queryParameters = {
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Award>((obj) => Award.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getDoctorExperiences(String doctorId) async {
    var _queryParameters = {
      'search': 'doctor_id:$doctorId',
      'searchFields': 'doctor_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Experience>((obj) => Experience.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getClinicFeaturedDoctors(String clinicId, int page) async {
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'searchJoin': 'and',
      'limit': '5',
      'offset': ((page - 1) * 5).toString()
    };
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getClinicPopularDoctors(String clinicId, int page) async {
    // TODO popular doctors
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getClinicAvailableDoctors(String clinicId, int page) async {
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'available_doctor': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getClinicMostRatedDoctors(String clinicId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'clinic;clinic.address;specialities',
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getClinicEmployees(String clinicId) async {
    var _queryParameters = {'with': 'users', 'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token'};
    Uri _uri = getApiBaseUri("clinics/$clinicId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getClinicDoctors(String clinicId, int page) async {
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'clinic_id:$clinicId',
      'searchFields': 'clinic_id:=',
      'searchJoin': 'and',
      'limit': '4',
      'all':'true',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getDoctorReviews(String doctorId) async {
    var _queryParameters = {'with': 'user', 'only': 'created_at;review;rate;user', 'search': "doctor_id:$doctorId", 'orderBy': 'created_at', 'sortBy': 'desc', 'limit': '10'};
    Uri _uri = getApiBaseUri("doctor_reviews").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getFeaturedDoctors(String specialityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'clinic;clinic.address;specialities',
      'search': 'specialities.id:$specialityId;featured:1',
      'searchFields': 'specialities.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getPopularDoctors(String specialityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'clinic;clinic.address;specialities',
      'search': 'specialities.id:$specialityId',
      'searchFields': 'specialities.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getMostRatedDoctors(String specialityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'clinic;clinic.address;specialities',
      'search': 'specialities.id:$specialityId',
      'searchFields': 'specialities.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Doctor>> getAvailableDoctors(String specialityId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'clinic;clinic.address;specialities',
      'search': 'specialities.id:$specialityId',
      'searchFields': 'specialities.id:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("doctors").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Doctor>((obj) => Doctor.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Speciality>> getAllSpecialities() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("specialities").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Speciality>> getAllParentSpecialities() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("specialities").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Speciality>> getSubSpecialities(String specialityId) async {
    final _queryParameters = {
      'search': "parent_id:$specialityId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("specialities").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Speciality>> getAllWithSubSpecialities() async {
    const _queryParameters = {
      'with': 'subSpecialities',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("specialities").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Speciality>> getFeaturedSpecialities() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredDoctors',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("specialities").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Speciality>((obj) => Speciality.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Appointment>> getAppointments(String statusId, int page) async {
    var _queryParameters = {
      'with': 'appointmentStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      'search': 'appointment_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("appointments").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Appointment>((obj) => Appointment.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<AppointmentStatus>> getAppointmentStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("appointment_statuses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<AppointmentStatus>((obj) => AppointmentStatus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Appointment> getAppointment(String appointmentId) async {
    var _queryParameters = {
      'with': 'appointmentStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("appointments/${appointmentId}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Appointment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Coupon> validateCoupon(Appointment appointment) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': appointment.coupon?.code ?? '',
      'doctor_id': appointment.doctor?.id ?? '',
      'clinic_id': appointment.doctor?.clinic?.id ?? '',
      'specialities_id': appointment.doctor?.specialities?.map((e) => e.id)?.join(",") ?? '',
    };
    Uri _uri = getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Coupon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Appointment> updateAppointment(Appointment appointment) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateAppointment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("appointments/${appointment.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: appointment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Appointment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Appointment> addAppointment(Appointment appointment) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addAppointment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("appointments").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log("addAppointment repository: "+appointment.toJson().toString());
    var response = await _httpClient.postUri(_uri, data: appointment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Appointment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addDoctorReview(Review review) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("doctor_reviews").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: review.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addClinicReview(Review review) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("clinic_reviews").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: review.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Wallet>((obj) => Wallet.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Appointment _appointment) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/cash").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _appointment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createWalletPayment(Appointment _appointment, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _appointment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/paypal/express-checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/razorpay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/stripe/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/paystack/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/paymongo/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/flutterwave/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(Appointment _appointment) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'appointment_id': _appointment.id,
    };
    Uri _uri = getBaseUri("payments/stripe-fpx/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Notification>((obj) => Notification.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    var response = await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    print(authService.isAuth);
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqSpecialities() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<FaqCategory>((obj) => FaqCategory.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String specialityId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${specialityId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Faq>((obj) => Faq.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("settings");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List> getModules() async {
    Uri _uri = getApiBaseUri("modules");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map<String, String>> getTranslations(String locale) async {
    var _queryParameters = {
      'locale': locale,
    };
    Uri _uri = getApiBaseUri("translations").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return Map<String, String>.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<String>> getSupportedLocales() async {
    Uri _uri = getApiBaseUri("supported_locales");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return List.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<CustomPage>((obj) => CustomPage.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/store").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List> getAvailabilityHours(String doctorId, DateTime date) async {
    var _queryParameters = {
      'date': DateFormat('y-MM-dd').format(date),
    };
    Uri _uri = getApiBaseUri("availability_hours/$doctorId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Patient>> getAllClinicPatientsWithPagination(String clinicID, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'clinic;clinic.address',
      'search': 'specialities.id:$clinicID',
      'searchFields': 'specialities.id:=',
      'limit': '4',
      'all': 'true',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("patients").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Patient>((obj) => Patient.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Patient> getPatient(String id) async {
    var _queryParameters;
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("patients/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Patient.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Patient>> getPatientsWithUserId(String UserId,page) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'user_id:$UserId',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("patients/").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Patient>((obj) => Patient.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Patient>> getAllPatientsWithUserId(String UserId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'user_id:$UserId',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("patients/").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Patient>((obj) => Patient.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Patient> updatePatient(Patient patient) async {
    if (!authService.isAuth || !patient.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updatePatient(Patient patient) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("patients/${patient.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(patient.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return Patient.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Patient> createPatient(Patient patient) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("patients").replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(patient.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Patient.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deletePatient(Patient patient) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("patients/${patient.id}").replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
