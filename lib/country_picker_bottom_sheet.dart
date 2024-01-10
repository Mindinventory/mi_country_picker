import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  /// Here we have to provide the country list for showing the data.
  final List<Map<String, String>> countryList;

  /// this parameter is use to set initial selected value in country picker.
  final String? initialValue;

  /// this parameter is use to set text-style of country code and country name.
  final TextStyle? textStyle;

  /// this parameter is use to remove particular country from our list.
  final List<String>? excludeCountry;

  /// text overflow in use to mange text overflow for country name.
  final TextOverflow textOverflow;

  /// this properties is use for hide-show country flag in our screen.
  final bool showCountryMainFlag;

  /// this properties is use for hide-show country flag in our bottom sheet list.
  final bool showCountryFlag;

  /// this properties is use for hide-show country code in our screen.
  final bool showCountryMainCode;

  /// this properties is use for hide-show country code in our bottom sheet list.
  final bool showCountryCode;

  /// this properties is use for hide-show country name in our screen.
  final bool showCountryMainName;

  /// this properties is use for hide-show country name in our bottom sheet list.
  final bool showCountryName;

  /// [BoxDecoration] for the flag image
  final Decoration? flagDecoration;

  /// Width of the flag images
  final double flagWidth;

  /// this properties is used to provide height of country picker.
  final double heightOfPicker;

  /// Bottom sheet properties

  /// Whether to avoid system intrusions on the top, left, and right.
  /// If true, a [SafeArea] is inserted to keep the bottom sheet away from
  /// system intrusions at the top, left, and right sides of the screen.
  ///
  /// If false, the bottom sheet isn't exposed to the top padding of the
  /// MediaQuery.
  ///
  /// In either case, the bottom sheet extends all the way to the bottom of
  /// the screen, including any system intrusions.
  ///
  /// The default is false.
  final bool useSafeArea;

  /// The drag handle appears at the top of the bottom sheet. The default color is
  /// [ColorScheme.onSurfaceVariant] with an opacity of 0.4 and can be customized
  /// using dragHandleColor. The default size is `Size(32,4)` and can be customized
  /// with dragHandleSize.
  ///
  /// If null, then the value of  [BottomSheetThemeData.showDragHandle] is used. If
  /// that is also null, defaults to false.
  final bool showDragHandle;

  /// Cupertino picker properties

  /// Relative ratio between this picker's height and the simulated cylinder's diameter.
  ///
  /// Smaller values creates more pronounced curvatures in the scrollable wheel.
  ///
  /// For more details, see [ListWheelScrollView.diameterRatio].
  ///
  /// Defaults to 1.1 to visually mimic iOS.
  final double diameterRatio;

  /// The uniform height of all children.
  ///
  /// All children will be given the [BoxConstraints] to match this exact
  /// height. Must be a positive value.
  final double itemExtent;

  /// A widget overlaid on the picker to highlight the currently selected entry.
  ///
  /// The [selectionOverlay] widget drawn above the [CupertinoPicker]'s picker
  /// wheel.
  /// It is vertically centered in the picker and is constrained to have the
  /// same height as the center row.
  ///
  /// If unspecified, it defaults to a [CupertinoPickerDefaultSelectionOverlay]
  /// which is a gray rounded rectangle overlay in iOS 14 style.
  /// This property can be set to null to remove the overlay.
  final Widget? selectionOverlayWidget;

  /// Background color behind the children.
  ///
  /// Defaults to null, which disables background painting entirely.
  /// (i.e. the picker is going to have a completely transparent background), to match
  /// the native UIPicker and UIDatePicker.
  ///
  /// Any alpha value less 255 (fully opaque) will cause the removal of the
  /// wheel list edge fade gradient from rendering of the widget.
  final Color? backgroundColor;

  final double offAxisFraction;
  final double squeeze;
  final double magnification;
  final bool useMagnifier;

  const CountryPickerBottomSheet({
    this.countryList = codes,
    this.initialValue,
    this.textStyle,
    this.excludeCountry,
    this.textOverflow = TextOverflow.ellipsis,
    this.showCountryMainFlag = true,
    this.showCountryFlag = true,
    this.showCountryMainCode = true,
    this.showCountryCode = true,
    this.showCountryMainName = true,
    this.showCountryName = true,
    this.flagDecoration,
    this.flagWidth = 32.0,
    this.heightOfPicker = 250,
    this.useSafeArea = true,
    this.showDragHandle = false,
    this.diameterRatio = 1.1,
    this.itemExtent = 32,
    this.selectionOverlayWidget,
    this.backgroundColor,
    this.offAxisFraction = 0.2,
    this.squeeze = 1.45,
    this.magnification = 1.0,
    this.useMagnifier = true,
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
  CountryCode? selectedItem;
  List<CountryCode> elements = [];
  int initialItem = 0;

  CountryPickerBottomSheetState(this.elements);

  @override
  void initState() {
    super.initState();

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

    for (int i = 0; i < (widget.excludeCountry?.length ?? 0); i++) {
      for (int j = 0; j < elements.length; j++) {
        if ((widget.excludeCountry?[i].toLowerCase() == elements[j].name?.toLowerCase()) ||
            (widget.excludeCountry?[i] == elements[j].dialCode) ||
            (widget.excludeCountry?[i].toUpperCase() == elements[j].code)) {
          elements.removeAt(j);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: showCountryPickerBottomSheet,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.showCountryMainFlag)
            Container(
              clipBehavior: widget.flagDecoration == null ? Clip.none : Clip.hardEdge,
              decoration: widget.flagDecoration,
              margin: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                selectedItem!.flagUri!,
                package: 'country_picker',
                width: widget.flagWidth,
              ),
            ),
          if (widget.showCountryMainCode)
            Text(
              '${selectedItem!.dialCode ?? ''} ',
              style: widget.textStyle ?? Theme.of(context).textTheme.labelLarge,
              overflow: widget.textOverflow,
            ),
          if (widget.showCountryMainName)
            Text(
              selectedItem!.name!,
              style: widget.textStyle ?? Theme.of(context).textTheme.labelLarge,
              overflow: widget.textOverflow,
            ),
        ],
      ),
    );
  }

  void showCountryPickerBottomSheet() async {
    if ((widget.initialValue != null) || (selectedItem != null)) {
      for (int i = 0; i < elements.length; i++) {
        if (selectedItem == elements[i]) {
          initialItem = i;
        }
      }
    } else {
      initialItem = 0;
    }

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
                              margin: const EdgeInsets.only(right: 16.0),
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
}
