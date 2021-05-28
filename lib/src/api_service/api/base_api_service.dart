import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../../constant/app_constant.dart';
import '../../services/auth_service.dart';
import '../../utils/logger.dart';
import '../client/http_client.dart';
import '../client/http_exception.dart';

class BaseApiService {
  late Dio dio;

  BaseApiService({Dio? dio}) {
    if (dio == null) {
      this.dio = dio ?? BaseHttpClient.dio;
    } else {
      this.dio = dio;
    }
  }

  final String DATA_FIELD = "data";
  final String ERROR_MESSAGE_FIELD = "message";

  ///Create an Http request method that required path and a callback functions [onSuccess]
  ///default Http method is [GET]
  Future<T> onRequest<T>({
    required String path,
    required T Function(Response) onSuccess,
    String method = HttpMethod.GET,
    Map<String, dynamic>? query,
    Map<String, dynamic> headers = const {},
    dynamic data = const {},
    bool requiredToken = true,
    String? customToken,
    Dio? customDioClient,
  }) async {
    Response? response;
    try {
      final httpOption = Options(method: method, headers: {});
      if (requiredToken && AppConstant.TOKEN != null) {
        bool isExpired = SuraJwtDecoder.decode(AppConstant.TOKEN!).isExpired;
        if (isExpired) {
          await AuthService.refreshUserToken();
        }
        httpOption.headers!['Authorization'] = "bearer ${AppConstant.TOKEN}";
      }
      if (customToken != null) {
        httpOption.headers!['Authorization'] = "bearer $customToken";
      }
      httpOption.headers!.addAll(headers);
      if (customDioClient != null) {
        response = await customDioClient.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: data,
        );
      } else {
        response = await dio.request(
          path,
          options: httpOption,
          queryParameters: query,
          data: data,
        );
      }

      ///This condition may be depend on Response and your API
      //return onSuccess(response);
      if (response.data['status'] == true) {
        return onSuccess(response);
      } else {
        throw ServerResponseException(response.data['message']);
      }
    } on DioError catch (exception) {
      throw _onDioError(exception);
    } on ServerResponseException catch (exception) {
      throw _onServerResponseException(exception, response!);
    } catch (exception) {
      throw _onTypeError(exception);
    }
  }
}

String _onTypeError(dynamic exception) {
  //Logic or syntax error on some condition
  errorLog("Type Error :=> ${exception.toString()}\nStackTrace:  ${exception.stackTrace.toString()}");
  return ErrorMessage.UNEXPECTED_TYPE_ERROR;
}

DioErrorException _onDioError(DioError exception) {
  _logDioError(exception);
  if (exception.error is SocketException) {
    ///Socket exception mostly from internet connection or host
    return DioErrorException(ErrorMessage.CONNECTION_ERROR);
  } else if (exception.type == DioErrorType.connectTimeout) {
    ///Connection timeout due to internet connection or server not responding
    return DioErrorException(ErrorMessage.TIMEOUT_ERROR);
  } else if (exception.type == DioErrorType.response) {
    ///Error that range from 400-500
    String serverMessage;
    if (exception.response!.data is Map) {
      serverMessage = exception.response?.data["message"] ?? ErrorMessage.UNEXPECTED_ERROR;
    } else {
      serverMessage = ErrorMessage.UNEXPECTED_ERROR;
    }
    return DioErrorException(serverMessage, code: exception.response!.statusCode);
  }
  throw DioErrorException(ErrorMessage.UNEXPECTED_ERROR);
}

void _logDioError(DioError exception) {
  String errorMessage = "Dio error :=> ${exception.requestOptions.path}";
  if (exception.response != null) {
    errorMessage += ", Response: => ${exception.response!.data.toString()}";
  } else {
    errorMessage += ", ${exception.message}";
  }
  httpLog(errorMessage);
}

ServerResponseException _onServerResponseException(dynamic exception, Response response) {
  httpLog("Server error :=> ${response.requestOptions.path}:=> $exception");
  return ServerResponseException(exception.toString());
}
