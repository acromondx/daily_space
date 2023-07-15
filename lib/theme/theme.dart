import 'package:flutter/material.dart';

class AppTheme {
  static TextTheme darkTextTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: "JetBrains Mono",
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.blueGrey,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontFamily: "JetBrains Mono",
      fontSize: 14.0,
      color: Colors.blueGrey,
    ),
    titleMedium: TextStyle(
      fontFamily: "JetBrains Mono",
      fontSize: 13.0,
      color: Colors.blueGrey,
    ),
  );

  ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.amber,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
          fontFamily: "JetBrains Mono",
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.grey.shade100,
          indicatorColor: Colors.grey.shade800,
          elevation: 1,
          iconTheme: MaterialStateProperty.all(
              IconThemeData(color: Colors.grey.shade200)),
          labelTextStyle: MaterialStateProperty.all(TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade300))),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
      ),
      textTheme: darkTextTheme,
    );
  }
}
