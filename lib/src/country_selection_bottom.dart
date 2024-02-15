import 'package:flutter/material.dart';
import 'package:mi_country_picker/src/codes.dart';
import '../mi_country_picker.dart';

class CountrySelectionBottomSheet extends StatefulWidget {
  /// add your favorites countries
  final List<String>? favouriteCountries;

  final LayoutConfig? layoutConfig;
  final CountryListConfig? countryListConfig;
  final SearchStyle? searchStyle;
  final Text? header;
  final bool? showSearchBar;
  final EdgeInsetsGeometry? countryTilePadding;
  final WidgetBuilder? emptySearchBuilder;
  final Widget? closeIconWidget;

  const CountrySelectionBottomSheet({
    super.key,
    this.header,
    this.showSearchBar,
    this.countryTilePadding,
    this.emptySearchBuilder,
    this.layoutConfig,
    this.countryListConfig,
    this.searchStyle,
    this.favouriteCountries,
    this.closeIconWidget,
  });

  @override
  // ignore: no_logic_in_create_state
  State<CountrySelectionBottomSheet> createState() => _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState extends State<CountrySelectionBottomSheet> {
  List<CountryData> countriesElements = [];
  CountryData? selectedItem;
  List<CountryData> favoriteCountries = [];
  List<CountryData> filteredElements = [];
  double? setWidthOfDialog;

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 14);

  @override
  void initState() {
    countriesElements = codes.map((element) => CountryData.fromJson(element)).toList();
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
      favoriteCountries = countriesElements.where((element) => widget.favouriteCountries?.contains(element.code) ?? false).toList();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    countriesElements = countriesElements.map((e) => e.localize(context)).toList();
    super.didChangeDependencies();
  }

  double calculateSize(double size) {
    int defaultSize = 50;
    return (size * defaultSize / _defaultTextStyle.fontSize!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              style: widget.searchStyle?.searchTextStyle ?? const TextStyle(fontSize: 14, height: 16 / 14),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                _filterElements(value);
              },
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
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
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
                            padding: widget.countryTilePadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: buildList(context, favoriteCountries[index]),
                          ),
                        );
                      }
                    },
                  ),
                ),
              if (filteredElements.isEmpty)
                _buildEmptySearchWidget(context)
              else
                SliverList.builder(
                  itemCount: filteredElements.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _selectItem(filteredElements[index]);
                      },
                      child: Padding(
                        padding: widget.countryTilePadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: buildList(context, filteredElements[index]),
                      ),
                    );
                  },
                ),
            ],
          ),
        )
      ],
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
              width: calculateSize(widget.layoutConfig?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
              child: Text(
                textAlign: TextAlign.start,
                e.toString(),
                overflow: TextOverflow.fade,
                style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
              ),
            ),
          Expanded(
            child: Text(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              " ${widget.layoutConfig?.showCountryName ?? true ? e.toCountryStringOnly() : ""}",
              overflow: TextOverflow.fade,
              style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
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
              width: calculateSize(widget.layoutConfig?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
              child: Text(
                textAlign: TextAlign.start,
                e.toString(),
                overflow: TextOverflow.fade,
                style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
              ),
            ),
          Expanded(
            child: Text(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              " ${widget.layoutConfig?.showCountryName ?? true ? e.toCountryStringOnly() : ""}",
              overflow: TextOverflow.fade,
              style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
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
                  width: widget.layoutConfig?.flagWidth ?? 24,
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
      filteredElements =
          countriesElements.where((e) => e.code!.contains(s) || e.dialCode!.contains(s) || e.name!.toUpperCase().contains(s)).toList();
    });
  }

  void _selectItem(CountryData e) {
    Navigator.pop(context, e);
  }
}
