import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:country_picker/src/country_selection_dialog.dart';
import 'package:flutter/material.dart';

class CountryPikersDialog extends StatefulWidget {
  /// it is optional argument to set your own custom country list
  final List<Map<String, String>> listOfCountries;

  final bool showCountryOnly;
  final BorderRadius? dialogBorderRadius;
  final Icon? closedDialogIcon;
  final WidgetBuilder? emptySearchBuilder;
  final EdgeInsetsGeometry? dialogItemPadding;
  final String? selectInitialCountry;
  final Decoration? flagDecoration;
  final bool hideCloseIcon;
  final Icon? searchIcon;
  final EdgeInsetsGeometry? searchPadding;
  final bool showFlag;
  final bool showSearchBar;
  final Size? size;
  final bool showCircularFlag;

  /// using this comparator to change the order of options.
  final Comparator<CountryCode>? comparator;

  final CountryPickerThemeData? countryPickerThemeData;

  /// used to customize the country list
  final List<String>? countryFilter;

  /// add your favorites countries
  final List<String>? favorite;

  const CountryPikersDialog(
      {super.key,
      this.listOfCountries = codes,
      this.countryFilter,
      this.comparator,
      this.selectInitialCountry,
      this.favorite,
      this.countryPickerThemeData,
      this.showCountryOnly = false,
      this.dialogBorderRadius,
      this.closedDialogIcon,
      this.dialogItemPadding,
      this.emptySearchBuilder,
      this.flagDecoration,
      this.hideCloseIcon = false,
      this.searchIcon,
      this.searchPadding,
      this.showFlag = true,
      this.showSearchBar = true,
      this.size,
      this.showCircularFlag = false});

  @override
  // ignore: no_logic_in_create_state
  State<CountryPikersDialog> createState() {
    List<CountryCode> countriesElements = listOfCountries.map((element) => CountryCode.fromJson(element)).toList();

    if (comparator != null) {
      countriesElements.sort(comparator);
    }

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = countryFilter?.map((e) => e.toUpperCase()).toList();
      countriesElements = countriesElements
          .where((element) =>
              uppercaseFilterElement!.contains(element.name) ||
              uppercaseFilterElement.contains(element.dialCode) ||
              uppercaseFilterElement.contains(element.code))
          .toList();
    }

    return _CountryPikersDialogState(countriesElements);
  }
}

class _CountryPikersDialogState extends State<CountryPikersDialog> {
  List<CountryCode> countriesElements = [];
  CountryCode? selectedItem;
  List<CountryCode> favoritesCountries = [];

  _CountryPikersDialogState(this.countriesElements);

  @override
  void initState() {
    super.initState();
    if (widget.selectInitialCountry != null) {
      selectedItem = countriesElements.firstWhere(
        (element) =>
            element.name == widget.selectInitialCountry?.toUpperCase() ||
            element.dialCode == widget.selectInitialCountry?.toUpperCase() ||
            element.code == widget.selectInitialCountry?.toUpperCase(),
        orElse: () => countriesElements[0],
      );
    }
    debugPrint('widget.favorite::${widget.favorite}');
    if (widget.favorite != null) {
      favoritesCountries = countriesElements.where((element) => widget.favorite?.contains(element.dialCode) ?? false).toList();
    }
  }

  @override
  void didUpdateWidget(covariant CountryPikersDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectInitialCountry != widget.selectInitialCountry) {
      if (widget.selectInitialCountry != null) {
        selectedItem = countriesElements.firstWhere(
          (element) =>
              element.name == widget.selectInitialCountry?.toUpperCase() ||
              element.dialCode == widget.selectInitialCountry?.toUpperCase() ||
              element.code == widget.selectInitialCountry?.toUpperCase(),
          orElse: () => countriesElements[0],
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    countriesElements = countriesElements.map((e) => e.localize(context)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCountryPickerDialog(context);
      },
      child: const Text("onTap"),
    );
  }

  Future<void> showCountryPickerDialog(BuildContext context) async {
    final selectedValue = await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            child: CountrySelectionDialog(
              countriesElements,
              favoritesCountries,
              showCircularFlag: widget.showCircularFlag,
              countryPickerThemeData: widget.countryPickerThemeData,
              showCountryOnly: widget.showCountryOnly,
              dialogBorderRadius: widget.dialogBorderRadius,
              closedDialogIcon: widget.closedDialogIcon,
              dialogItemPadding: widget.dialogItemPadding,
              emptySearchBuilder: widget.emptySearchBuilder,
              flagDecoration: widget.flagDecoration,
              hideCloseIcon: widget.hideCloseIcon,
              searchIcon: widget.searchIcon,
              searchPadding: widget.searchPadding,
              showFlag: widget.showFlag,
              showSearchBar: widget.showSearchBar,
              size: widget.size,
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        selectedItem = selectedValue;
        debugPrint('selectedItem::$selectedItem');
      });
    }
  }
}
