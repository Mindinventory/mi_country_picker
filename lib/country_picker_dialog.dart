import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:country_picker/src/country_selection_dialog.dart';
import 'package:flutter/material.dart';

class CountryPickerDialog extends StatefulWidget {
  /// it is optional argument to set your own custom country list
  final List<Map<String, String>> listOfCountries;

  /// this parameter is use to remove particular country from our list.
  final List<String>? excludeCountry;

  /// this properties is use for hide-show country flag in our screen.
  final bool showCountryMainFlag;

  /// this properties is use for hide-show country flag in our dialog list.
  final bool showCountryFlag;

  /// this properties is use for hide-show country code in our dialog list.
  final bool showCountryCode;

  /// this properties is use for hide-show country name in our dialog list.
  final bool showCountryName;

  /// this properties is use for hide-show country name in our screen.
  final bool showCountryMainName;

  /// this properties is use for hide-show country code in our screen.
  final bool showCountryMainCode;

  /// text overflow in use to manage text overflow for country name.
  final TextOverflow textOverflow;

  /// set sequence of country elements. By default it is select [flagCodeAndCountryName]
  final Sequence elementsSequence;

  final void Function(CountryCode value)? getCountryData;
  final double? flagWidth;
  final double? flagHeight;
  final Color? barrierColor;
  final Icon? closedDialogIcon;
  final WidgetBuilder? emptySearchBuilder;
  final EdgeInsetsGeometry? countryItemPadding;
  final String? selectInitialCountry;
  final Decoration? flagDecoration;
  final bool hideCloseIcon;
  final Icon? searchIcon;
  final EdgeInsetsGeometry? searchMargin;
  // final bool showFlag;
  final bool showSearchBar;
  final Size? size;

  /// using this comparator to change the order of options.
  final Comparator<CountryCode>? comparator;

  final CountryPickerThemeData? countryPickerThemeData;

  /// used to customize the country list,
  final List<String>? countryFilter;

  /// add your favorites countries
  final List<String>? favorite;

  const CountryPickerDialog(
      {super.key,
      this.listOfCountries = codes,
      this.countryFilter,
      this.comparator,
      this.showCountryCode = true,
      this.showCountryFlag = true,
      this.showCountryName = true,
      this.showCountryMainFlag = true,
      this.showCountryMainCode = true,
      this.showCountryMainName = true,
      this.textOverflow = TextOverflow.ellipsis,
      this.selectInitialCountry,
      this.favorite,
      this.countryPickerThemeData,
      this.closedDialogIcon,
      this.countryItemPadding,
      this.emptySearchBuilder,
      this.flagDecoration,
      this.hideCloseIcon = false,
      this.searchIcon,
      this.searchMargin,
      this.showSearchBar = true,
      this.size,
      this.excludeCountry,
      this.barrierColor,
      this.getCountryData,
      this.flagWidth,
      this.flagHeight,
      this.elementsSequence = Sequence.flagCodeAndCountryName})
      : assert((showCountryMainFlag || showCountryMainCode || showCountryMainName), 'At-least one data we need to show in a widget.'),
        assert(((excludeCountry == null) || (countryFilter == null)),
            'We will provide either exclude country or country filter, So we are not providing both at a same time.'),
        assert((showCountryFlag || showCountryCode || showCountryName), 'At-least one data we need to show in a our country list.');
  @override
  // ignore: no_logic_in_create_state
  State<CountryPickerDialog> createState() {
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
    return _CountryPickerDialogState(countriesElements);
  }
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  List<CountryCode> countriesElements = [];
  CountryCode? selectedItem;
  List<CountryCode> favoritesCountries = [];

  _CountryPickerDialogState(this.countriesElements);

  @override
  void initState() {
    super.initState();
    if (widget.selectInitialCountry != null) {
      selectedItem = countriesElements.firstWhere(
        (element) =>
            element.name == widget.selectInitialCountry?.toUpperCase() ||
            element.dialCode == widget.selectInitialCountry?.toUpperCase() ||
            element.code == widget.selectInitialCountry?.toUpperCase(),
        orElse: () =>
            countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN"),
      );
    } else {
      if (widget.countryFilter != null) {
        selectedItem ??= countriesElements.first;
      } else {
        selectedItem =
            countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN");
      }
      debugPrint('select item::$selectedItem');
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
  void didUpdateWidget(covariant CountryPickerDialog oldWidget) {
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
                  width: widget.flagWidth ?? 28,
                  height: widget.flagHeight ?? 18,
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
            // shape: OutlineInputBorder(
            //     borderSide: BorderSide(color: Colors.purple, width: 2), borderRadius: BorderRadius.all(Radius.circular(10))),
            surfaceTintColor: Colors.blue,
            child: CountrySelectionDialog(
              countriesElements,
              favoritesCountries,
              showCountryCode: widget.showCountryCode,
              showCountryFlag: widget.showCountryFlag,
              showCountryName: widget.showCountryName,
              elementsSequence: widget.elementsSequence,
              flagHeight: widget.flagHeight,
              flagWidth: widget.flagWidth,
              countryPickerThemeData: widget.countryPickerThemeData,
              closedDialogIcon: widget.closedDialogIcon,
              countryItemPadding: widget.countryItemPadding,
              emptySearchBuilder: widget.emptySearchBuilder,
              flagDecoration: widget.flagDecoration,
              hideCloseIcon: widget.hideCloseIcon,
              searchIcon: widget.searchIcon,
              searchMargin: widget.searchMargin,
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
