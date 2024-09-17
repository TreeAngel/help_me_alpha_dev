import 'package:dio/dio.dart';
import '../../models/api_error_response/message_error_model.dart';

class ApiException {
  Map<String, dynamic> apiException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return {
          'error': 'Connection timeout, try again after a few seconds',
        };
      case DioExceptionType.receiveTimeout:
        return {
          'error': 'Failed to receive data, try again after a few seconds',
        };
      case DioExceptionType.sendTimeout:
        return {
          'error': 'Failed to send data, try again after a few seconds',
        };
      case DioExceptionType.badCertificate:
        return {
          'error':
              'Failed to validate certificate, try again after a few seconds',
        };
      case DioExceptionType.badResponse:
        if (dioException.response?.statusCode == 400) {
          return {
            'error': 'Bad Request',
          };
        } else if (dioException.response?.statusCode == 401) {
          return {
            'error': 'Unauthorized',
          };
          // } else if (dioException.response?.statusCode == 403) {
          //   return {
          //     'error': 'Acount is inactive'
          //   };
          // }
        } else {
          return {
            'error': 'Failed to process data, try again after a few seconds',
          };
        }
      case DioExceptionType.cancel:
        return {
          'error':
              'Network request was cancelled, try again after a few seconds',
        };
      case DioExceptionType.connectionError:
        return {
          'error': 'Connection error, try again after a few seconds',
        };
      case DioExceptionType.unknown:
        return {
          'error': 'An error occurred, try again after a few seconds',
        };
    }
  }

  static String errorMessageBuilder(MessageErrorModel errorModel) {
    String errorMessage = '';
    if (errorModel.error != null) {
      errorMessage += '${errorModel.error}, ';
    }
    if (errorModel.message != null) {
      errorMessage += '${errorModel.message}, ';
    }
    if (errorModel.fullname != null) {
      errorMessage += '${errorModel.fullname}, ';
    }
    if (errorModel.username != null) {
      errorMessage += '${errorModel.username}, ';
    }
    if (errorModel.phoneNumber != null) {
      errorMessage += '${errorModel.phoneNumber}, ';
    }
    if (errorModel.password != null) {
      errorMessage += '${errorModel.password}, ';
    }
    if (errorModel.email != null) {
      errorMessage += '${errorModel.email}, ';
    }
    if (errorModel.role != null) {
      errorMessage += '${errorModel.role}, ';
    }
    errorMessage = errorMessage.trim();
    errorMessage = errorMessage.endsWith(',')
        ? errorMessage.substring(
            errorMessage.length - errorMessage.length, errorMessage.length)
        : errorMessage;
    return errorMessage;
  }
}
