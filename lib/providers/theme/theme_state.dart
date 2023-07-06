import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/shared_pref_model.dart';

ThemeData darkTheme = ThemeData.dark();

ThemeData lightTheme = ThemeData.light();

SystemUiOverlayStyle lightOverlay = SystemUiOverlayStyle(
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: lightTheme.scaffoldBackgroundColor,
);
SystemUiOverlayStyle darkOverlay = SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: darkTheme.scaffoldBackgroundColor,
);

class ThemeState extends Equatable {
  final ThemeData currentTheme;
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final Color fontColor;

  const ThemeState({
    required this.currentTheme,
    required this.systemUiOverlayStyle,
    required this.fontColor,
  });

  factory ThemeState.initial() {
    return ThemeState(
      currentTheme: SharedPrefModel.darkMode ? darkTheme : lightTheme,
      systemUiOverlayStyle:
          SharedPrefModel.darkMode ? darkOverlay : lightOverlay,
      fontColor: SharedPrefModel.darkMode ? Colors.white : Colors.black,
    );
  }

  @override
  List<Object?> get props => [currentTheme, systemUiOverlayStyle, fontColor];

  ThemeState copyWith({
    ThemeData? currentTheme,
    SystemUiOverlayStyle? systemUiOverlayStyle,
    Color? fontColor,
  }) {
    return ThemeState(
      currentTheme: currentTheme ?? this.currentTheme,
      systemUiOverlayStyle: systemUiOverlayStyle ?? this.systemUiOverlayStyle,
      fontColor: fontColor ?? this.fontColor,
    );
  }
}
