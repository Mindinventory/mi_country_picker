import 'country_data_model.dart';

class CountryListConfig {
  /// to filter countries.
  final List<String>? countryFilter;

  /// using this comparator to change the order of options.
  final Comparator<CountryData>? comparator;

  /// this parameter is used to remove particular countries from our list.
  final List<String>? excludeCountry;

  CountryListConfig({this.countryFilter, this.excludeCountry, this.comparator})
      : assert(((excludeCountry == null) || (countryFilter == null)), 'either provide excludeCountry or countryFilter');
}
