import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:flutter/material.dart';

class CountrySelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final Size? size;
  final bool? showCircularFlag;
  final EdgeInsetsGeometry? searchPadding;
  final EdgeInsetsGeometry? dialogItemPadding;
  final List<CountryCode> favoritesCountries;
  final WidgetBuilder? emptySearchBuilder;
  final Decoration? flagDecoration;
  final bool? showFlag;
  final bool hideCloseIcon;
  final bool? showSearchBar;
  final bool? showCountryOnly;
  final Icon? searchIcon;
  final Icon? closedDialogIcon;
  final BorderRadius? dialogBorderRadius; //
  final CountryPickerThemeData? countryPickerThemeData;

  const CountrySelectionDialog(
    this.elements,
    this.favoritesCountries, {
    super.key,
    this.searchIcon,
    this.closedDialogIcon,
    this.countryPickerThemeData,
    this.showSearchBar,
    this.searchPadding,
    this.hideCloseIcon = false,
    this.dialogBorderRadius,
    this.showFlag,
    this.flagDecoration,
    this.showCountryOnly,
    this.dialogItemPadding,
    this.emptySearchBuilder,
    this.size,
    this.showCircularFlag,
  });

  @override
  State<CountrySelectionDialog> createState() => _CountrySelectionDialogState();
}

class _CountrySelectionDialogState extends State<CountrySelectionDialog> {
  List<CountryCode> filterElements = [];
  Color? _backGroundColor;
  double? setWidthOfDialog;

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 16);

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
      setWidthOfDialog = MediaQuery.of(context).size.width * 0.25;
    } else {
      setWidthOfDialog = MediaQuery.of(context).size.width * 0.8;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        width: widget.size?.width ?? setWidthOfDialog,
        height: widget.size?.height ?? MediaQuery.of(context).size.height * 0.72,
        decoration: BoxDecoration(
          color: _backGroundColor,
          borderRadius: widget.countryPickerThemeData?.borderRadius ?? const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.hideCloseIcon)
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: widget.closedDialogIcon ?? const Icon(Icons.close)),
            if (widget.showSearchBar!)
              Padding(
                padding: widget.searchPadding ?? const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  onChanged: (value) {
                    _filterElements(value);
                  },
                  decoration: widget.countryPickerThemeData?.searchFieldInputDecoration ??
                      InputDecoration(
                        prefixIcon: widget.searchIcon ?? const Icon(Icons.search),
                        hintText: "search",
                      ),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  (widget.favoritesCountries.isNotEmpty)
                      ? Column(
                          children: [
                            ...widget.favoritesCountries.map((e) => InkWell(
                                  onTap: () {
                                    _selectItem(e);
                                  },
                                  child: Padding(
                                    padding: widget.dialogItemPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                    child: buildList(context, e),
                                  ),
                                )),
                            const Divider()
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
                          padding: widget.dialogItemPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: buildList(context, e),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }

    return Center(
      child: Text(CountryPickerLocalizations.of(context)?.translate('no_country') ?? 'No country found'),
    );
  }

  Widget buildList(BuildContext context, CountryCode e) {
    return Row(
      children: [
        if (widget.showFlag!)
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: widget.flagDecoration,
              clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
              child: (widget.showCircularFlag!)
                  ? ClipOval(
                      child: SizedBox.fromSize(
                        child: Image.asset(
                          e.flagUri!,
                          package: 'country_picker',
                          width: widget.countryPickerThemeData?.flagSize ?? 25,
                          fit: BoxFit.fill,
                          height: widget.countryPickerThemeData?.flagSize ?? 25,
                        ),
                      ),
                    )
                  : Image.asset(
                      e.flagUri!,
                      package: 'country_picker',
                      width: widget.countryPickerThemeData?.flagSize ?? 25,
                    ),
            ),
          ),
        Expanded(
          flex: 4,
          child: Text(
            widget.showCountryOnly! ? e.toCountryStringOnly() : e.toLongString(),
            overflow: TextOverflow.fade,
            style: widget.countryPickerThemeData?.textStyle ?? _defaultTextStyle,
          ),
        ),
      ],
    );
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
