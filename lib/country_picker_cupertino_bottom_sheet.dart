import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryPickerCupertinoBottomSheet extends StatefulWidget {
  /// Here we have to provide the country list for showing the data.
  final List<Map<String, String>> listOfCountries;

  final EdgeInsets? countryListPadding;

  final LayoutConfig? layoutConfig;

  final CountryListConfig? countryListConfig;

  final Color? modalBarrierColor;

  final double? modalElevation;

  final Clip? clipBehavior;

  /// text overflow in use to manage text overflow for country name.
  final TextOverflow textOverflow;

  /// this properties is use for hide-show country flag in our screen.
  final bool showCountryMainFlag;

  /// this properties is use for hide-show country code in our screen.
  final bool showCountryMainCode;

  /// this properties is use for hide-show country name in our screen.
  final bool showCountryMainName;

  /// this properties is used to provide height of country picker.
  final double? heightOfPicker;

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

  final bool? useRootNavigator;

  final AnimationController? transitionAnimationController;

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
  final double? itemExtent;

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

  ///here this [onSelectValue] get the selected country value.
  final ValueChanged<CountryData> onSelectValue;

  /// widget is used to create a new UI of our selected data.
  final Widget? builder;

  final bool? isScrollControlled;
  final BoxConstraints? constraints;
  final ShapeBorder? shape;

  const CountryPickerCupertinoBottomSheet({
    super.key,
    this.listOfCountries = codes,
    this.textOverflow = TextOverflow.ellipsis,
    this.showCountryMainFlag = true,
    this.showCountryMainCode = true,
    this.showCountryMainName = true,
    this.heightOfPicker,
    this.useSafeArea = true,
    this.showDragHandle = false,
    this.useRootNavigator,
    this.transitionAnimationController,
    this.diameterRatio = 1.1,
    this.itemExtent,
    this.selectionOverlayWidget,
    this.backgroundColor,
    this.offAxisFraction = 0.2,
    this.squeeze = 1.45,
    this.magnification = 1.0,
    this.useMagnifier = true,
    required this.onSelectValue,
    this.builder,
    this.isScrollControlled,
    this.constraints,
    this.shape,
    this.layoutConfig = const LayoutConfig(),
    this.countryListConfig,
    this.modalBarrierColor,
    this.modalElevation,
    this.clipBehavior,
    this.countryListPadding,
  }) : assert((showCountryMainFlag || showCountryMainCode || showCountryMainName), 'At-least one data we need to show in a widget.');

  @override
  // ignore: no_logic_in_create_state
  State<CountryPickerCupertinoBottomSheet> createState() {
    List<CountryData> elements = listOfCountries.map((json) => CountryData.fromJson(json)).toList();

    if (countryListConfig?.comparator != null) {
      elements.sort(countryListConfig?.comparator);
    }

    if (countryListConfig?.countryFilter != null && countryListConfig!.countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = countryListConfig?.countryFilter?.map((e) => e.toUpperCase()).toList();
      elements = elements
          .where((element) =>
              uppercaseFilterElement!.contains(element.name) ||
              uppercaseFilterElement.contains(element.dialCode) ||
              uppercaseFilterElement.contains(element.code))
          .toList();
    }
    return CountryPickerCupertinoBottomSheetState(elements);
  }
}

class CountryPickerCupertinoBottomSheetState extends State<CountryPickerCupertinoBottomSheet> {
  CountryData? selectedItem;
  List<CountryData> elements = [];
  int initialItem = 0;

  CountryPickerCupertinoBottomSheetState(this.elements);

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 14);

  double calculateSize(double size) {
    int defaultSize = 50;
    debugPrint('$size====>${(size * defaultSize / _defaultTextStyle.fontSize!)}');
    return (size * defaultSize / _defaultTextStyle.fontSize!);
  }

  @override
  void initState() {
    super.initState();

    if (widget.countryListConfig?.selectInitialCountry != null) {
      selectedItem = elements.firstWhere(
          (item) =>
              (item.code!.toUpperCase() == widget.countryListConfig?.selectInitialCountry!.toUpperCase()) ||
              (item.dialCode == widget.countryListConfig?.selectInitialCountry) ||
              (item.name!.toUpperCase() == widget.countryListConfig?.selectInitialCountry!.toUpperCase()),
          orElse: () => elements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN"));
    } else {
      if (widget.countryListConfig?.selectInitialCountry != null) {
        selectedItem ??= elements.first;
      } else {
        selectedItem = elements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN");
      }
    }
    widget.onSelectValue(selectedItem!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    elements = elements.map((element) => element.localize(context)).toList();

    if ((widget.countryListConfig?.excludeCountry?.isNotEmpty ?? false) && widget.countryListConfig?.excludeCountry != null) {
      for (int i = 0; i < (widget.countryListConfig?.excludeCountry?.length ?? 0); i++) {
        for (int j = 0; j < elements.length; j++) {
          if ((widget.countryListConfig?.excludeCountry?[i].toLowerCase() == elements[j].name?.toLowerCase()) ||
              (widget.countryListConfig?.excludeCountry?[i] == elements[j].dialCode) ||
              (widget.countryListConfig?.excludeCountry?[i].toUpperCase() == elements[j].code)) {
            elements.removeAt(j);
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.builder != null)
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: showCountryPickerBottomSheet,
            child: AbsorbPointer(
              child: widget.builder,
            ),
          )
        : TextButton(
            onPressed: showCountryPickerBottomSheet,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.showCountryMainFlag)
                  Container(
                    clipBehavior: widget.layoutConfig?.flagDecoration == null ? Clip.none : Clip.hardEdge,
                    decoration: widget.layoutConfig?.flagDecoration,
                    margin: const EdgeInsets.only(right: 12),
                    child: Image.asset(
                      selectedItem!.flagUri!,
                      package: 'country_picker',
                      fit: BoxFit.cover,
                      width: widget.layoutConfig?.flagWidth ?? 24,
                      height: widget.layoutConfig?.flagHeight ?? 18,
                    ),
                  ),
                Flexible(
                  child: Text(
                    '${widget.showCountryMainCode ? selectedItem!.dialCode ?? '' : ''} ${widget.showCountryMainName ? selectedItem!.name! : ''}',
                    style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
                    overflow: widget.textOverflow,
                  ),
                ),
              ],
            ),
          );
  }

  void showCountryPickerBottomSheet() async {
    if ((widget.countryListConfig?.selectInitialCountry != null) || (selectedItem != null)) {
      for (int i = 0; i < elements.length; i++) {
        if (selectedItem == elements[i]) {
          initialItem = i;
        }
      }
    } else {
      initialItem = 0;
    }

    await showModalBottomSheet(
      isScrollControlled: widget.isScrollControlled ?? false,
      constraints: widget.constraints,
      shape: widget.shape,
      isDismissible: widget.layoutConfig?.isDismissible ?? true,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).bottomSheetTheme.modalBackgroundColor,
      barrierColor: widget.modalBarrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      elevation: widget.modalElevation ?? Theme.of(context).bottomSheetTheme.modalElevation,
      transitionAnimationController: widget.transitionAnimationController,
      clipBehavior: widget.clipBehavior ?? Theme.of(context).bottomSheetTheme.clipBehavior,
      useRootNavigator: widget.useRootNavigator ?? false,
      showDragHandle: widget.showDragHandle,
      useSafeArea: widget.useSafeArea,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.heightOfPicker ?? 250,
              child: CupertinoPicker(
                selectionOverlay: widget.selectionOverlayWidget ??
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                magnification: widget.magnification,
                useMagnifier: widget.useMagnifier,
                squeeze: widget.squeeze,
                offAxisFraction: widget.offAxisFraction,
                itemExtent: widget.itemExtent ?? 32,
                backgroundColor: widget.backgroundColor,
                onSelectedItemChanged: (int value) {
                  setState(() {
                    HapticFeedback.heavyImpact();
                    selectedItem = elements[value];
                    widget.onSelectValue(selectedItem!);
                  });
                },
                scrollController: FixedExtentScrollController(initialItem: initialItem),
                children: List<Widget>.generate(
                  elements.length,
                  (int index) {
                    if (widget.layoutConfig?.elementsSequence == Sequence.flagCodeAndCountryName) {
                      return Padding(
                        padding: widget.countryListPadding ?? const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
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
                                    elements[index].flagUri!,
                                    package: 'country_picker',
                                    width: widget.layoutConfig?.flagWidth ?? 24,
                                    height: widget.layoutConfig?.flagHeight ?? 18,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (widget.layoutConfig!.showCountryCode)
                              SizedBox(
                                width: calculateSize(widget.layoutConfig?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
                                child: Text(
                                  textAlign: TextAlign.start,
                                  elements[index].toString(),
                                  overflow: TextOverflow.fade,
                                  style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
                                ),
                              ),
                            Expanded(
                              child: Text(
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.left,
                                " ${widget.layoutConfig!.showCountryName ? elements[index].toCountryStringOnly() : ""}",
                                overflow: TextOverflow.fade,
                                style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: widget.countryListPadding ?? const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.layoutConfig!.showCountryCode)
                              SizedBox(
                                width: calculateSize(widget.layoutConfig?.textStyle?.fontSize ?? _defaultTextStyle.fontSize!),
                                child: Text(
                                  textAlign: TextAlign.start,
                                  elements[index].toString(),
                                  overflow: TextOverflow.fade,
                                  style: widget.layoutConfig?.textStyle ?? _defaultTextStyle,
                                ),
                              ),
                            Expanded(
                              child: Text(
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.left,
                                " ${widget.layoutConfig!.showCountryName ? elements[index].toCountryStringOnly() : ""}",
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
                                    elements[index].flagUri!,
                                    package: 'country_picker',
                                    width: widget.layoutConfig?.flagWidth ?? 28,
                                    height: widget.layoutConfig?.flagHeight ?? 18,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }
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
