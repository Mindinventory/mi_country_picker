import 'package:flutter/material.dart';
import 'package:mi_country_picker/src/codes.dart';
import 'package:mi_country_picker/src/country_selection_bottom.dart';
import 'package:mi_country_picker/src/country_selection_dialog.dart';

import 'src/country_picker_cupertino_bottom_sheet.dart';
import 'mi_country_picker.dart';

class CountryPicker {
  static Future<CountryData?> showCountryPickerDialog({
    required BuildContext context,
    LayoutConfig? layoutConfig,
    Widget? closeIconWidget,
    CountryListConfig? countryListConfig,
    SearchStyle? searchStyle,

    /// favourite countries will be placed on the top of list.
    List<String>? favouriteCountries,
    bool? isDismissible,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    bool? useSafeArea,
    AlignmentGeometry? alignment,
    Clip? clipBehavior,
    EdgeInsets? insetPadding,
    Color? shadowColor,
    Widget? header,
    Color? barrierColor,
    EdgeInsetsGeometry? countryTilePadding,
    bool? showSearchBar,
    Size? size,
    WidgetBuilder? emptySearchBuilder,
  }) async {
    return await showDialog(
      useSafeArea: useSafeArea ?? true,
      barrierDismissible: isDismissible ?? true,
      barrierColor: barrierColor,
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            backgroundColor: Colors.transparent,
            shadowColor: shadowColor,
            insetPadding: insetPadding,
            clipBehavior: clipBehavior ?? Clip.none,
            alignment: alignment,
            child: CountrySelectionDialog(
              searchStyle: searchStyle,
              favouriteCountries: favouriteCountries,
              countryListConfig: countryListConfig,
              closeIconWidget: closeIconWidget,
              layoutConfig: layoutConfig,
              borderRadius: borderRadius,
              backGroundColor: backgroundColor ?? Theme.of(context).dialogBackgroundColor,
              countryTilePadding: countryTilePadding,
              emptySearchBuilder: emptySearchBuilder,
              showSearchBar: showSearchBar,
              size: size,
              header: header,
            ),
          ),
        );
      },
    );
  }

  static CountryData getInitialValue({
    required BuildContext context,
    String? initialCountryValue,
  }) {
    Map<String, String> getInitialValue;
    if (initialCountryValue != null) {
      getInitialValue = codes.firstWhere(
        (element) =>
            element['code'] == initialCountryValue ||
            element['name']?.toLowerCase() == initialCountryValue.toLowerCase() ||
            element['dial_code'] == initialCountryValue,
      );
    } else {
      getInitialValue = {
        "name": "भारत",
        "code": "IN",
        "dial_code": "+91",
      };
    }
    return CountryData.fromJson(getInitialValue).localize(context);
  }

  static Future<CountryData?> showCountryPickerBottomSheet(
      {required BuildContext context,
      Color? backgroundColor,
      LayoutConfig? layoutConfig,
      List<String>? favouriteCountries,
      CountryListConfig? countryListConfig,
      SearchStyle? searchStyle,
      Widget? closeIconWidget,
      ShapeBorder? shape,
      Color? barrierColor,
      bool? useSafeArea,
      bool? isDismissible,
      Offset? anchorPoint,
      Clip? clipBehavior,
      bool? showSearchBar,
      BoxConstraints? constraints,
      bool? isScrollControlled,
      Text? header,
      String? barrierLabel,
      WidgetBuilder? emptySearchBuilder,
      double? elevation,
      bool? enableDrag,
      RouteSettings? routeSettings,
      EdgeInsetsGeometry? countryTilePadding,
      double? scrollControlDisabledMaxHeightRatio,
      bool? showDragHandle,
      AnimationController? transitionAnimationController,
      bool? useRootNavigator}) async {
    return await showModalBottomSheet(
      backgroundColor: backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: shape,
      barrierColor: barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      useSafeArea: useSafeArea ?? false,
      isDismissible: isDismissible ?? true,
      anchorPoint: anchorPoint,
      constraints: constraints,
      clipBehavior: clipBehavior ?? Theme.of(context).bottomSheetTheme.clipBehavior,
      isScrollControlled: isScrollControlled ?? false,
      barrierLabel: barrierLabel,
      elevation: elevation ?? Theme.of(context).bottomSheetTheme.elevation,
      enableDrag: enableDrag ?? true,
      routeSettings: routeSettings,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio ?? 9.0 / 16.0,
      showDragHandle: showDragHandle ?? false,
      transitionAnimationController: transitionAnimationController,
      useRootNavigator: useRootNavigator ?? false,
      context: context,
      builder: (_) {
        return CountrySelectionBottomSheet(
          favouriteCountries: favouriteCountries,
          searchStyle: searchStyle,
          countryListConfig: countryListConfig,
          layoutConfig: layoutConfig,
          showSearchBar: showSearchBar,
          header: header,
          emptySearchBuilder: emptySearchBuilder,
          closeIconWidget: closeIconWidget,
          countryTilePadding: countryTilePadding,
        );
      },
    );
  }

  static Future<CountryData?> showCountryPickerCupertinoBottomSheet(
      {required BuildContext context,
      CountryData? setInitialValue,
      bool? isScrollControlled,
      BoxConstraints? constraints,
      ShapeBorder? shape,
      bool? isDismissible,
      Color? backgroundColor,
      Color? barrierColor,
      double? elevation,
      AnimationController? transitionAnimationController,
      Clip? clipBehavior,
      bool? useRootNavigator,
      bool? showDragHandle,
      bool? useSafeArea,
      double? heightOfPicker,
      Widget? selectionOverlay,
      double? magnification,
      bool? useMagnifier,
      double? squeeze,
      double? offAxisFraction,
      double? itemExtent,
      LayoutConfig? layoutConfig,
      CountryListConfig? countryListConfig,
      double? diameterRatio,
      EdgeInsets? countryTilePadding}) async {
    CountryData? countryData;
    await showModalBottomSheet(
      isScrollControlled: isScrollControlled ?? false,
      constraints: constraints,
      context: context,
      shape: shape,
      isDismissible: isDismissible ?? true,
      backgroundColor: backgroundColor ?? Theme.of(context).bottomSheetTheme.modalBackgroundColor,
      barrierColor: barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      elevation: elevation ?? Theme.of(context).bottomSheetTheme.modalElevation,
      transitionAnimationController: transitionAnimationController,
      clipBehavior: clipBehavior,
      useRootNavigator: useRootNavigator ?? false,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea ?? false,
      builder: (BuildContext context) {
        return CountryPickerCupertinoBottomSheet(
          diameterRatio: diameterRatio,
          onChanged: (value) {
            countryData = value;
          },
          setInitialValue: setInitialValue,
          useMagnifier: useMagnifier ?? true,
          countryTilePadding: countryTilePadding,
          heightOfPicker: heightOfPicker,
          selectionOverlayWidget: selectionOverlay,
          magnification: magnification ?? 1.0,
          squeeze: squeeze ?? 1.45,
          offAxisFraction: offAxisFraction ?? 0.0,
          itemExtent: itemExtent ?? 32,
          backgroundColor: backgroundColor ?? Theme.of(context).bottomSheetTheme.modalBackgroundColor,
          layoutConfig: layoutConfig,
          countryListConfig: countryListConfig,
        );
      },
    );
    return countryData;
  }
}
