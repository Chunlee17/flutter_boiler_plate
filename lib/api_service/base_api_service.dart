import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import '../constant/app_constant.dart';
import 'base_http_exception.dart';

class BaseApiService {
  final dio = Dio()
    ..options.baseUrl = AppConstant.BASE_URL
    ..options.connectTimeout = 20000
    ..options.receiveTimeout = 20000;
  static JsonDecoder decoder = JsonDecoder();
  static JsonEncoder encoder = JsonEncoder.withIndent('  ');

  BaseApiService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          if (options.method == "GET") {
            print(
                "${options.method}: ${options.path}, query: ${options.queryParameters}");
          } else {
            print("${options.method}: ${options.path}, data: ${options.data},"
                " query: ${options.queryParameters}");
          }
          return options;
        },
        onResponse: (Response response) async {
          //prettyPrintJson(response.data);
          return response; // continue
        },
        onError: (DioError error) async {
          return error; //continue
        },
      ),
    );

    dio.interceptors.add(
      DioCacheManager(
        CacheConfig(baseUrl: AppConstant.BASE_URL),
      ).interceptor,
    );
  }

  void prettyPrintJson(dynamic input) {
    //convert map to json String
    var prettyString = encoder.convert(input);
    prettyString.split('\n').forEach((element) => print(element));
  }

  Future<T> onRequest<T>(Function onHttpRequest) async {
    try {
      return await onHttpRequest();
    } on TypeError catch (exception) {
      print("Type Error Exception: ${exception.toString()}");
      print("Stack trace: ${exception.stackTrace.toString()}");
      throw exception;
    } on DioError catch (exception) {
      print("Dio Exception: ${exception.toString()}");
      if (exception.error is SocketException) {
        throw DioErrorException(ErrorMessage.CONNECTION_ERROR);
      } else if (exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw DioErrorException(ErrorMessage.TIMEOUT_ERROR);
      } else if (exception.type == DioErrorType.RESPONSE) {
        throw DioErrorException(
            "${exception.response.statusCode}: ${ErrorMessage.UNEXPECTED_ERROR}");
      } else {
        throw ServerErrorException(ErrorMessage.UNEXPECTED_ERROR);
      }
    } catch (exception) {
      print("Server error message: $exception");
      throw ServerResponseException(exception.toString());
    }
  }
}
