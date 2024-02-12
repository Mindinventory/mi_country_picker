import 'package:mi_country_picker/mi_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mi_country_picker/src/codes.dart';
import 'package:mi_country_picker/src/country_selection_dialog.dart';

class CountryPickerDialog extends StatefulWidget {
  /// it is optional argument to set your own custom country list
  final List<Map<String, String>> listOfCountries;

  /// add your favorites countries
  final List<String>? favorite;

  final SearchStyle? searchStyle;

  /// this properties is use for hide-show country flag in our screen.
  final bool showCountryMainFlag;

  final bool? isDismissible;

  final TextStyle? mainTextStyle;

  /// this properties is use for hide-show country name in our screen.
  final bool showCountryMainName;

  /// this properties is use for hide-show country code in our screen.
  final bool showCountryMainCode;

  /// text overflow in use to manage text overflow for country name.
  final TextOverflow textOverflow;

  final LayoutConfig? layoutConfig;

  final CountryListConfig? countryListConfig;

  ///here this [onSelectValue] get the selected country value.
  final ValueChanged<CountryData> onSelectValue;

  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  final InputDecoration? searchFieldInputDecoration;
  final bool? useSafeArea;
  final AlignmentGeometry? dialogAlignment;
  final Clip? clipBehavior;
  final EdgeInsets? insetPadding;
  final Color? shadowColor;
  final Text? countryPickerDialogHeading;
  final TextStyle? searchTextStyle;
  final String? hintText;
  final EdgeInsets? countryListPadding;
  final bool? showDialogHeading;
  final double? searchBoxHeight;
  final Color? barrierColor;
  final Icon? closedDialogIcon;
  final WidgetBuilder? emptySearchBuilder;
  final EdgeInsetsGeometry? countryItemPadding;
  final Widget Function(CountryData? value)? builder;
  final bool hideCloseIcon;
  final Icon? searchIcon;
  final EdgeInsetsGeometry? searchBoxMargin;
  final bool showSearchBar;
  final Size? size;

  const CountryPickerDialog({
    super.key,
    this.listOfCountries = codes,
    this.showCountryMainFlag = true,
    this.showCountryMainCode = true,
    this.showCountryMainName = true,
    this.textOverflow = TextOverflow.ellipsis,
    this.closedDialogIcon,
    this.countryItemPadding,
    this.emptySearchBuilder,
    this.hideCloseIcon = false,
    this.searchIcon,
    this.searchBoxMargin,
    this.showSearchBar = true,
    this.size,
    this.barrierColor,
    required this.onSelectValue,
    this.countryListPadding,
    this.countryPickerDialogHeading,
    this.showDialogHeading,
    this.hintText,
    this.builder,
    this.searchTextStyle,
    this.searchBoxHeight,
    this.dialogAlignment,
    this.clipBehavior,
    this.insetPadding,
    this.shadowColor,
    this.useSafeArea,
    this.backGroundColor,
    this.layoutConfig = const LayoutConfig(),
    this.countryListConfig,
    this.mainTextStyle,
    this.searchFieldInputDecoration,
    this.borderRadius,
    this.favorite,
    this.isDismissible,
    this.searchStyle,
  }) : assert((showCountryMainFlag || showCountryMainCode || showCountryMainName), 'At-least one data we need to show in a widget.');

  /// Move to initState
  @override
  // ignore: no_logic_in_create_state
  State<CountryPickerDialog> createState() {
    List<CountryData> countriesElements = listOfCountries.map((element) => CountryData.fromJson(element)).toList();

    if (countryListConfig?.comparator != null) {
      countriesElements.sort(countryListConfig?.comparator);
    }

    if (countryListConfig?.countryFilter != null && countryListConfig!.countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = countryListConfig?.countryFilter?.map((e) => e.toUpperCase()).toList();
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
  List<CountryData> countriesElements = [];
  CountryData? selectedItem;
  List<CountryData> favoritesCountries = [];

  _CountryPickerDialogState(this.countriesElements);

  @override
  void initState() {
    super.initState();
    // if (widget.countryListConfig?.selectInitialCountry != null) {
    //   selectedItem = countriesElements.firstWhere(
    //     (element) =>
    //         element.name == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //         element.dialCode == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //         element.code == widget.countryListConfig?.selectInitialCountry?.toUpperCase(),
    //     orElse: () =>
    //         countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN"),
    //   );
    // } else {
    //   if (widget.countryListConfig?.countryFilter != null) {
    //     selectedItem ??= countriesElements.first;
    //   } else {
    //     selectedItem =
    //         countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN");
    //   }
    // }
    if (widget.countryListConfig?.excludeCountry != null && widget.countryListConfig!.excludeCountry!.isNotEmpty) {
      for (int i = 0; i < (widget.countryListConfig?.excludeCountry?.length ?? 0); i++) {
        for (int j = 0; j < countriesElements.length; j++) {
          if ((widget.countryListConfig?.excludeCountry?[i].toLowerCase() == countriesElements[j].name?.toLowerCase()) ||
              (widget.countryListConfig?.excludeCountry?[i] == countriesElements[j].dialCode) ||
              (widget.countryListConfig?.excludeCountry?[i].toUpperCase() == countriesElements[j].code)) {
            countriesElements.removeAt(j);
            break;
          }
        }
      }
    }
    if (widget.favorite != null) {
      favoritesCountries = countriesElements.where((element) => widget.favorite?.contains(element.dialCode) ?? false).toList();
    }
    widget.onSelectValue(selectedItem!);
  }

  @override
  void didUpdateWidget(covariant CountryPickerDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.countryListConfig?.selectInitialCountry != widget.countryListConfig?.selectInitialCountry) {
    //   if (widget.countryListConfig?.selectInitialCountry != null) {
    //     selectedItem = countriesElements.firstWhere(
    //       (element) =>
    //           element.name == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //           element.dialCode == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //           element.code == widget.countryListConfig?.selectInitialCountry?.toUpperCase(),
    //       orElse: () => countriesElements[0],
    //     );
    //   }
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    countriesElements = countriesElements.map((e) => e.localize(context)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showCountryPickerDialog,
      child: widget.builder?.call(selectedItem) ??
          Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.showCountryMainFlag)
                Container(
                  clipBehavior: widget.layoutConfig?.flagDecoration == null ? Clip.none : Clip.hardEdge,
                  decoration: widget.layoutConfig?.flagDecoration,
                  margin: const EdgeInsets.only(right: 12),
                  child: Image.asset(
                    selectedItem!.flagUri!,
                    package: 'mi_country_picker',
                    width: widget.layoutConfig?.flagWidth ?? 24,
                    height: widget.layoutConfig?.flagHeight ?? 18,
                    fit: BoxFit.cover,
                  ),
                ),
              Text(
                '${widget.showCountryMainCode ? selectedItem!.dialCode ?? '' : ''} ${widget.showCountryMainName ? selectedItem!.name! : ''}',
                style: widget.mainTextStyle ?? const TextStyle(fontSize: 16),
                overflow: widget.textOverflow,
              ),
            ],
          ),
    );
  }

  void showCountryPickerDialog() async {
    final selectedValue = await showDialog(
      useSafeArea: widget.useSafeArea ?? true,
      barrierDismissible: widget.isDismissible ?? true,
      barrierColor: widget.barrierColor,
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            backgroundColor: Colors.transparent,
            shadowColor: widget.shadowColor,
            insetPadding: widget.insetPadding,
            clipBehavior: widget.clipBehavior ?? Clip.none,
            alignment: widget.dialogAlignment,
            child: CountrySelectionDialog(
              searchStyle: widget.searchStyle,
              countryListConfig: widget.countryListConfig,
              layoutConfig: widget.layoutConfig,
              borderRadius: widget.borderRadius,
              backGroundColor: widget.backGroundColor ?? Theme.of(context).dialogBackgroundColor,
              countryTilePadding: widget.countryItemPadding,
              emptySearchBuilder: widget.emptySearchBuilder,
              showSearchBar: widget.showSearchBar,
              size: widget.size,
              header: widget.countryPickerDialogHeading,
            ),
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        selectedItem = selectedValue;
        widget.onSelectValue(selectedItem!);
      });
    }
  }
}
