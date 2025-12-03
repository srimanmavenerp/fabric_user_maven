import 'package:dio/dio.dart';
import 'package:laundrymart/features/others/model/about_us.dart/about.dart';
import 'package:laundrymart/features/others/model/terms_of_service_model/terms_of_service_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class ISettingsRepo {
  Future<TermsOfServiceModel> getTOS();
  Future<TermsOfServiceModel> getAboutUs();
  Future<AboutUs> getAbout();
  Future<TermsOfServiceModel> getPrivacyPolicy();
  Future<TermsOfServiceModel> getContactUS();
}

class SettingsRepo implements ISettingsRepo {
  final Dio _dio = getDio();
  @override
  Future<TermsOfServiceModel> getTOS() async {
    final Response reponse = await _dio.get('/legal-pages/trams-of-service');
    return TermsOfServiceModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<TermsOfServiceModel> getAboutUs() async {
    final Response reponse = await _dio.get('/legal-pages/about-us');
    return TermsOfServiceModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<TermsOfServiceModel> getPrivacyPolicy() async {
    final Response reponse = await _dio.get('/legal-pages/privacy-policy');
    return TermsOfServiceModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<TermsOfServiceModel> getContactUS() async {
    final Response reponse = await _dio.get('/legal-pages/contact-us');
    return TermsOfServiceModel.fromMap(reponse.data as Map<String, dynamic>);
  }

  @override
  Future<AboutUs> getAbout() async {
    final Response reponse = await _dio.get('/about-us');
    return AboutUs.fromMap(reponse.data as Map<String, dynamic>);
  }
}
