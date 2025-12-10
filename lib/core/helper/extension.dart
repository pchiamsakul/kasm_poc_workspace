import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String append(String? value) {
    if (value == null) return this;
    return this + value;
  }

  String prepend(String? value) {
    if (value == null) return this;
    return value + this;
  }

  String hashPassword() {
    final bytes = utf8.encode(this);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String maskPhoneNumber() {
    if (length < 10) return this;
    return replaceRange(3, 7, '****');
  }

  String formatPhone() {
    if (length < 10) return this;
    return '${substring(0, 3)}-${substring(3, 6)}-${substring(6, 10)}';
  }
}

extension IntExtension on int {
  String append(String? value) {
    if (value == null) return this.toString();
    return this.toString() + value;
  }
}

extension Extension<T> on T? {
  T orDefault(T value) {
    return this ?? value;
  }
}

extension ListExtension<T> on List<T> {
  T? getOrNull(int index) {
    if (index < 0 || index >= length) {
      return null;
    }
    return this[index];
  }

  List<List<T>> chunk(int size) {
    if (size <= 0) return []; // Return empty list for size 0 or less
    return List.generate((length / size).ceil(), (i) {
      int start = i * size;
      int end = (i + 1) * size > length ? length : (i + 1) * size;
      return sublist(start, end);
    });
  }
}

extension DoubleExtension on double {
  String get currency {
    return NumberFormat.currency(locale: 'th', symbol: '', decimalDigits: 0).format(this);
  }

  String toCurrency({int decimalDigits = 2}) {
    return NumberFormat.currency(locale: 'th', symbol: '', decimalDigits: decimalDigits)
        .format(this);
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy<R>(R Function(T) selector) {
    final seen = <R>{};
    return where((element) {
      final key = selector(element);
      if (seen.contains(key)) {
        return false;
      } else {
        seen.add(key);
        return true;
      }
    });
  }
}

String formatAddress(String address) {
  final newAddress = address
      .replaceAll("จัดส่ง", "")
      .replaceAll("ที่อยู่", "")
      .replaceAll("ทีอยู่", "")
      .replaceAll("ที่อยุ่", "")
      .split('\n')
      .where((line) => line.trim().isNotEmpty)
      .join('\n')
      .trim();
  return newAddress;
}
