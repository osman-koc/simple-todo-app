import 'package:flutter/material.dart';

class AppColors {
  final BuildContext context;

  AppColors(this.context);

  bool get isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get tdDeepOrange => Colors.deepOrange;
  Color get tdDeepOrangeAccent => Colors.deepOrangeAccent;
  Color get tdGrey => Colors.grey;
  Color get tdGreen => Colors.green;
  Color get tdBlue => Colors.blue;

  Color get tdTextColor {
    return isDarkMode ? Colors.white : Colors.black;
  }
  Color get tdTextColorDone {
    return isDarkMode ? Colors.white70 : Colors.grey[600]!;
  }

  Color get tdBGColor {
    return isDarkMode ? const Color(0xFF161616) : Colors.white;
  }

  Color get tdInputBgColor {
    return isDarkMode ? const Color(0xFF363636) : const Color(0xFFEEEFF5);
  }
  Color get tdInputBgColorDone {
    return isDarkMode ? const Color(0xFF202020) : const Color(0xFFF6F7FA);
  }

  Color get tdButtonColor {
    return const Color.fromARGB(255, 253, 112, 73);
  }
}
