import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';

import '../localizations.dart';

class CountryCode {
  String? countryName;
  String? countryFlag;
  String? countryCode;
  String? countryDialCode;

  CountryCode({
    this.countryName,
    this.countryFlag,
    this.countryCode,
    this.countryDialCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      countryName: json['name'],
      countryCode: json['code'],
      countryDialCode: json['dial_code'],
      countryFlag: 'assets/flags/${json['code'].toLowerCase()}.png',
    );
  }

  CountryCode localize(BuildContext context) {
    return this..countryName = CountryPickerLocalizations.of(context)?.translate(countryCode) ?? countryName;
  }

  @override
  String toString() => "$countryDialCode";

  String toLongString() => "$countryDialCode ${toCountryStringOnly()}";

  String toCountryStringOnly() {
    return '$_name';
  }

  String? get _name {
    return countryName?.replaceAll(RegExp(r'[[\]]'), '').split(',').first;
  }
}
