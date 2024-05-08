import 'package:flutter/material.dart';

class ColorCollection {
  /// App Bar Color Collection
  static Color? lightModeAppBarColor = Colors.blue[900];
  static Color? darkModeAppBarColor = Colors.black;

  /// Bottom Navigation Bar Color Collection
  static Color? bottomNavigationBarLightBgColor = Colors.white;
  static Color? bottomNavigationBarDarkBgColor = const Color(0xff3b403b);
  static Color? bottomBarIconUnselectedDarkItemColor = Colors.black;
  static Color? bottomBarIconUnselectedLightItemColor = Colors.white54;
  static Color? bottomBarIconSelectedLightItemColor = Colors.blue[900];
  static Color? bottomBarIconSelectedDarkItemColor = Colors.white70;
  static Color? yellowColor = Colors.yellow[100];

  /// Tile Color Collection
  static Color? tileLightModeColor = Colors.white;
  static Color? tileDarkModeColor = const Color(0xFF3E4651);

  /// Shadow Color Collection
  static Color? shadowColor = Colors.black12;

  /// News Tile Color Collection
  static Color? newsTileLightModeColor = Colors.green[50];
  static Color? newsTileDarkModeColor = const Color(0xff1a1b1b);
  static Color? newsTileLightModeTextColor = Colors.black;
  static Color? newsTileDarkModeTextColor = Colors.white;

  /// ExpansionTile Color Collection
  static Color? expansionTileLightModeColor = const Color(0xff829ee5);
  static Color? expansionTileDarkModeColor = const Color(0xff303238);
  static Color? expansionTileTextColor = Colors.white;

  /// Icon Color Collection
  static Color? iconLightModeColor = Colors.black;
  static Color iconDarkModeColor = Colors.white;
  static Color? iconSelectedColor = Colors.blue[900];

  /// Drawer Menu Item Color Collection
  static Color? drawerLightModeItemColor = Colors.black;
  static Color drawerDarkModeItemColor = Colors.white;
  static Color? drawerLightModeItemSecondaryColor = Colors.blue[900];
  static Color? drawerLightModeItemSpecialColor = Colors.redAccent;
  static Color? drawerExiFromAppColor = Colors.blue;
  static Color? drawerDividerLightModeColor = Colors.grey[400];
  static Color? drawerDividerDarkModeColor = Colors.white70;
  static Color? drawerThemeItemColor = Colors.redAccent;

  static Color transparentColor = Colors.transparent;

  /// Tab Selection Color Collection
  static Color? tabSelectedColor = Colors.blue[900];

  static Color? modalColor = Colors.white;

  static Color toastBgColor = Colors.black54;

  static const selectedTabColor = Color(0xffdb7356);
  static Color labelTextColor = const Color(0xFF0D47A1);

  static Color textFieldColor = const Color(0xFF303030);

  static const popUpGreyColor = Color(0xff63676c);

  static Color pureWhiteColor = Colors.white;
  static Color pureBlackColor = Colors.black;
  static Color pureBlueColor = Colors.blue;

  static Color convertColor(String color) {
    String c1 = '0xFF';
    String c2 = color.substring(1);
    String c3 = c1 + c2;
    return Color(int.parse(c3));
  }

  /// Radio Color Collection
  static const radioBackgroundColor = Color(0xff272e38);
  static const radioTileColor = Color(0xff3f4650);
}
