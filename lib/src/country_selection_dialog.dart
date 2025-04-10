import 'package:mi_country_picker/mi_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mi_country_picker/src/codes.dart';

class CountrySelectionDialog extends StatefulWidget {

  /// [listOfCountries] is a list of countries that will be displayed in the dialog.
  final List<CountryData>? listOfCountries;

  /// [searchStyle] is a configuration for the search bar.
  final SearchStyle? searchStyle;

  /// [layoutConfig] is a configuration for the layout of the country list.
  final LayoutConfig? layoutConfig;

  /// [countryListConfig] is a configuration for the country list.
  final CountryListConfig? countryListConfig;

  /// [favouriteCountries] is a list of country codes that will be displayed at the top of the list.
  final List<String>? favouriteCountries;

  /// [closeIconWidget] is a widget that will be displayed as the close icon.
  final Widget? closeIconWidget;

  /// [size] is the size of the dialog.
  final Size? size;

  /// [borderRadius] is the border radius of the dialog.
  final BorderRadiusGeometry? borderRadius;

  /// [backGroundColor] is the background color of the dialog.
  final Color? backGroundColor;

  /// [countryTilePadding] is the padding for each country tile.
  final EdgeInsetsGeometry? countryTilePadding;

  /// [emptySearchBuilder] is a widget that will be displayed when the search result is empty.
  final WidgetBuilder? emptySearchBuilder;

  /// [showSearchBar] is a boolean that determines whether to show the search bar or not.
  final bool? showSearchBar;

  /// [header] is a widget that will be displayed as the header of the dialog.
  final Widget? header;

  /// [onCountrySelect] is a callback function which returns the selected country data.
  final Function(CountryData?)? onCountrySelect;

  const CountrySelectionDialog({
    super.key,
    this.onCountrySelect,
    this.showSearchBar,
    this.countryTilePadding,
    this.emptySearchBuilder,
    this.size,
    this.header,
    this.backGroundColor,
    this.borderRadius,
    this.listOfCountries,
    this.layoutConfig = const LayoutConfig(),
    this.countryListConfig,
    this.favouriteCountries,
    this.searchStyle,
    this.closeIconWidget,
  });

  @override
  State<CountrySelectionDialog> createState() => _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<CountrySelectionDialog> {
  List<CountryData> countriesElements = [];
  List<CountryData> favoriteCountries = [];
  List<CountryData> filteredElements = [];

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 14);

  @override
  void initState() {
    super.initState();

    countriesElements = widget.listOfCountries ?? countries;
    if (widget.countryListConfig?.comparator != null) {
      countriesElements.sort(widget.countryListConfig?.comparator);
    }

    if (widget.countryListConfig?.countryFilter != null && widget.countryListConfig!.countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = widget.countryListConfig?.countryFilter?.map((e) => e.toUpperCase()).toList();
      countriesElements = countriesElements.where((element) => uppercaseFilterElement!.contains(element.code)).toList();
      if (countriesElements.isEmpty) {
        throw ("Invalid country list");
      }
    }
    filteredElements = countriesElements;
    if (widget.countryListConfig?.excludeCountry != null && widget.countryListConfig!.excludeCountry!.isNotEmpty) {
      for (int i = 0; i < (widget.countryListConfig?.excludeCountry?.length ?? 0); i++) {
        for (int j = 0; j < countriesElements.length; j++) {
          if ((widget.countryListConfig?.excludeCountry?[i].toUpperCase() == countriesElements[j].code)) {
            countriesElements.removeAt(j);
            break;
          }
        }
      }
    }

    if (widget.favouriteCountries != null) {
      // Remove '+' from all favouriteCountries
      final cleanedFavouriteCountries = widget.favouriteCountries!
          .map((code) => code.startsWith('+') ? code.substring(1) : code)
          .toList();

      favoriteCountries = countriesElements
          .where((element) => cleanedFavouriteCountries.contains(element.dialCode))
          .toList();
    }
  }

  @override
  void didChangeDependencies() {
    countriesElements = countriesElements.map((e) => e.localize(context)).toList();
    super.didChangeDependencies();
  }

  double calculateTextWidth(double size) {
    int defaultSize = 50;
    return (size * defaultSize / _defaultTextStyle.fontSize!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size?.width ?? MediaQuery.of(context).size.width * 0.8,
      height: widget.size?.height ?? MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: widget.backGroundColor ?? Theme.of(context).dialogBackgroundColor,
        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: widget.header ??
                    const Text(
                      "Select Country",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
              ),
              const Spacer(),
              (widget.closeIconWidget == null)
                  ? IconButton(
                iconSize: 20,
                splashRadius: 20,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              )
                  : widget.closeIconWidget!,
            ],
          ),
          if (widget.showSearchBar ?? true)
            Container(
              margin: widget.searchStyle?.searchBoxMargin ??
                  const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
              height: widget.searchStyle?.searchBoxHeight ?? 40,
              child: TextField(
                style: widget.searchStyle?.searchTextStyle ??
                    const TextStyle(
                      fontSize: 14,
                      height: 16 / 14,
                    ),
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) => _filterElements(value),
                decoration: widget.searchStyle?.searchFieldInputDecoration ??
                    InputDecoration(
                      isCollapsed: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(9),
                        child: widget.searchStyle?.searchIcon ??
                            Image.asset(
                              color: Colors.grey.shade400,
                              'lib/assets/icons/search.png',
                              package: 'mi_country_picker',
                            ),
                      ),
                      hintText: widget.searchStyle?.hintText ?? "Search",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
              ),
            ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (favoriteCountries.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 8),
                    sliver: SliverList.builder(
                      itemCount: favoriteCountries.length + 1,
                      itemBuilder: (context, index) {
                        if (index == favoriteCountries.length) {
                          return const Divider();
                        } else {
                          return InkWell(
                            onTap: () {
                              _selectItem(favoriteCountries[index]);
                            },
                            child: Padding(
                              padding:
                              widget.countryTilePadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: buildList(context, favoriteCountries[index]),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                (filteredElements.isEmpty)
                    ? _buildEmptySearchWidget(context)
                    : SliverList.builder(
                  itemCount: filteredElements.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _selectItem(filteredElements[index]);
                      },
                      child: Padding(
                        padding:
                        widget.countryTilePadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: buildList(context, filteredElements[index]),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }
    return SliverFillRemaining(
      child: Center(
        child: Text(CountryPickerLocalizations.of(context)?.translate('no_country') ?? 'Not found'),
      ),
    );
  }

  Widget buildList(BuildContext context, CountryData e) {
    if (widget.layoutConfig?.elementsSequence == Sequence.flagCodeAndCountryName) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.layoutConfig?.showCountryFlag ?? true)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: widget.layoutConfig?.flagDecoration,
                clipBehavior: widget.layoutConfig?.flagDecoration == null ? Clip.none : Clip.hardEdge,
                child: Image.asset(
                  e.flagUri!,
                  package: 'mi_country_picker',
                  width: widget.layoutConfig?.flagWidth ?? 24,
                  height: widget.layoutConfig?.flagHeight ?? 18,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (widget.layoutConfig?.showCountryCode ?? true)
            SizedBox(
              width: calculateTextWidth(widget.layoutConfig?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
              child: Text(
                e.toString(),
                style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.fade,
              ),
            ),
          Expanded(
            child: Text(
              " ${widget.layoutConfig?.showCountryName ?? true ? e.toCountryStringOnly() : ""}",
              style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.layoutConfig?.showCountryCode ?? true)
            SizedBox(
              width: calculateTextWidth(widget.layoutConfig?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
              child: Text(
                e.toString(),
                style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.fade,
              ),
            ),
          Expanded(
            child: Text(
              " ${widget.layoutConfig?.showCountryName ?? true ? e.toCountryStringOnly() : ""}",
              style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              overflow: TextOverflow.fade,
            ),
          ),
          if (widget.layoutConfig?.showCountryFlag ?? true)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(left: 16.0),
                decoration: widget.layoutConfig?.flagDecoration,
                clipBehavior: widget.layoutConfig?.flagDecoration == null ? Clip.none : Clip.hardEdge,
                child: Image.asset(
                  e.flagUri!,
                  package: 'mi_country_picker',
                  width: widget.layoutConfig?.flagWidth ?? 28,
                  height: widget.layoutConfig?.flagHeight ?? 18,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      );
    }
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = countriesElements
          .where((e) => e.code!.contains(s) || e.dialCode!.contains(s) || e.name!.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryData e) {
    widget.onCountrySelect?.call(e);
    Navigator.pop(context);
  }
}