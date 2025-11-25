import 'dart:developer' as developer;

import 'package:clock/clock.dart';
import 'package:flutter_fimber/flutter_fimber.dart';

class CustomLogTree extends LogTree {
  @override
  List<String> getLevels() {
    return ['D', 'I', 'W', 'E', 'V'];
  }

  @override
  void log(
    String level,
    String message, {
    String? tag,
    ex,
    StackTrace? stacktrace,
  }) {
    final logTag = tag ?? LogTree.getTag();
    if (ex != null) {
      final tmpStacktrace =
          stacktrace?.toString().split('\n') ?? LogTree.getStacktrace();
      final stackTraceMessage = tmpStacktrace
          .map((stackLine) => '\t$stackLine')
          .join('\n');
      printLog(
        '$message \n'
        '${ex.toString()}\n$stackTraceMessage',
        level: level,
        tag: logTag,
      );
    } else {
      printLog(message, level: level, tag: logTag);
    }
  }

  void printLog(String logLine, {String? level, String? tag}) {
    final date = clock.now();
    developer.log(logLine, name: _loggerName(level, date, tag));
  }

  String _loggerName(String? level, DateTime dateTime, String? tag) {
    final str = StringBuffer('');
    str.write(dateTime.hour.toString().padLeft(2, '0'));
    str.write(':');
    str.write(dateTime.minute.toString().padLeft(2, '0'));
    str.write(':');
    str.write(dateTime.second.toString().padLeft(2, '0'));
    str.write(']');
    str.write(' [$tag]'.padLeft(22));
    str.write(' [${_levelName(level)}');

    return str.toString();
  }

  String _levelName(String? level) {
    switch (level) {
      case 'V':
        return '💜';
      case 'D':
        return '💙';
      case 'I':
        return '💛';
      case 'W':
        return '🧡';
      case 'E':
        return '💔';
      default:
        return '';
    }
  }
}
