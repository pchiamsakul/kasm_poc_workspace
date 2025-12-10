import 'package:flutter/material.dart';

class KColors {
  const KColors._();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static Color shadowColor = Colors.brown.withValues(alpha: 0.05); // เงาครีมพาสเทล
  static Color shadowColor2 = Colors.orange.withValues(alpha: 0.03); // เงาบางอ่อน

  static const blackOlive = Color(0xFF7A7A7A); // สีเทารอง
  static const equator = Color(0xFFFFE0B2); // สีส้มพาสเทล
  static const mako = Color(0xFFCBF5E9); // สีเขียวมิ้นท์พาสเทล
  static const blueRibbon = Color(0xFFB0D8FF); // สีฟ้าพาสเทล
  static const pomegranate = Color(0xFFE57373); // สีแดงพาสเทล

  static const gallery = Color(0xFFF0F0F0); // สีพื้นกล่องจาง
  static const grey = Color(0xFF555555);
  static const darkGrey = Color(0xFF333333);
  static const green = Color(0xFF81C784); // เขียวพาสเทล

  static const primary = Color(0xFFD8AD80); // สีหลัก
  static const primaryLight = Color(0xFFEFD3B0); // สีหลัก
  static const primaryDark = Color(0xFFAC7E4D); // สีหลัก
  static const primary50 = Color(0xFFF4E2CF); // สีอ่อน 50%
  static const primary20 = Color(0xFFFBF4ED); // สีอ่อนมาก 20%
  static const primaryDark2 = Color(0xFF7B5131); // สีน้ำตาลเข้ม

  static const secondary = Color(0xFFD36F72); // สีหลัก
  static const secondaryLight = Color(0xFFE6A4A6); // สีหลัก
  static const secondaryDark = Color(0xFFB15053); // สีหลัก
  static const secondary50 = Color(0xFFE8A3A5); // สีอ่อน 50%
  static const secondary20 = Color(0xFFF3D3D3); // สีอ่อนมาก 20%
  static const secondaryLight30 = Color(0x4DF3D3D3); // สีอ่อนมาก alpha 30%

  static const lightGrey = Color(0xFFE5E5E5);
  static const midGrey = Color(0xFFA8A8A8);
  static const red = Color(0xffED4348); // สีแดงพาสเทล
  static const carotte = Color(0xffF64D0F);

  static const textDefaultColor = primaryDark; // สีข้อความปกติ
  static const textJnColor = primaryDark2;
  static const bg = Color(0xFFFFF9F0); // พื้นหลังครีมอ่อนพาสเทล
}
