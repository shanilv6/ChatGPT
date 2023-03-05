import 'package:flutter/material.dart';

import 'const.dart';

class Styles {
  static ThemeData themeData(bool isWhiteTheme, BuildContext context) {
    return ThemeData(
        appBarTheme: AppBarTheme(color: isWhiteTheme ?Colors.grey.shade200:ColorConstant.cardColor),
        scaffoldBackgroundColor: isWhiteTheme ?ColorConstant.scaffoldLightBackgroundColor : ColorConstant.scaffoldDarkBackgroundColor);

  }
}