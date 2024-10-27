import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

extension LoggerExtension on Logger {
  void errorStackTrace(Object error, StackTrace stackTrace, String functionName) {
    e('Error $functionName: ${error.toString()}\nStackTrace: ${stackTrace.toString()}');
  }
}

class LoggerService extends GetxService {
  MyLoggerOutput? _logOutput;
  Logger? _logger;

  static LoggerService get find => Get.find<LoggerService>();

  static Logger? get logger => Get.find<LoggerService>()._logger;

  static Future<String> get logHistory async => await Get.find<LoggerService>()._logOutput?.getLog() ?? '';

  LoggerService() {
    init();
  }

  Future<LoggerService> init({bool fileOutput = false}) async {
    if (fileOutput) {
      if (!kIsWeb) {
        try {
          final dynamic directory = await getApplicationDocumentsDirectory();
          _logOutput = FileOutput(file: File('${directory.path}/log_cache.txt'));
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        _logOutput = LogFileOutputWeb();
      }
    }
    _logger = Logger(
      output: MultiOutput(<LogOutput?>[ConsoleOutput(), _logOutput]),
      printer: PrettyPrinter(
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
        noBoxingByDefault: true,
        methodCount: 1,
        lineLength: 50,
      ),
    );
    return this;
  }
}

abstract class MyLoggerOutput extends LogOutput {
  Future<String> getLog();
}

class FileOutput extends MyLoggerOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  late IOSink _sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  Future<void> init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
    return super.init();
  }

  @override
  void output(OutputEvent event) {
    _sink.writeAll(event.lines, '\n');
  }

  @override
  Future<void> destroy() async {
    await _sink.flush();
    await _sink.close();
    return super.destroy();
  }

  @override
  Future<String> getLog() async {
    final String content = file.readAsStringSync(encoding: encoding);
    final int l = content.length;
    return l > 10000 ? content.substring(l - 10000, l) : content;
  }
}

class LogFileOutputWeb extends MyLoggerOutput {
  // @override
  // void init() {}

  @override
  void output(OutputEvent event) {}

  // @override
  // void destroy() async {}

  @override
  Future<String> getLog() async => '';
}
