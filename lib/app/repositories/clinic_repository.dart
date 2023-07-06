import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/award_model.dart';
import '../models/clinic_model.dart';
import '../models/doctor_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class ClinicRepository {
  LaravelApiClient _laravelApiClient;

  ClinicRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Clinic> get(String clinicId) {
    return _laravelApiClient.getClinic(clinicId);
  }

  Future<List<Review>> getReviews(String clinicId) {
    return _laravelApiClient.getClinicReviews(clinicId);
  }

  Future<List<Gallery>> getGalleries(String clinicId) {
    return _laravelApiClient.getClinicGalleries(clinicId);
  }
  Future<List<Clinic>> getRecommended() {
    return _laravelApiClient.getRecommendedClinics();
  }
  Future<List<Clinic>> getNearClinics(LatLng latLng, LatLng areaLatLng) {
    return _laravelApiClient.getNearClinics(latLng, areaLatLng);
  }

  Future<List<Award>> getAwards(String clinicId) {
    return _laravelApiClient.getClinicAwards(clinicId);
  }

  Future<List<Experience>> getExperiences(String clinicId) {
    return _laravelApiClient.getDoctorExperiences(clinicId);
  }

  Future<List<Doctor>> getDoctors(String clinicId, {int page}) {
    return _laravelApiClient.getClinicDoctors(clinicId, page);
  }

  Future<List<User>> getEmployees(String clinicId) {
    return _laravelApiClient.getClinicEmployees(clinicId);
  }

  Future<List<Doctor>> getPopularDoctors(String clinicId, {int page}) {
    return _laravelApiClient.getClinicPopularDoctors(clinicId, page);
  }

  Future<List<Doctor>> getMostRatedDoctors(String clinicId, {int page}) {
    return _laravelApiClient.getClinicMostRatedDoctors(clinicId, page);
  }

  Future<List<Doctor>> getAvailableDoctors(String clinicId, {int page}) {
    return _laravelApiClient.getClinicAvailableDoctors(clinicId, page);
  }

  Future<List<Doctor>> getFeaturedDoctors(String clinicId, {int page}) {
    return _laravelApiClient.getClinicFeaturedDoctors(clinicId, page);
  }
}
