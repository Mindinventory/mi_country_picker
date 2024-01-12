import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:country_picker/src/country_selection_dialog.dart';
import 'package:flutter/material.dart';

class CountryPikersDialog extends StatefulWidget {
  /// it is optional argument to set your own custom country list
  final List<Map<String, String>> listOfCountries;

  /// this parameter is use to remove particular country from our list.
  final List<String>? excludeCountry;

  /// this properties is use for hide-show country flag in our screen.
  final bool showCountryMainFlag;

  /// this properties is use for hide-show country name in our screen.
  final bool showCountryMainName;

  /// this properties is use for hide-show country code in our screen.
  final bool showCountryMainCode;

  /// text overflow in use to manage text overflow for country name.
  final TextOverflow textOverflow;

  final void Function(CountryCode value)? getCountryData;
  final double? flagWidth;
  final double? flagHeight;
  final Color? barrierColor;
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
      this.showCountryMainFlag = true,
      this.showCountryMainCode = true,
      this.showCountryMainName = true,
      this.textOverflow = TextOverflow.ellipsis,
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
      this.showCircularFlag = false,
      this.excludeCountry,
      this.barrierColor,
      this.getCountryData,
      this.flagWidth,
      this.flagHeight})
      : assert((showCountryMainFlag || showCountryMainCode || showCountryMainName), 'At-least one data we need to show in a widget.'),
        assert(((excludeCountry == null) || (countryFilter == null)),
            'We will provide either exclude country or country filter, So we are not providing both at a same time.');

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
    } else {
      selectedItem = countriesElements[0];
      widget.getCountryData!(selectedItem!);
    }
    if (widget.excludeCountry != null && widget.excludeCountry!.isNotEmpty) {
      for (int i = 0; i < (widget.excludeCountry?.length ?? 0); i++) {
        for (int j = 0; j < countriesElements.length; j++) {
          if ((widget.excludeCountry?[i].toLowerCase() == countriesElements[j].name?.toLowerCase()) ||
              (widget.excludeCountry?[i] == countriesElements[j].dialCode) ||
              (widget.excludeCountry?[i].toUpperCase() == countriesElements[j].code)) {
            countriesElements.removeAt(j);
            break;
          }
        }
      }
    }
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
      onTap: showCountryPickerDialog,
      child: TextButton(
        onPressed: () {
          showCountryPickerDialog();
        },
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.showCountryMainFlag)
              Container(
                clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                decoration: widget.flagDecoration,
                margin: const EdgeInsets.only(right: 12),
                child: Image.asset(
                  selectedItem!.flagUri!,
                  package: 'country_picker',
                  width: widget.flagWidth ?? 32,
                  height: widget.flagHeight ?? 20,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              '${widget.showCountryMainCode ? selectedItem!.dialCode ?? '' : ''} ${widget.showCountryMainName ? selectedItem!.name! : ''}',
              style: widget.countryPickerThemeData?.textStyle ?? const TextStyle(fontSize: 16),
              overflow: widget.textOverflow,
            ),
          ],
        ),
      ),
    );
  }

  void showCountryPickerDialog() async {
    final selectedValue = await showDialog(
      barrierColor: widget.barrierColor,
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            surfaceTintColor: Colors.blue,
            child: CountrySelectionDialog(
              countriesElements,
              favoritesCountries,
              flagHeight: widget.flagHeight,
              flagWidth: widget.flagWidth,
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
        widget.getCountryData!(selectedItem!);
        debugPrint('selectedItem::$selectedItem');
      });
    }
  }
}
