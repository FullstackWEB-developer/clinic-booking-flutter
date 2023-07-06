import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../providers/laravel_provider.dart';
import '../providers/mock_provider.dart';

class FaqRepository {
  MockApiClient _apiClient;
  LaravelApiClient _laravelApiClient;

  FaqRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<FaqCategory>> getSpecialitiesWithFaqs() {
    return _apiClient.getSpecialitiesWithFaqs();
  }

  Future<List<FaqCategory>> getFaqSpecialities() {
    return _laravelApiClient.getFaqSpecialities();
  }

  Future<List<Faq>> getFaqs(String specialityId) {
    return _laravelApiClient.getFaqs(specialityId);
  }
}
