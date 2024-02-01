import 'package:country_picker/src/country_data_model.dart';
import 'package:flutter/material.dart';

import 'country_picker.dart';

class CountryPickerDropDown extends StatefulWidget {
  /// it is optional argument to set your own custom country list
  final List<Map<String, String>> listOfCountries;
  final Color? backGroundColor;
  final LayoutConfig? layoutConfig;
  final CountryListConfig? countryListConfig;
  final double iconSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? menuMaxHeight;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;

  /// Selected country widget builder to display. See [selectedItemBuilder] of [DropdownButton]
  final Widget Function(CountryData)? selectedItemBuilder;

  ///here this [onSelectValue] get the selected country value.
  final ValueChanged<CountryData> onSelectValue;

  /// See [itemHeight] of [DropdownButton], by default its accept from [kMinInteractiveDimension]
  final double? itemHeight;

  /// Defaults to an [Icon] with the [Icons.arrow_drop_down].
  final Widget? icon;

  /// Defaults to a 0.0 width bottom border with color 0xFFBDBDBD.
  final Widget? underline;

  /// See [onTap] of [DropdownButton]
  final VoidCallback? onTap;

  /// See [onTap] of [DropdownMenuItemButton]
  final VoidCallback? onTapDropdownMenuButton;

  final Function(CountryData?)? getCountryData;

  // final CountryPickerThemeData? countryPickerThemeData;

  const CountryPickerDropDown({
    super.key,
    this.listOfCountries = codes,
    // this.countryPickerThemeData,
    this.getCountryData,
    this.iconSize = 24,
    this.onTap,
    this.borderRadius,
    this.padding,
    this.menuMaxHeight,
    this.underline,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.icon,
    this.itemHeight = kMinInteractiveDimension,
    this.onTapDropdownMenuButton,
    this.backGroundColor,
    required this.onSelectValue,
    this.selectedItemBuilder,
    this.layoutConfig = const LayoutConfig(),
    this.countryListConfig,
  });

  @override
  // ignore: no_logic_in_create_state
  State<CountryPickerDropDown> createState() {
    List<CountryData> countriesElements = listOfCountries.map((json) => CountryData.fromJson(json)).toList();

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

    return _CountryPickerDropDownState(countriesElements);
  }
}

class _CountryPickerDropDownState extends State<CountryPickerDropDown> {
  List<CountryData> countriesElements = [];
  List<CountryData> favoritesCountries = [];
  List<DropdownMenuItem<CountryData>> items = [];
  CountryData? selectedItem;

  TextStyle get _defaultTextStyle => const TextStyle(
        fontSize: 14,
      );

  _CountryPickerDropDownState(this.countriesElements);

  double calculateSize(double size) {
    int defaultSize = 80;
    debugPrint('$size====>${(size * defaultSize / _defaultTextStyle.fontSize!)}');
    return (size * defaultSize / _defaultTextStyle.fontSize!);
  }

  @override
  void initState() {
    super.initState();
    if (widget.countryListConfig?.selectInitialCountry != null) {
      selectedItem = countriesElements.firstWhere(
        (element) =>
            element.name == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
            element.dialCode == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
            element.code == widget.countryListConfig?.selectInitialCountry?.toUpperCase(),
        orElse: () =>
            countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN"),
      );
    } else {
      if (widget.countryListConfig?.countryFilter != null) {
        selectedItem ??= countriesElements.first;
      } else {
        selectedItem =
            countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN");
      }
    }
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
    if (widget.countryListConfig?.favorite != null) {
      favoritesCountries =
          countriesElements.where((element) => widget.countryListConfig?.favorite?.contains(element.dialCode) ?? false).toList();
    }
    widget.onSelectValue(selectedItem!);
  }

  @override
  void didUpdateWidget(covariant CountryPickerDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryListConfig?.selectInitialCountry != widget.countryListConfig?.selectInitialCountry) {
      if (widget.countryListConfig?.selectInitialCountry != null) {
        selectedItem = countriesElements.firstWhere(
          (element) =>
              element.name == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
              element.dialCode == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
              element.code == widget.countryListConfig?.selectInitialCountry?.toUpperCase(),
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
    items = countriesElements.map<DropdownMenuItem<CountryData>>((e) {
      return DropdownMenuItem<CountryData>(
          alignment: Alignment.center,
          onTap: widget.onTapDropdownMenuButton,
          value: e,
          child: (widget.layoutConfig?.elementsSequence == Sequence.flagCodeAndCountryName)
              ? Row(
                  children: [
                    if (widget.layoutConfig!.showCountryFlag)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          decoration: widget.layoutConfig?.flagDecoration,
                          clipBehavior: widget.layoutConfig?.flagDecoration == null ? Clip.none : Clip.hardEdge,
                          child: Image.asset(
                            e.flagUri!,
                            package: 'country_picker',
                            width: widget.layoutConfig?.flagWidth ?? 24,
                            height: widget.layoutConfig?.flagHeight ?? 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (widget.layoutConfig!.showCountryCode)
                      Flexible(
                        child: SizedBox(
                          width: calculateSize(widget.layoutConfig?.textStyle?.fontSize ??
                              Theme.of(context).dropdownMenuTheme.textStyle?.fontSize ??
                              _defaultTextStyle.fontSize!),
                          child: Text(
                            "${e.toString()}(${e.code})",
                            style: widget.layoutConfig?.textStyle ?? Theme.of(context).dropdownMenuTheme.textStyle ?? _defaultTextStyle,
                          ),
                        ),
                      ),
                    if (widget.layoutConfig!.showCountryName)
                      Expanded(
                        child: Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
                          e.toCountryStringOnly(),
                          style: widget.layoutConfig?.textStyle ?? Theme.of(context).dropdownMenuTheme.textStyle ?? _defaultTextStyle,
                        ),
                      ),
                  ],
                )
              : Row(
                  mainAxisAlignment:
                      (widget.layoutConfig?.showCountryName == false) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                  children: [
                    if (widget.layoutConfig!.showCountryCode)
                      Flexible(
                        child: SizedBox(
                          width: calculateSize(widget.layoutConfig?.textStyle?.fontSize ??
                              Theme.of(context).dropdownMenuTheme.textStyle?.fontSize ??
                              _defaultTextStyle.fontSize!),
                          child: Text("${e.toString()}(${e.code})",
                              style: widget.layoutConfig?.textStyle ?? Theme.of(context).dropdownMenuTheme.textStyle ?? _defaultTextStyle),
                        ),
                      ),
                    if (widget.layoutConfig!.showCountryName)
                      Expanded(
                        child: Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
                          e.toCountryStringOnly(),
                          overflow: TextOverflow.fade,
                          style: widget.layoutConfig?.textStyle ?? Theme.of(context).dropdownMenuTheme.textStyle ?? _defaultTextStyle,
                        ),
                      ),
                    if (widget.layoutConfig!.showCountryFlag)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(left: 14.0),
                          decoration: widget.layoutConfig?.flagDecoration,
                          clipBehavior: widget.layoutConfig?.flagDecoration == null ? Clip.none : Clip.hardEdge,
                          child: Image.asset(
                            e.flagUri!,
                            package: 'country_picker',
                            width: widget.layoutConfig?.flagWidth ?? 28,
                            height: widget.layoutConfig?.flagHeight ?? 18,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ));
    }).toList();
    return DropdownButton(
      selectedItemBuilder: widget.selectedItemBuilder != null
          ? (context) {
              return countriesElements.map((c) => widget.selectedItemBuilder!(c)).toList();
            }
          : null,
      dropdownColor: widget.backGroundColor,
      alignment: Alignment.bottomRight,
      iconSize: widget.iconSize,
      onTap: widget.onTap,
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      menuMaxHeight: widget.menuMaxHeight,
      underline: widget.underline,
      style: widget.layoutConfig?.textStyle,
      iconDisabledColor: widget.iconDisabledColor,
      iconEnabledColor: widget.iconEnabledColor,
      icon: widget.icon,
      itemHeight: widget.itemHeight,
      isExpanded: true,
      value: selectedItem,
      items: items,
      onChanged: (value) {
        setState(
          () {
            selectedItem = value;
            widget.onSelectValue(selectedItem!);
          },
        );
      },
    );
  }
}
