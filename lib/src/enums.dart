import 'package:flutter/material.dart';

enum Brightness {
  system,
  light,
  dark;

  // Brightness brightness(BuildContext context) {
  //   switch (this) {
  //     case Brightness.dark:
  //       return Brightness.dark;
  //     case Brightness.light:
  //       return Brightness.light;
  //     default:
  //       try {
  //         return View.of(context).platformDispatcher.platformBrightness;
  //       } catch (e) {
  //         debugPrint("Failed to load the brightness $e");
  //       }
  //   }
  // }
}
