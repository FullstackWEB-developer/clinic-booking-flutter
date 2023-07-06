import 'package:get/get.dart' show GetPage, Transition;

import '../middlewares/auth_middleware.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/phone_verification_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/book_doctor/bindings/book_doctor_binding.dart';
import '../modules/book_doctor/views/book_doctor_view.dart';
import '../modules/book_doctor/views/appointment_summary_view.dart';
import '../modules/appointments/views/appointment_view.dart';
import '../modules/maps/bindings/maps_binding.dart';
import '../modules/maps/views/maps_view.dart';
import '../modules/messages/binding/messages_binding.dart';
import '../modules/patient/bindings/patient_binding.dart';
import '../modules/patient/views/patient_form_view.dart';
import '../modules/patient/views/patient_view.dart';
import '../modules/patient/views/patients_view.dart';
import '../modules/speciality/bindings/speciality_binding.dart';
import '../modules/speciality/views/specialities_view.dart';
import '../modules/speciality/views/speciality_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/cash_view.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/confirmation_view.dart';
import '../modules/checkout/views/flutterwave_view.dart';
import '../modules/checkout/views/paymongo_view.dart';
import '../modules/checkout/views/paypal_view.dart';
import '../modules/checkout/views/paystack_view.dart';
import '../modules/checkout/views/razorpay_view.dart';
import '../modules/checkout/views/stripe_fpx_view.dart';
import '../modules/checkout/views/stripe_view.dart';
import '../modules/checkout/views/wallet_view.dart';
import '../modules/custom_pages/bindings/custom_pages_binding.dart';
import '../modules/custom_pages/views/custom_pages_view.dart';
import '../modules/clinic/bindings/clinic_binding.dart';
import '../modules/clinic/views/clinic_doctors_view.dart';
import '../modules/clinic/views/clinic_view.dart';
import '../modules/doctor/bindings/doctor_binding.dart';
import '../modules/doctor/views/doctor_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/gallery/bindings/gallery_binding.dart';
import '../modules/gallery/views/gallery_view.dart';
import '../modules/help_privacy/bindings/help_privacy_binding.dart';
import '../modules/help_privacy/views/help_view.dart';
import '../modules/help_privacy/views/privacy_view.dart';
import '../modules/messages/views/chats_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/rating/bindings/rating_binding.dart';
import '../modules/rating/views/rating_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/search/views/search_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/address_picker_view.dart';
import '../modules/settings/views/addresses_view.dart';
import '../modules/settings/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_mode_view.dart';
import '../modules/wallets/bindings/wallets_binding.dart';
import '../modules/wallets/views/wallet_form_view.dart';
import '../modules/wallets/views/wallets_view.dart';
import 'app_routes.dart';

class Theme1AppPages {
  static const INITIAL = Routes.ROOT;

  static final routes = [
    GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.RATING, page: () => RatingView(), binding: RatingBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHAT, page: () => ChatsView(), binding: MessagesBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESSES, page: () => AddressesView(), binding: SettingsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_LANGUAGE, page: () => LanguageView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_ADDRESS_PICKER, page: () => AddressPickerView()),
    GetPage(name: Routes.PROFILE, page: () => ProfileView(), binding: ProfileBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SPECIALITY, page: () => SpecialityView(), binding: SpecialityBinding()),
    GetPage(name: Routes.SPECIALITIES, page: () => SpecialitiesView(), binding: SpecialityBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.MAPS, page: () => MapsView(), binding: MapsBinding()),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding()),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding()),
    GetPage(name: Routes.PHONE_VERIFICATION, page: () => PhoneVerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.DOCTOR, page: () => DoctorView(), binding: DoctorBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.BOOK_DOCTOR, page: () => BookDoctorView(), binding: BookDoctorBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.APPOINTMENT_SUMMARY, page: () => AppointmentSummaryView(), binding: BookDoctorBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHECKOUT, page: () => CheckoutView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CONFIRMATION, page: () => ConfirmationView(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: RootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.NOTIFICATIONS, page: () => NotificationsView(), binding: NotificationsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FAVORITES, page: () => FavoritesView(), binding: FavoritesBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PRIVACY, page: () => PrivacyView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.HELP, page: () => HelpView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.CLINIC, page: () => ClinicView(), binding: ClinicBinding()),
    GetPage(name: Routes.CLINIC_DOCTORS, page: () => ClinicDoctorsView(), binding: ClinicBinding()),
    GetPage(name: Routes.PATIENT, page: () => PatientView(), binding: PatientBinding()),
    GetPage(name: Routes.PATIENT_FORM, page: () => PatientFormView(), binding: PatientBinding()),
    GetPage(name: Routes.APPOINTMENT, page: () => AppointmentView(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYPAL, page: () => PayPalViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.RAZORPAY, page: () => RazorPayViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE, page: () => StripeViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.STRIPE_FPX, page: () => StripeFPXViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYSTACK, page: () => PayStackViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.PAYMONGO, page: () => PayMongoViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.FLUTTERWAVE, page: () => FlutterWaveViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CASH, page: () => CashViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.WALLET, page: () => WalletViewWidget(), binding: CheckoutBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CUSTOM_PAGES, page: () => CustomPagesView(), binding: CustomPagesBinding()),
    GetPage(name: Routes.GALLERY, page: () => GalleryView(), binding: GalleryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.WALLETS, page: () => WalletsView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.WALLET_FORM, page: () => WalletFormView(), binding: WalletsBinding(), middlewares: [AuthMiddleware()]),
  ];
}
