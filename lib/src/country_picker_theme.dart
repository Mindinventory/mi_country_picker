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
  final double? flagSize;

  ///The decoration used for the search field
  final InputDecoration? searchFieldInputDecoration;

  ///The border radius of country picker
  final BorderRadius? borderRadius;
  // ///Country list modal height
  // ///
  // /// By default it's fullscreen
  // final double? bottomSheetHeight;
  //
  // /// set the padding of the bottom
  // final EdgeInsets? padding;
  //
  // /// the margin of the bottom sheet
  // final EdgeInsets? margin;

  const CountryPickerThemeData({
    this.backgroundColor,
    this.textStyle,
    this.searchTextStyle,
    this.flagSize,
    this.searchFieldInputDecoration,
    this.borderRadius,
    // this.bottomSheetHeight,
    // this.padding,
    // this.margin,
  });
}
