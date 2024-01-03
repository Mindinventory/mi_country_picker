import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';

import '../localizations.dart';


class CountryCode {
  String? name;
  String? flagUri;
  String? code;
  String? dialCode;

  CountryCode({
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'],
      code: json['code'],
      dialCode: json['dial_code'],
      flagUri: 'assets/flags/${json['code'].toLowerCase()}.png',
    );
  }

  CountryCode localize(BuildContext context) {
    return this
      ..name = CountryPickerLocalizations.of(context)?.translate(code) ?? name;
  }

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode ${toCountryStringOnly()}";

  String toCountryStringOnly() {
    return '$_cleanName';
  }

  String? get _cleanName {
    return name?.replaceAll(RegExp(r'[[\]]'), '').split(',').first;
  }
}
