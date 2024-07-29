// External packages
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Core module imports
import 'package:core/src/log/conf_log.dart';

class Log extends Logger {
  Log({super.printer});

  @override
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final log = ConfLog.d(message: message);
      logs.add(log);
      super.d(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final log = ConfLog.e(message: message);
      logs.add(log);
      super.e(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final log = ConfLog.i(message: message);
      logs.add(log);
      super.i(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final log = ConfLog.t(message: message);
      logs.add(log);
      super.t(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final log = ConfLog.w(message: message);
      logs.add(log);
      super.w(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final log = ConfLog.f(message: message);
      logs.add(log);
      super.f(message, error: error, stackTrace: stackTrace);
    }
  }
}

List<ConfLog> logs = [];
