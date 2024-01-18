import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:flutter/material.dart';

class CountrySelectionDialog extends StatefulWidget {
  final bool? showCountryFlag;
  final bool? showCountryCode;
  final bool? showCountryName;
  final List<CountryCode> elements;
  final Sequence elementsSequence;
  final double? flagWidth;
  final double? flagHeight;
  final Size? size;
  final EdgeInsetsGeometry? searchMargin;
  final EdgeInsetsGeometry? countryItemPadding;
  final List<CountryCode> favoritesCountries;
  final WidgetBuilder? emptySearchBuilder;
  final Decoration? flagDecoration;
  final bool hideCloseIcon;
  final bool? showSearchBar;
  final Icon? searchIcon;
  final Icon? closedDialogIcon;
  final EdgeInsets? countryListPadding;
  final CountryPickerThemeData? countryPickerThemeData;

  const CountrySelectionDialog(
    this.elements,
    this.favoritesCountries, {
    super.key,
    this.searchIcon,
    this.closedDialogIcon,
    this.countryPickerThemeData,
    this.showSearchBar,
    this.searchMargin,
    this.hideCloseIcon = false,
    this.flagDecoration,
    this.countryItemPadding,
    this.emptySearchBuilder,
    this.size,
    this.flagWidth,
    this.flagHeight,
    required this.elementsSequence,
    this.showCountryFlag,
    this.showCountryCode,
    this.showCountryName,
    this.countryListPadding,
  });

  @override
  State<CountrySelectionDialog> createState() => _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<CountrySelectionDialog> {
  List<CountryCode> filterElements = [];
  Color? _backGroundColor;
  double? setWidthOfDialog;

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 14);

  @override
  void initState() {
    filterElements = widget.elements ?? [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _backGroundColor = widget.countryPickerThemeData?.backgroundColor ?? Theme.of(context).dialogBackgroundColor;
    if (_backGroundColor == null) {
      if (Theme.of(context).brightness == Brightness.light) {
        _backGroundColor = Colors.white;
      } else {
        _backGroundColor = Colors.black;
      }
    }

    /// by default set the dimension of dialog according to platform.
    if (MediaQuery.of(context).size.width > 400 && MediaQuery.of(context).size.width < 800) {
      setWidthOfDialog = MediaQuery.of(context).size.width * 0.5;
    } else if (MediaQuery.of(context).size.width > 800) {
      setWidthOfDialog = MediaQuery.of(context).size.width * 0.35;
    } else {
      setWidthOfDialog = MediaQuery.of(context).size.width * 0.8;
    }
    super.didChangeDependencies();
  }

  double calculateSize(double size) {
    int defaultSize = 50;
    debugPrint('$size====>${(size * defaultSize / _defaultTextStyle.fontSize!)}');
    return (size * defaultSize / _defaultTextStyle.fontSize!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size?.width ?? setWidthOfDialog,
      height: widget.size?.height ?? MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: _backGroundColor,
        borderRadius: widget.countryPickerThemeData?.borderRadius ?? const BorderRadius.all(Radius.circular(18.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Select Country",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
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
              margin: widget.searchMargin ?? const EdgeInsets.only(right: 16, left: 16, top: 2),
              height: 40,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 19,
                onChanged: (value) {
                  _filterElements(value);
                },
                decoration: widget.countryPickerThemeData?.searchFieldInputDecoration ??
                    InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(bottom: 5),
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
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
              ),
            ),
          Expanded(
            child: ListView(
              padding: widget.countryListPadding ??
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
                          const Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Divider(),
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
      ),
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

  Widget buildList(BuildContext context, CountryCode e) {
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
          SizedBox(
            width: calculateSize(widget.countryPickerThemeData?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
            child: Text(
              textAlign: TextAlign.start,
              widget.showCountryCode! ? e.toString() : "",
              overflow: TextOverflow.fade,
              style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              " ${widget.showCountryName! ? e.toCountryStringOnly() : ""}",
              overflow: TextOverflow.fade,
              style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: calculateSize(widget.countryPickerThemeData?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
            child: Text(
              textAlign: TextAlign.start,
              widget.showCountryCode! ? e.toString() : "",
              overflow: TextOverflow.fade,
              style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.left,
              " ${widget.showCountryName! ? e.toCountryStringOnly() : ""}",
              overflow: TextOverflow.fade,
              style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
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
                  width: widget.flagWidth ?? 28,
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

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
