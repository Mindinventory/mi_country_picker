import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  final String? initialValue;
  final TextStyle? textStyle;
  final TextOverflow textOverflow;
  final List<Map<String, String>> countryList;
  final bool showCountryMainFlag;
  final bool showCountryFlag;
  final bool showCountryMainCode;
  final bool showCountryCode;
  final bool showCountryMainName;
  final bool showCountryName;

  /// [BoxDecoration] for the flag image
  final Decoration? flagDecoration;
  final bool alignLeft;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  /// Width of the flag images
  final double flagWidth;

  final double heightOfPicker;

  /// Cupertino picker properties
  final double diameterRatio;

  final double itemExtent;

  final Widget? selectionOverlayWidget;

  final Color? backgroundColor;

  final double offAxisFraction;
  final double squeeze;
  final double magnification;
  final bool useMagnifier;
  final bool useSafeArea;
  final bool showDragHandle;

  const CountryPickerBottomSheet({
    this.initialValue,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
    this.countryList = codes,
    this.showCountryMainFlag = true,
    this.showCountryFlag = true,
    this.showCountryMainCode = true,
    this.showCountryCode = true,
    this.showCountryMainName = true,
    this.showCountryName = true,
    this.flagDecoration,
    this.alignLeft = false,
    this.enabled = true,
    this.padding = const EdgeInsets.all(8.0),
    this.flagWidth = 32.0,
    this.heightOfPicker = 250,
    this.diameterRatio = 1.1,
    this.itemExtent = 32,
    this.selectionOverlayWidget,
    this.backgroundColor,
    this.offAxisFraction = 0.2,
    this.squeeze = 1.45,
    this.magnification = 1.0,
    this.useMagnifier = true,
    this.useSafeArea = true,
    this.showDragHandle = false,
    Key? key,
  }) : super(key: key);

  @override
// ignore: no_logic_in_create_state
  State<CountryPickerBottomSheet> createState() {
    List<Map<String, String>> jsonList = countryList;
    List<CountryCode> elements = jsonList.map((json) => CountryCode.fromJson(json)).toList();
    return CountryPickerBottomSheetState(elements);
  }
}

class CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
// late List<CountryCode> searchResult;
  CountryCode? selectedItem;
  List<CountryCode> elements = [];
  int initialItem = 0;

  CountryPickerBottomSheetState(this.elements);

  @override
  void initState() {
    super.initState();

// searchResult = elements;
    if (widget.initialValue != null) {
      selectedItem = elements.firstWhere(
          (item) =>
              (item.code!.toUpperCase() == widget.initialValue!.toUpperCase()) ||
              (item.dialCode == widget.initialValue) ||
              (item.name!.toUpperCase() == widget.initialValue!.toUpperCase()),
          orElse: () => elements[0]);

      for (int i = 0; i < elements.length; i++) {
        if (selectedItem == elements[i]) {
          initialItem = i;
        }
      }
    } else {
      selectedItem = elements[0];
      initialItem = 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    elements = elements.map((element) => element.localize(context)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.enabled ? showCountryPickerBottomSheet : null,
      child: Padding(
        padding: widget.padding,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.showCountryMainFlag)
              Flexible(
                flex: widget.alignLeft ? 0 : 1,
                fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                child: Container(
                  clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                  decoration: widget.flagDecoration,
                  margin: widget.alignLeft ? const EdgeInsets.only(right: 16.0, left: 8.0) : const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    selectedItem!.flagUri!,
                    package: 'country_picker',
                    width: widget.flagWidth,
                  ),
                ),
              ),
            if (widget.showCountryMainCode)
              Flexible(
                fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                child: Text(
                  '${selectedItem!.dialCode ?? ''} ',
                  style: widget.textStyle ?? Theme.of(context).textTheme.labelLarge,
                  overflow: widget.textOverflow,
                ),
              ),
            if (widget.showCountryMainName)
              Flexible(
                fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                child: Text(
                  selectedItem!.name!,
                  style: widget.textStyle ?? Theme.of(context).textTheme.labelLarge,
                  overflow: widget.textOverflow,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showCountryPickerBottomSheet() async {
    await showModalBottomSheet(
      showDragHandle: widget.showDragHandle,
      useSafeArea: widget.useSafeArea,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.heightOfPicker,
              child: CupertinoPicker(
                selectionOverlay: widget.selectionOverlayWidget ??
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                diameterRatio: widget.diameterRatio,
                magnification: widget.magnification,
                useMagnifier: widget.useMagnifier,
                squeeze: widget.squeeze,
                offAxisFraction: widget.offAxisFraction,
                itemExtent: widget.itemExtent,
                backgroundColor: widget.backgroundColor,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    HapticFeedback.heavyImpact();
                    selectedItem = elements[value];
                  });
                },
                scrollController: FixedExtentScrollController(initialItem: initialItem),
                children: List<Widget>.generate(
                  elements.length,
                  (int index) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (widget.showCountryFlag)
                            Container(
                              clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
                              decoration: widget.flagDecoration,
                              margin: widget.alignLeft ? const EdgeInsets.only(right: 16.0, left: 8.0) : const EdgeInsets.only(right: 16.0),
                              child: Image.asset(
                                elements[index].flagUri ?? "",
                                package: 'country_picker',
                                width: widget.flagWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (widget.showCountryCode)
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 2,
                              child: Text(
                                '${elements[index].dialCode}  ',
                                overflow: TextOverflow.ellipsis,
                                style: widget.textStyle,
                              ),
                            ),
                          if (widget.showCountryName)
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 6,
                              child: Text(
                                elements[index].name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: widget.textStyle,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

// void showCountryPickerBottomSheet() async {
//   final item = await showDialog(
//     context: context,
//     builder: (context) => Center(
//       child: Dialog(
//         child: Container(
//           clipBehavior: Clip.hardEdge,
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(1),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: const Offset(0, 3), // changes position of shadow
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                 padding: const EdgeInsets.all(0),
//                 iconSize: 20,
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: TextField(
//                   style: widget.searchTextStyle,
//                   decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
//                   onChanged: searchNames,
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView(
//                     children: [
//                       const DecoratedBox(decoration: BoxDecoration()),
//                       if (searchResult.isEmpty)
//                         Center(
//                           child: Text(CountryPickerLocalizations.of(context)?.translate('no_country') ?? 'No country found'),
//                         )
//                       else
//                         ...searchResult.map(
//                           (item) => InkWell(
//                             onTap: () {
//                               navigateBackWithItem(item);
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//                               child: _buildOption(item),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
//
//   if (item != null) {
//     setState(() {
//       selectedItem = item;
//     });
//
//     _publishSelection(item);
//   }
// }

// void searchNames(String text) {
//   text = text.toUpperCase();
//   setState(() {
//     searchResult = elements
//         .where((e) => e.countryCode!.contains(text) || e.countryDialCode!.contains(text) || e.countryName!.toUpperCase().contains(text))
//         .toList();
//   });
// }

// void navigateBackWithItem(CountryCode item) {
//   Navigator.pop(context, item);
// }

// Widget _buildOption(CountryCode e) {
//   return SizedBox(
//     width: 400,
//     child: Flex(
//       direction: Axis.horizontal,
//       children: <Widget>[
//         Flexible(
//           child: Container(
//             margin: const EdgeInsets.only(right: 16.0),
//             clipBehavior: Clip.none,
//             child: Image.asset(
//               e.countryFlag!,
//               package: 'country_picker',
//               width: 36.0,
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 4,
//           child: Text(
//             e.toLongString(),
//             overflow: TextOverflow.fade,
//             style: widget.textStyle,
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
