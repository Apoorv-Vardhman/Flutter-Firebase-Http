import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mvvm_angela/common/utils/codes.dart';
import 'package:synchronized/synchronized.dart' as synchronized;

import 'api_base_reponse.dart';

class ApiManager {
  static ApiManager? _singleton;
  static late Dio dio;
  static BaseOptions? options;
  static CancelToken cancelToken = CancelToken();
  static synchronized.Lock _lock = synchronized.Lock();

  static Future<ApiManager?> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          var singleton = ApiManager._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  Future _init() async {}

  /*
   * Configuration
   */
  ApiManager._() {
    //BaseOptions、Options、RequestOptions Parameters can be configured，Priority level increases，
    // And can override parameters according to priority level
    options = BaseOptions(
      //Request base address, can include subpath
      baseUrl: "https://run.mocky.io/v3/",
      //Timeout for connecting to the server, in milliseconds.
      connectTimeout: 60 * 1000,
      // connectTimeout: 100,
      //The interval between receiving data twice before and after the response stream, in milliseconds.
      receiveTimeout: 60 * 1000,
//      receiveTimeout: 100,
      //Http request header.
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.plain,
    );

    dio = Dio(options);

    //Add interceptor
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      return handler.next(e);
    }));
  }

  /*
   * Get Request
   */
  static Future<ApiBaseResponse> getRequest(url,
      {data, options, cancelToken}) async {
    Response response;
    ApiBaseResponse apiResponse;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_SUCCESS,
          apiResponse: response,
          apiError: null);
    } on DioError catch (e) {
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_FAILURE,
          apiResponse: null,
          apiError: formatError(e));
    }
    return apiResponse;
  }

  /*
   * Post Request
   */
  static Future<ApiBaseResponse> postRequest(url,
      {data, options, cancelToken}) async {
    Response response;
    ApiBaseResponse apiResponse;
    try {
      response = await dio.post(url,
          data: data, options: options, cancelToken: cancelToken);
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_SUCCESS,
          apiResponse: response,
          apiError: null);
    } on DioError catch (e) {
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_FAILURE,
          apiResponse: null,
          apiError: formatError(e));
    }
    return apiResponse;
  }

  /*
   * Put Request
   */
  static Future<ApiBaseResponse> putRequest(url,
      {data, options, cancelToken}) async {
    Response response;
    ApiBaseResponse apiResponse;
    try {
      response = await dio.put(url,
          data: data, options: options, cancelToken: cancelToken);
      ;
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_SUCCESS,
          apiResponse: response,
          apiError: null);
    } on DioError catch (e) {
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_FAILURE,
          apiResponse: null,
          apiError: formatError(e));
    }
    return apiResponse;
  }

  static Future<ApiBaseResponse> deleteRequest(url,
      {data, options, cancelToken}) async {
    Response response;
    ApiBaseResponse apiResponse;
    try {
      response = await dio.delete(url,
          data: data, options: options, cancelToken: cancelToken);
      ;
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_SUCCESS,
          apiResponse: response,
          apiError: null);
    } on DioError catch (e) {
      apiResponse = ApiBaseResponse(
          apiResponseCode: StatusCodes.API_FAILURE,
          apiResponse: null,
          apiError: formatError(e));
    }
    return apiResponse;
  }

  /*
   * Error unified processing
   */
  static String formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      return "Connection timed out";
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      return "Server request timed out";
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      return "Server response timeout";
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      return "Server is not responding. Please try again later";
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      return "Request cancellation";
    } else if (e.type == DioErrorType.other) {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      return "Something went wrong. Please try again later";
    } else
      return "Something went wrong. Please try again later";
  }

  /*
   * Cancel request
   *
   * The same cancel token can be used for multiple requests.
   * When a cancel token is canceled, all requests that use the cancel token will be canceled.
   * So the parameters are optional
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
