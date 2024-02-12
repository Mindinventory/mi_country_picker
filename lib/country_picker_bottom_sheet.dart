import 'package:mi_country_picker/mi_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mi_country_picker/src/codes.dart';
import 'package:mi_country_picker/src/country_selection_bottom.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  ///here this [onSelectValue] get the selected country value.
  final ValueChanged<CountryData> onSelectValue;

  /// it is optional argument to set your own custom country list
  final List<Map<String, String>> listOfCountries;

  /// add your favorites countries
  final List<String>? favorite;

  final LayoutConfig? layoutConfig;

  final bool? isDismissible;

  final CountryListConfig? countryListConfig;

  final Function(CountryData? value)? builder;
  final EdgeInsetsGeometry? searchBoxMargin;
  final EdgeInsetsGeometry? countryItemPadding;
  final EdgeInsets? countryListViewPadding;
  final Icon? searchIcon;
  final Icon? closedDialogIcon;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showDialogHeading;
  final Text? countryPickerDialogHeading;
  final bool hideCloseIcon;
  final bool showSearchBar;
  final double? searchBoxHeight;
  final String? hintText;
  final TextStyle? searchTextStyle;
  final SearchStyle? searchStyle;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final Color? barrierColor;
  final bool? useSafeArea;
  final InputDecoration? searchFieldInputDecoration;
  final Offset? anchorPoint;
  final BoxConstraints? constraints;
  final Clip? clipBehavior;
  final bool? isScrollControlled;
  final String? barrierLabel;
  final double? elevation;
  final bool? enableDrag;
  final RouteSettings? routeSettings;
  final double? scrollControlDisabledMaxHeightRatio;
  final bool? showDragHandle;
  final AnimationController? transitionAnimationController;
  final bool? useRootNavigator;

  const CountryPickerBottomSheet({
    super.key,
    this.layoutConfig = const LayoutConfig(),
    required this.onSelectValue,
    this.backgroundColor,
    this.shape,
    this.barrierColor,
    this.useSafeArea = false,
    this.hideCloseIcon = false,
    this.showSearchBar = true,
    this.anchorPoint,
    this.constraints,
    this.clipBehavior,
    this.isScrollControlled = false,
    this.barrierLabel,
    this.elevation,
    this.enableDrag = true,
    this.routeSettings,
    this.scrollControlDisabledMaxHeightRatio,
    this.showDragHandle,
    this.transitionAnimationController,
    this.useRootNavigator,
    this.searchBoxHeight,
    this.searchStyle,
    this.hintText,
    this.showDialogHeading = true,
    this.countryPickerDialogHeading,
    this.countryListViewPadding,
    this.emptySearchBuilder,
    this.searchIcon,
    this.closedDialogIcon,
    this.countryItemPadding,
    this.searchBoxMargin,
    this.builder,
    this.countryListConfig,
    this.searchFieldInputDecoration,
    this.listOfCountries = codes,
    this.favorite,
    this.isDismissible,
    this.searchTextStyle,
  });

  @override
  // ignore: no_logic_in_create_state
  State<CountryPickerBottomSheet> createState() {
    List<CountryData> countriesElements = listOfCountries.map((element) => CountryData.fromJson(element)).toList();

    if (countryListConfig?.comparator != null) {
      countriesElements.sort(countryListConfig?.comparator);
    }

    if (countryListConfig?.countryFilter != null && countryListConfig!.countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = countryListConfig?.countryFilter?.map((e) => e.toUpperCase()).toList();
      countriesElements = countriesElements
          .where((element) =>
              uppercaseFilterElement!.contains(element.name) ||
              uppercaseFilterElement.contains(element.dialCode) ||
              uppercaseFilterElement.contains(element.code))
          .toList();
    }

    return _CountryPickerBottomSheetState(countriesElements);
  }
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  List<CountryData> countriesElements = [];
  CountryData? selectedItem;
  List<CountryData> favoritesCountries = [];

  _CountryPickerBottomSheetState(this.countriesElements);

  @override
  void initState() {
    super.initState();
    // if (widget.countryListConfig?.selectInitialCountry != null) {
    //   selectedItem = countriesElements.firstWhere(
    //     (element) =>
    //         element.name == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //         element.dialCode == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //         element.code == widget.countryListConfig?.selectInitialCountry?.toUpperCase(),
    //     orElse: () =>
    //         countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN"),
    //   );
    // } else {
    //   if (widget.countryListConfig?.countryFilter != null) {
    //     selectedItem ??= countriesElements.first;
    //   } else {
    //     selectedItem =
    //         countriesElements.firstWhere((element) => element.name == "भारत" || element.dialCode == "+91" || element.code == "IN");
    //   }
    // }
    if (widget.countryListConfig?.excludeCountry != null && widget.countryListConfig!.excludeCountry!.isNotEmpty) {
      for (int i = 0; i < (widget.countryListConfig?.excludeCountry?.length ?? 0); i++) {
        for (int j = 0; j < countriesElements.length; j++) {
          if ((widget.countryListConfig?.excludeCountry?[i].toLowerCase() == countriesElements[j].name?.toLowerCase()) ||
              (widget.countryListConfig?.excludeCountry?[i] == countriesElements[j].dialCode) ||
              (widget.countryListConfig?.excludeCountry?[i].toUpperCase() == countriesElements[j].code)) {
            countriesElements.removeAt(j);
            break;
          }
        }
      }
    }
    if (widget.favorite != null) {
      favoritesCountries = countriesElements.where((element) => widget.favorite?.contains(element.dialCode) ?? false).toList();
    }
    widget.onSelectValue(selectedItem!);
  }

  @override
  void didUpdateWidget(covariant CountryPickerBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.countryListConfig?.selectInitialCountry != widget.countryListConfig?.selectInitialCountry) {
    //   if (widget.countryListConfig?.selectInitialCountry != null) {
    //     selectedItem = countriesElements.firstWhere(
    //       (element) =>
    //           element.name == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //           element.dialCode == widget.countryListConfig?.selectInitialCountry?.toUpperCase() ||
    //           element.code == widget.countryListConfig?.selectInitialCountry?.toUpperCase(),
    //       orElse: () => countriesElements[0],
    //     );
    //   }
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    countriesElements = countriesElements.map((e) => e.localize(context)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return InkWell(
        onTap: () {
          showBottomSheet();
        },
        child: widget.builder!(selectedItem),
      );
    } else {
      return InkWell(
        onTap: showBottomSheet,
        child: TextButton(
          onPressed: () {
            showBottomSheet();
          },
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: Image.asset(
                  selectedItem!.flagUri!,
                  package: 'mi_country_picker',
                  width: widget.layoutConfig?.flagWidth ?? 24,
                  height: widget.layoutConfig?.flagHeight ?? 18,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                '${selectedItem!.dialCode ?? ''} ${selectedItem?.name ?? ""}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: widget.backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: widget.shape,
      barrierColor: widget.barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      useSafeArea: widget.useSafeArea ?? false,
      isDismissible: widget.isDismissible ?? true,
      anchorPoint: widget.anchorPoint,
      constraints: widget.constraints,
      clipBehavior: widget.clipBehavior ?? Theme.of(context).bottomSheetTheme.clipBehavior,
      isScrollControlled: widget.isScrollControlled ?? false,
      barrierLabel: widget.barrierLabel,
      elevation: widget.elevation ?? Theme.of(context).bottomSheetTheme.elevation,
      enableDrag: widget.enableDrag ?? true,
      routeSettings: widget.routeSettings,
      scrollControlDisabledMaxHeightRatio: widget.scrollControlDisabledMaxHeightRatio ?? 9.0 / 16.0,
      showDragHandle: widget.showDragHandle ?? false,
      transitionAnimationController: widget.transitionAnimationController,
      useRootNavigator: widget.useRootNavigator ?? false,
      context: context,
      builder: (_) {
        return CountrySelectionBottom(
          layoutConfig: widget.layoutConfig,
          countryListConfig: widget.countryListConfig,
          searchStyle: widget.searchStyle,
          showSearchBar: widget.showSearchBar,
          header: widget.countryPickerDialogHeading,
          emptySearchBuilder: widget.emptySearchBuilder,
          countryTilePadding: widget.countryItemPadding,
        );
      },
    );
  }
}
