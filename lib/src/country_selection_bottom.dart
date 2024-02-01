import 'package:flutter/material.dart';

import '../country_picker.dart';
import 'country_data_model.dart';

class CountrySelectionBottom extends StatefulWidget {
  final TextStyle? textStyle;
  final ValueChanged<CountryData> getSelectedItem;
  final List<CountryData> elements;
  final bool showDialogHeading;
  final Text? countryPickerDialogHeading;
  final bool hideCloseIcon;
  final Icon? closedDialogIcon;
  final bool? showSearchBar;
  final EdgeInsetsGeometry? searchBoxMargin;
  final double? searchBoxHeight;
  final TextStyle? searchStyle;
  final InputDecoration? searchFieldInputDecoration;
  // final CountryPickerThemeData? countryPickerThemeData;
  final Icon? searchIcon;
  final String? hintText;
  final EdgeInsets? countryListViewPadding;
  final List<CountryData> favoritesCountries;
  final EdgeInsetsGeometry? countryItemPadding;
  final WidgetBuilder? emptySearchBuilder;
  final Sequence? elementsSequence;
  final bool? showCountryFlag;
  final Decoration? flagDecoration;
  final double? flagWidth;
  final double? flagHeight;
  final bool? showCountryCode;
  final bool? showCountryName;

  const CountrySelectionBottom(
    this.elements,
    this.favoritesCountries, {
    super.key,
    this.showDialogHeading = true,
    this.countryPickerDialogHeading,
    this.hideCloseIcon = false,
    this.closedDialogIcon,
    this.showSearchBar,
    this.searchBoxMargin,
    this.searchBoxHeight,
    this.searchStyle,
    // this.countryPickerThemeData,
    this.searchIcon,
    this.hintText,
    this.countryListViewPadding,
    this.countryItemPadding,
    this.emptySearchBuilder,
    this.elementsSequence,
    this.showCountryFlag,
    this.flagDecoration,
    this.flagWidth,
    this.flagHeight,
    this.showCountryCode,
    this.showCountryName,
    required this.getSelectedItem,
    this.textStyle,
    this.searchFieldInputDecoration,
  });

  @override
  State<CountrySelectionBottom> createState() => _CountrySelectionBottomState();
}

class _CountrySelectionBottomState extends State<CountrySelectionBottom> {
  List<CountryData> filterElements = [];

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 14);

  @override
  void initState() {
    filterElements = widget.elements ?? [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  double calculateSize(double size) {
    int defaultSize = 50;
    debugPrint('$size====>${(size * defaultSize / _defaultTextStyle.fontSize!)}');
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
            if (widget.showDialogHeading == true)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: widget.countryPickerDialogHeading ??
                    const Text(
                      "Select Country",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
              ),
            const Spacer(),
            if (!widget.hideCloseIcon)
              IconButton(
                  iconSize: 20,
                  splashRadius: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: widget.closedDialogIcon ?? const Icon(Icons.close)),
          ],
        ),
        if (widget.showSearchBar!)
          Container(
            margin: widget.searchBoxMargin ??
                const EdgeInsets.only(
                  right: 16,
                  left: 16,
                ),
            height: widget.searchBoxHeight ?? 40,
            child: TextField(
              style: widget.searchStyle ?? const TextStyle(fontSize: 14, height: 16 / 14),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                _filterElements(value);
              },
              decoration: widget.searchFieldInputDecoration ??
                  InputDecoration(
                      isCollapsed: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.grey.shade400)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(9),
                        child: widget.searchIcon ??
                            Image.asset(
                              color: Colors.grey.shade400,
                              'assets/icons/search.png',
                              package: 'country_picker',
                            ),
                      ),
                      hintText: widget.hintText ?? "Search",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
            ),
          ),
        Expanded(
          child: ListView(
            padding: widget.countryListViewPadding ??
                const EdgeInsets.only(
                  top: 8,
                ),
            children: [
              (widget.favoritesCountries.isNotEmpty)
                  ? Column(
                      children: [
                        ...widget.favoritesCountries.map(
                          (e) => InkWell(
                            onTap: () {
                              _selectItem(e);
                            },
                            child: Padding(
                              padding: widget.countryItemPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: buildList(context, e),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        )
                      ],
                    )
                  : const DecoratedBox(decoration: BoxDecoration()),
              if (filterElements.isEmpty)
                _buildEmptySearchWidget(context)
              else
                ...filterElements.map(
                  (e) => InkWell(
                    onTap: () {
                      _selectItem(e);
                    },
                    child: Padding(
                      padding: widget.countryItemPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: buildList(context, e),
                    ),
                  ),
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

    return Center(
      child: Text(CountryPickerLocalizations.of(context)?.translate('no_country') ?? 'Not found'),
    );
  }

  Widget buildList(BuildContext context, CountryData e) {
    if (widget.elementsSequence == Sequence.flagCodeAndCountryName) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.showCountryFlag ?? true)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: widget.flagDecoration,
                clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                child: Image.asset(
                  e.flagUri!,
                  package: 'country_picker',
                  width: widget.flagWidth ?? 24,
                  height: widget.flagHeight ?? 18,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (widget.showCountryCode!)
            SizedBox(
              width: calculateSize(widget.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
              child: Text(
                textAlign: TextAlign.start,
                e.toString(),
                overflow: TextOverflow.fade,
                style: widget.textStyle ?? _defaultTextStyle,
              ),
            ),
          Expanded(
            child: Text(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              " ${widget.showCountryName! ? e.toCountryStringOnly() : ""}",
              overflow: TextOverflow.fade,
              style: widget.textStyle ?? _defaultTextStyle,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showCountryCode!)
            SizedBox(
              width: calculateSize(widget.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
              child: Text(
                textAlign: TextAlign.start,
                e.toString(),
                overflow: TextOverflow.fade,
                style: widget.textStyle ?? _defaultTextStyle,
              ),
            ),
          Expanded(
            child: Text(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              " ${widget.showCountryName! ? e.toCountryStringOnly() : ""}",
              overflow: TextOverflow.fade,
              style: widget.textStyle ?? _defaultTextStyle,
            ),
          ),
          if (widget.showCountryFlag ?? true)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(left: 16.0),
                decoration: widget.flagDecoration,
                clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                child: Image.asset(
                  e.flagUri!,
                  package: 'country_picker',
                  width: widget.flagWidth ?? 24,
                  height: widget.flagHeight ?? 18,
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
      filterElements =
          widget.elements.where((e) => e.code!.contains(s) || e.dialCode!.contains(s) || e.name!.toUpperCase().contains(s)).toList();
    });
  }

  void _selectItem(CountryData e) {
    widget.getSelectedItem(e);
    Navigator.pop(
      context,
    );
  }
}
