import 'package:get/get.dart';
import '../models/patient_model.dart';
import '../providers/laravel_provider.dart';

class PatientRepository {
  LaravelApiClient _laravelApiClient;

  PatientRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Patient> get(String id) {
    return _laravelApiClient.getPatient(id);
  }

  Future<List<Patient>> getWithUserId(String UserId,{int page}) {
    return _laravelApiClient.getPatientsWithUserId(UserId,page);
  }

  Future<List<Patient>> getAllWithUserId(String UserId) {
    return _laravelApiClient.getAllPatientsWithUserId(UserId);
  }

  Future<Patient> update(Patient patient) {
    return _laravelApiClient.updatePatient(patient);
  }

  Future<Patient> create(Patient patient) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.createPatient(patient);
  }


  Future<void> deletePatient(Patient patient) async {
    _laravelApiClient = Get.find<LaravelApiClient>();

    await _laravelApiClient.deletePatient(patient);
  }
}
