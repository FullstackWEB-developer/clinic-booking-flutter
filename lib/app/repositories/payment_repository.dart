import 'package:get/get.dart';

import '../models/appointment_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../providers/laravel_provider.dart';

class PaymentRepository {
  LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _laravelApiClient.getPaymentMethods();
  }

  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    return _laravelApiClient.getWalletTransactions(wallet);
  }

  Future<Wallet> createWallet(Wallet wallet) {
    return _laravelApiClient.createWallet(wallet);
  }

  Future<Wallet> updateWallet(Wallet wallet) {
    return _laravelApiClient.updateWallet(wallet);
  }

  Future<bool> deleteWallet(Wallet wallet) {
    return _laravelApiClient.deleteWallet(wallet);
  }

  Future<Payment> create(Appointment appointment) {
    return _laravelApiClient.createPayment(appointment);
  }

  Future<Payment> createWalletPayment(Appointment appointment, Wallet wallet) {
    return _laravelApiClient.createWalletPayment(appointment, wallet);
  }

  String getPayPalUrl(Appointment appointment) {
    return _laravelApiClient.getPayPalUrl(appointment);
  }

  String getRazorPayUrl(Appointment appointment) {
    return _laravelApiClient.getRazorPayUrl(appointment);
  }

  String getStripeUrl(Appointment appointment) {
    return _laravelApiClient.getStripeUrl(appointment);
  }

  String getPayStackUrl(Appointment appointment) {
    return _laravelApiClient.getPayStackUrl(appointment);
  }

  String getPayMongoUrl(Appointment appointment) {
    return _laravelApiClient.getPayMongoUrl(appointment);
  }

  String getFlutterWaveUrl(Appointment appointment) {
    return _laravelApiClient.getFlutterWaveUrl(appointment);
  }

  String getStripeFPXUrl(Appointment appointment) {
    return _laravelApiClient.getStripeFPXUrl(appointment);
  }
}
