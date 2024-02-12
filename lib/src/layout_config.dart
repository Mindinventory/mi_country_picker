import 'package:mi_country_picker/mi_country_picker.dart';
import 'package:flutter/material.dart';

class LayoutConfig {
  /// If null, the style will be set to [TextStyle(fontSize: 14)]
  final TextStyle? textStyle;

  /// set sequence of dialing code, country name and flag
  final Sequence elementsSequence;

  ///set width of the flag
  final double flagWidth;

  /// set height of the flag
  final double flagHeight;

  ///set decoration of the flag
  final Decoration? flagDecoration;

  /// show-hide country name.
  final bool showCountryName;

  /// show-hide country flag.
  final bool showCountryFlag;

  /// show-hide country code.
  final bool showCountryCode;

  const LayoutConfig({
    this.flagHeight = 18,
    this.flagWidth = 24,
    this.flagDecoration,
    this.textStyle,
    this.elementsSequence = Sequence.flagCodeAndCountryName,
    this.showCountryFlag = true,
    this.showCountryName = true,
    this.showCountryCode = true,
  }) : assert((showCountryFlag || showCountryCode || showCountryName), 'At-least one data we need to show in a our country list.');
}

class SearchStyle {
  final InputDecoration? searchFieldInputDecoration;
  final TextStyle? searchTextStyle;
  final String? hintText;
  final double? searchBoxHeight;
  final Icon? searchIcon;
  final EdgeInsetsGeometry? searchBoxMargin;

  SearchStyle({
    this.searchBoxMargin,
    this.searchFieldInputDecoration,
    this.searchTextStyle,
    this.hintText,
    this.searchBoxHeight,
    this.searchIcon,
  });
}
