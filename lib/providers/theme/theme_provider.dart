import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/providers/theme/theme_state.dart';
import 'package:state_notifier/state_notifier.dart';

class ThemeProvider extends StateNotifier<ThemeState> {
  ThemeProvider() : super(ThemeState.initial());

  void changeTheme() {
    if (state.currentTheme == lightTheme) {
      state = state.copyWith(
        currentTheme: darkTheme,
        systemUiOverlayStyle: darkOverlay,
        fontColor: Colors.white,
      );
    } else {
      state = state.copyWith(
        currentTheme: lightTheme,
        systemUiOverlayStyle: lightOverlay,
        fontColor: Colors.black,
      );
    }
  }
}
