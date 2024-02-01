import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import 'country_data_model.dart';

class LayoutConfig {
  final bool? isDismissible;

  /// If null, the style will be set to [TextStyle(fontSize: 14)]
  final TextStyle? textStyle;

  /// set sequence of country elements. By default it is select [flagCodeAndCountryName]
  final Sequence? elementsSequence;

  ///set width of the flag, by default is 24
  final double? flagWidth;

  /// set height of the flag, by default is 18
  final double? flagHeight;

  ///set decoration of the flag,
  final Decoration? flagDecoration;

  /// this properties is use for hide-show country name in our dialog list.
  final bool showCountryName;

  /// this properties is use for hide-show country flag in our dialog list.
  final bool showCountryFlag;

  /// this properties is use for hide-show country code in our dialog list.
  final bool showCountryCode;

  const LayoutConfig(
      {this.flagHeight,
      this.flagWidth,
      this.flagDecoration,
      this.isDismissible,
      this.textStyle,
      this.elementsSequence = Sequence.flagCodeAndCountryName,
      this.showCountryFlag = true,
      this.showCountryName = true,
      this.showCountryCode = true})
      : assert((showCountryFlag || showCountryCode || showCountryName), 'At-least one data we need to show in a our country list.');
}
