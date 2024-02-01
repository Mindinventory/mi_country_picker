import 'country_data_model.dart';

class CountryListConfig {
  /// used to customize the country list,
  final List<String>? countryFilter;

  /// using this comparator to change the order of options.
  final Comparator<CountryData>? comparator;

  /// add your favorites countries
  final List<String>? favorite;

  /// this parameter is use to remove particular country from our list.
  final List<String>? excludeCountry;

  /// set your initial Country
  final String? selectInitialCountry;

  CountryListConfig({this.favorite, this.countryFilter, this.excludeCountry, this.selectInitialCountry, this.comparator})
      : assert(((excludeCountry == null) || (countryFilter == null)),
            'We will provide either exclude country or country filter, So we are not providing both at a same time.'),
        assert(((excludeCountry != null) ? (!excludeCountry.contains(selectInitialCountry)) : true),
            'excludeCountry list should be not contain selectInitialCountry value');
}
