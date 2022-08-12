import 'package:flutter/material.dart';

final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        color: Colors.orange[400],
        iconTheme: const IconThemeData(color: Colors.white)),
    iconTheme: const IconThemeData(color: Colors.black),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.orange[400],
      foregroundColor: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        )),
    toggleableActiveColor: Colors.green,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.white,
      selectedItemColor: Colors.orange[400],
      elevation: 100,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(brightness: Brightness.light, secondary: Colors.orange[400]),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.orange[400],
        selectionHandleColor: Colors.orange[400]),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
        selectedColor: Colors.orange[400]!,
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[500]!,
        padding: const EdgeInsets.all(4),
        disabledColor: Colors.grey,
        labelStyle: const TextStyle(color: Colors.white),
        secondarySelectedColor: Colors.black),
    tabBarTheme: TabBarTheme(
        indicator: ShapeDecoration(
      shape: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.orange[400]!, width: 2, style: BorderStyle.solid)),
    )));

final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        Colors.grey[800], // Color that appear when reaching top of list
    appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        color: Colors.grey[850],
        iconTheme: const IconThemeData(color: Colors.white)),
    iconTheme: const IconThemeData(color: Colors.white),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.orange, foregroundColor: Colors.white),
    dialogBackgroundColor: Colors.grey[800], // Bubble under cursor
    inputDecorationTheme: const InputDecorationTheme(
        // Style of text fields
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2.0),
        )),
    toggleableActiveColor: Colors.green,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.grey[800],
      selectedItemColor: Colors.orange[400],
      elevation: 100,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(brightness: Brightness.dark, secondary: Colors.grey[350]),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.orange, selectionHandleColor: Colors.orange),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
        selectedColor: Colors.orange[400]!,
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        brightness: Brightness.light,
        backgroundColor: Colors.grey[500]!,
        padding: const EdgeInsets.all(4),
        disabledColor: Colors.grey,
        labelStyle: const TextStyle(color: Colors.white),
        secondarySelectedColor: Colors.black),
    tabBarTheme: TabBarTheme(
        indicator: ShapeDecoration(
      shape: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.orange[400]!, width: 2, style: BorderStyle.solid)),
    )));
