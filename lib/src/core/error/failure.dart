import 'dart:io';

import 'package:dio/dio.dart';

class AppFailure {
  final String message;
  final String? code;

  const AppFailure({required this.message, this.code});

  factory AppFailure.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const AppFailure(message: 'Connection timed out');
      case DioExceptionType.sendTimeout:
        return const AppFailure(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return const AppFailure(message: 'Receive timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? 'Unexpected error occurred';
        return AppFailure(message: message, code: statusCode?.toString());
      case DioExceptionType.cancel:
        return const AppFailure(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return const AppFailure(message: 'No Internet Connection');
        }
        return const AppFailure(message: 'Connection error');
      case DioExceptionType.unknown:
      default:
        return AppFailure(message: e.message ?? 'Unknown error');
    }
  }
}
