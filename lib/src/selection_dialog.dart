import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_picker_theme.dart';
import 'package:flutter/material.dart';

import 'country_code.dart';
import 'country_picker_localizations.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final bool hideCloseIcon;
  final Icon? closeIcon;
  final CountryPickerThemeData? countryPickerThemeData;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  final EdgeInsetsGeometry dialogItemPadding;

  final EdgeInsetsGeometry searchPadding;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.countryPickerThemeData,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.textStyle,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.barrierColor,
    this.hideSearch = false,
    this.hideCloseIcon = false,
    this.closeIcon,
    this.dialogItemPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.searchPadding = const EdgeInsets.symmetric(horizontal: 24),
  })  : searchDecoration =
            searchDecoration.prefixIcon == null ? searchDecoration.copyWith(prefixIcon: const Icon(Icons.search)) : searchDecoration,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  late List<CountryCode> filteredElements;
  Color? _backGroundColor;
  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 16);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _backGroundColor = widget.countryPickerThemeData?.backgroundColor ?? Theme.of(context).dialogBackgroundColor;
    if (_backGroundColor == null) {
      if (Theme.of(context).brightness == Brightness.light) {
        _backGroundColor = Colors.white;
      } else {
        _backGroundColor = Colors.black;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widget.size?.width ?? MediaQuery.of(context).size.width,
          height: widget.size?.height ?? MediaQuery.of(context).size.height * 0.85,
          decoration: widget.boxDecoration ??
              BoxDecoration(
                color: _backGroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                    color: widget.barrierColor ?? Colors.grey.withOpacity(1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.hideCloseIcon)
                IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 20,
                  icon: widget.closeIcon!,
                  onPressed: () => Navigator.pop(context),
                ),
              if (!widget.hideSearch)
                Padding(
                  padding: widget.searchPadding,
                  child: TextField(
                    style: widget.countryPickerThemeData?.searchTextStyle ?? _defaultTextStyle,
                    decoration: widget.searchDecoration,
                    onChanged: _filterElements,
                  ),
                ),
              Expanded(
                child: ListView(
                  children: [
                    widget.favoriteElements.isEmpty
                        ? const DecoratedBox(decoration: BoxDecoration())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.favoriteElements.map((f) => InkWell(
                                  onTap: () {
                                    _selectItem(f);
                                  },
                                  child: Padding(
                                    padding: widget.dialogItemPadding,
                                    child: _buildOption(f),
                                  ))),
                              const Divider(),
                            ],
                          ),
                    if (filteredElements.isEmpty)
                      _buildEmptySearchWidget(context)
                    else
                      ...filteredElements.map((e) => InkWell(
                          onTap: () {
                            _selectItem(e);
                          },
                          child: Padding(
                            padding: widget.dialogItemPadding,
                            child: _buildOption(e),
                          ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildOption(CountryCode e) {
    return SizedBox(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          if (widget.showFlag!)
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                decoration: widget.flagDecoration,
                clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                child: Image.asset(
                  e.flagUri!,
                  package: 'country_picker',
                  width: widget.countryPickerThemeData?.flagSize ?? 30,
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

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements =
          widget.elements.where((e) => e.code!.contains(s) || e.dialCode!.contains(s) || e.name!.toUpperCase().contains(s)).toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
