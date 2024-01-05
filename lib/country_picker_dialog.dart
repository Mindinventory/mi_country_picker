library country_picker;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

import 'src/localizations.dart';
import 'src/models/country_code_model.dart';
import 'src/codes.dart';

export 'src/models/country_code_model.dart';
export 'src/codes.dart';
export 'src/localizations.dart';

class CountryCodeDialogPicker extends StatefulWidget {
  final ValueChanged<CountryCode>? onChanged;
  final String? initialValue;
  final TextStyle? textStyle;
  final TextStyle? searchTextStyle;
  final TextStyle? dialogTextStyle;
  final WidgetBuilder? emptyResult;
  final TextOverflow textOverflow;

  final List<Map<String, String>> countryList;

  const CountryCodeDialogPicker({
    this.onChanged,
    this.initialValue,
    this.textStyle,
    this.searchTextStyle,
    this.dialogTextStyle,
    this.emptyResult,
    this.textOverflow = TextOverflow.ellipsis,
    this.countryList = codes,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    List<Map<String, String>> jsonList = countryList;
    List<CountryCode> elements = jsonList.map((json) => CountryCode.fromJson(json)).toList();
    return CountryCodePickerState(elements);
  }
}

class CountryCodePickerState extends State<CountryCodeDialogPicker> {
  late List<CountryCode> searchResult;
  CountryCode? selectedItem;
  List<CountryCode> elements = [];

  CountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: showCountryCodePickerDialog,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              clipBehavior: Clip.none,
              margin: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                selectedItem!.countryFlag!,
                package: 'country_picker',
                width: 36.0,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              selectedItem!.toLongString(),
              style: widget.textStyle ?? Theme.of(context).textTheme.labelLarge,
              overflow: widget.textOverflow,
            ),
          ),
          const Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
                size: 36.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    elements = elements.map((element) => element.localize(context)).toList();
  }

  @override
  void initState() {
    super.initState();

    searchResult = elements;

    if (widget.initialValue != null) {
      selectedItem = elements.firstWhere(
          (item) =>
              (item.countryCode!.toUpperCase() == widget.initialValue!.toUpperCase()) ||
              (item.countryDialCode == widget.initialValue) ||
              (item.countryName!.toUpperCase() == widget.initialValue!.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }
  }

  void showCountryCodePickerDialog() async {
    final item = await showDialog(
      context: context,
      builder: (context) => Center(
        child: Dialog(
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
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
                IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 20,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    style: widget.searchTextStyle,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
                    onChanged: searchNames,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        const DecoratedBox(decoration: BoxDecoration()),
                        if (searchResult.isEmpty)
                          Center(
                            child: Text(CountryPickerLocalizations.of(context)?.translate('no_country') ?? 'No country found'),
                          )
                        else
                          ...searchResult.map(
                            (item) => InkWell(
                              onTap: () {
                                navigateBackWithItem(item);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                child: _buildOption(item),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (item != null) {
      setState(() {
        selectedItem = item;
      });

      _publishSelection(item);
    }
  }

  void _publishSelection(CountryCode countryCode) {
    if (widget.onChanged != null) {
      widget.onChanged!(countryCode);
    }
  }

  void searchNames(String text) {
    text = text.toUpperCase();
    setState(() {
      searchResult = elements
          .where((e) => e.countryCode!.contains(text) || e.countryDialCode!.contains(text) || e.countryName!.toUpperCase().contains(text))
          .toList();
    });
  }

  void navigateBackWithItem(CountryCode item) {
    Navigator.pop(context, item);
  }

  Widget _buildOption(CountryCode e) {
    return SizedBox(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              clipBehavior: Clip.none,
              child: Image.asset(
                e.countryFlag!,
                package: 'country_picker',
                width: 36.0,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              e.toLongString(),
              overflow: TextOverflow.fade,
              style: widget.textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
