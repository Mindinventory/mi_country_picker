import 'package:flutter/material.dart';

class CountryPickerThemeData {
  /// The country bottom sheet's background color.
  /// If null, [backgroundColor] defaults to [BottomSheetThemeData.backgroundColor].
  final Color? backgroundColor;

  ///The style to use for country name text.
  ///
  /// If null, the style will be set to [TextStyle(fontSize: 16)]
  final TextStyle? textStyle;

  ///The style to use for search box text.
  ///
  /// If null, the style will be set to [TextStyle(fontSize: 16)]
  final TextStyle? searchTextStyle;

  ///The flag size.

  /// If null, set to 25

  ///The decoration used for the search field
  final InputDecoration? searchFieldInputDecoration;

  ///The border radius of country picker
  final BorderRadius? borderRadius;

  ///
  final Color? modalBackgroundColor;
  final Color? modalBarrierColor;
  final double? modalElevation;
  final Clip? clipBehavior;

  const CountryPickerThemeData({
    this.backgroundColor,
    this.textStyle,
    this.searchTextStyle,
    this.searchFieldInputDecoration,
    this.borderRadius,
    this.modalBackgroundColor,
    this.modalBarrierColor,
    this.modalElevation,
    this.clipBehavior,
  });
}
