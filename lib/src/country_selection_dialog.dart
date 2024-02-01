import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_data_model.dart';
import 'package:flutter/material.dart';

class CountrySelectionDialog extends StatefulWidget {
  final TextStyle? textStyle;
  final InputDecoration? searchFieldInputDecoration;
  final BorderRadiusGeometry? borderRadius;
  final bool? showCountryFlag;
  final Color? backGroundColor;
  final bool? showCountryCode;
  final bool? showCountryName;
  final List<CountryData> elements;
  final Sequence? elementsSequence;
  final bool showDialogHeading;
  final double? flagWidth;
  final TextStyle? searchStyle;
  final double? flagHeight;
  final double? searchBoxHeight;
  final Size? size;
  final EdgeInsetsGeometry? searchBoxMargin;
  final EdgeInsetsGeometry? countryItemPadding;
  final List<CountryData> favoritesCountries;
  final WidgetBuilder? emptySearchBuilder;
  final Decoration? flagDecoration;
  final bool hideCloseIcon;
  final String? hintText;
  final bool? showSearchBar;
  final Icon? searchIcon;
  final Icon? closedDialogIcon;
  final EdgeInsets? countryListPadding;
  final Text? countryPickerDialogHeading;

  const CountrySelectionDialog(
    this.elements,
    this.favoritesCountries, {
    super.key,
    this.searchIcon,
    this.closedDialogIcon,
    this.showSearchBar,
    this.searchBoxMargin,
    this.hideCloseIcon = false,
    this.flagDecoration,
    this.countryItemPadding,
    this.emptySearchBuilder,
    this.size,
    this.flagWidth,
    this.flagHeight,
    this.elementsSequence,
    this.showCountryFlag,
    this.showCountryCode,
    this.showCountryName,
    this.countryListPadding,
    this.countryPickerDialogHeading,
    this.showDialogHeading = true,
    this.hintText,
    this.searchStyle,
    this.searchBoxHeight,
    this.backGroundColor,
    this.textStyle,
    this.borderRadius,
    this.searchFieldInputDecoration,
  });

  @override
  State<CountrySelectionDialog> createState() => _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<CountrySelectionDialog> {
  List<CountryData> filterElements = [];
  double? setWidthOfDialog;

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 14);

  @override
  void initState() {
    filterElements = widget.elements ?? [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
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
        color: widget.backGroundColor ?? Theme.of(context).dialogBackgroundColor,
        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(18.0)),
      ),
      child: Column(
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

  void _selectItem(CountryData e) {
    Navigator.pop(context, e);
  }
}
