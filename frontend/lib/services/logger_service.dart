import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
    init(fileOutput: true);
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

  Future<XFile?> getLogFile({bool filterByDate = true}) async {
    if (!kIsWeb && _logOutput is FileOutput) {
      final logFile = (_logOutput as FileOutput).file;

      if (!filterByDate) {
        // Return the full log file if no filtering is required
        return XFile.fromData(logFile.readAsBytesSync(), name: 'log.txt', mimeType: 'txt', path: logFile.path);
      }

      // Read the log file content
      final lines = await logFile.readAsLines();
      final now = DateTime.now();

      // Find the index of the first line within the last 2 days
      int startIndex = 0;
      for (int i = 0; i < lines.length; i++) {
        final timestamp = _extractTimestamp(lines[i]);
        if (timestamp != null) {
          final difference = now.difference(timestamp);
          if (difference.inDays <= 2) {
            startIndex = i;
            break;
          }
        }
      }

      // Take all lines from the found index onward
      final filteredLogs = lines.sublist(startIndex).join('\n');

      // Write the filtered logs to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/filtered_log.txt');
      await tempFile.writeAsString(filteredLogs);

      // Return the filtered log file
      return XFile.fromData(tempFile.readAsBytesSync(), name: 'log.txt', mimeType: 'txt', path: '${tempDir.path}/filtered_log.txt');
    }
    return null;
  }

  DateTime? _extractTimestamp(String logLine) {
    try {
      // Adjust the pattern to match your log's timestamp format
      final timestampPattern = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}');
      final match = timestampPattern.firstMatch(logLine);

      if (match != null) {
        return DateTime.parse(match.group(0)!);
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
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
