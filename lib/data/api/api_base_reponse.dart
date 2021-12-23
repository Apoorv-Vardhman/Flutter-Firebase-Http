import 'package:dio/dio.dart';

class ApiBaseResponse {
  final String? apiError;
  final int? apiResponseCode;
  final Response? apiResponse;

  ApiBaseResponse({this.apiResponseCode, this.apiError, this.apiResponse});
}
