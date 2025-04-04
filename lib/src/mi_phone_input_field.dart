import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_country_picker/mi_country_picker.dart';

class MiPhoneInputField extends StatefulWidget {
  const MiPhoneInputField({
    super.key,
    required this.textEditingController,
    this.focusNode,
    // Input decoration properties
    this.hintText,
    this.hintTextStyle,
    this.errorMaxLines = 5,
    this.fillColor,
    this.filled = true,
    this.contentPadding,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.borderColor,
    this.errorBorderColor,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.suffixText,
    this.suffixTextStyle,
    this.errorStyle,
    this.counterText,
    // Text field properties
    this.textStyle,
    this.onTapOutside,
    this.onTap,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.textInputFormatter,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.phone,
    this.textInputAction = TextInputAction.next,
    this.onChange,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autoFocus = false,
    this.autoCorrect = true,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.enabled = true,
    // Country picker related properties
    this.initialCountryCode,
    this.onCountryChanged,
    this.showCountryFlag = true,
    this.showCountryCode = true,
    this.countryPickerType = CountryPickerType.dialog,
    this.countryPickerLayoutConfig,
    this.countryPickerListConfig,
    this.countryPickerSearchStyle,
    this.favouriteCountries,
    this.countryCodeTextStyle,
    this.countryFlagWidth = 24.0,
    this.countryFlagHeight = 16.0,
    this.countrySelectorPadding,
    this.countrySelectorMargin = EdgeInsets.zero,
    this.countryPickerBackgroundColor,
    this.countryPickerBorderRadius,
    this.countryPickerShowSearchBar = true,
    this.countryPickerIsDismissible = true,
    this.countryPickerEmptySearchBuilder,
    this.phoneNumberAutoFormat = true,
    this.countryFlagBorderRadius,
    // Additional fields
    this.formFieldKey,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.initialValue,
    this.onSaved,
    this.keyboardAppearance,
    this.searchText = 'Search country',
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.magnifierConfiguration,
    this.disableLengthCheck = false,
    this.pickerDialogStyle,
    this.disableAutoFillHints = false,
    this.showDropdownIcon = true,
  });

  final TextEditingController textEditingController;
  final FocusNode? focusNode;

  // Input decoration properties
  final String? hintText;
  final TextStyle? hintTextStyle;
  final int errorMaxLines;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final TextStyle? errorStyle;
  final String? counterText;

  // Text field properties
  final TextStyle? textStyle;
  final VoidCallback? onTapOutside;
  final VoidCallback? onTap;
  final bool obscureText;
  final String obscuringCharacter;
  final List<TextInputFormatter>? textInputFormatter;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autoFocus;
  final bool autoCorrect;
  final Color? cursorColor;
  final double? cursorHeight;
  final Radius cursorRadius;
  final double cursorWidth;
  final bool showCursor;
  final bool enabled;

  // Country picker related properties
  final String? initialCountryCode;
  final Function(CountryData)? onCountryChanged;
  final bool showCountryFlag;
  final bool showCountryCode;
  final CountryPickerType countryPickerType;
  final LayoutConfig? countryPickerLayoutConfig;
  final CountryListConfig? countryPickerListConfig;
  final SearchStyle? countryPickerSearchStyle;
  final List<String>? favouriteCountries;
  final TextStyle? countryCodeTextStyle;
  final double countryFlagWidth;
  final double countryFlagHeight;
  final EdgeInsets? countrySelectorPadding;
  final EdgeInsets? countrySelectorMargin;
  final Color? countryPickerBackgroundColor;
  final BorderRadiusGeometry? countryPickerBorderRadius;
  final bool countryPickerShowSearchBar;
  final bool countryPickerIsDismissible;
  final WidgetBuilder? countryPickerEmptySearchBuilder;
  final bool phoneNumberAutoFormat;
  final BorderRadius? countryFlagBorderRadius;

  // Additional fields
  final GlobalKey<FormFieldState>? formFieldKey;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final String? initialValue;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final Brightness? keyboardAppearance;
  final String searchText;
  final IconPosition dropdownIconPosition;
  final Icon dropdownIcon;
  final AutovalidateMode autovalidateMode;
  final String invalidNumberMessage;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final bool disableLengthCheck;
  final PickerDialogStyle? pickerDialogStyle;
  final bool disableAutoFillHints;
  final bool showDropdownIcon;

  @override
  State<MiPhoneInputField> createState() => _MiPhoneInputFieldState();
}

/// The type of country picker to show
enum CountryPickerType {
  /// Shows a dialog with the country picker
  dialog,

  /// Shows a bottom sheet with the country picker
  bottomSheet,

  /// Shows a cupertino bottom sheet with the country picker
  cupertinoBottomSheet
}

/// Position of an icon [leading, trailing]
enum IconPosition {
  leading,
  trailing,
}

class PhoneNumber {
  final String countryISOCode;
  final String countryCode;
  final String number;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
  });

  String get completeNumber => countryCode + number;
}

/// Custom style for picker dialog
class PickerDialogStyle {
  final Color? backgroundColor;
  final TextStyle? countryCodeStyle;
  final TextStyle? countryNameStyle;
  final Widget? listTileDivider;
  final EdgeInsetsGeometry? listTilePadding;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color? searchFieldCursorColor;
  final InputDecoration? searchFieldInputDecoration;
  final BoxDecoration? searchBoxDecoration;
  final EdgeInsetsGeometry? searchBoxPadding;

  const PickerDialogStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.borderRadius,
    this.borderSide,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchBoxDecoration,
    this.searchBoxPadding,
  });
}

class _MiPhoneInputFieldState extends State<MiPhoneInputField> {
  late CountryData _selectedCountry;
  late List<TextInputFormatter> _inputFormatters;
  late String _initialPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initializeInputFormatters();
    _initialPhoneNumber = widget.initialValue ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeCountry();

    if (_initialPhoneNumber.isNotEmpty && widget.textEditingController.text.isEmpty) {
      widget.textEditingController.text = _initialPhoneNumber;
    }
  }

  void _initializeCountry() {
    _selectedCountry = CountryPicker.getCountryData(
      context: context,
      code: widget.initialCountryCode,
    );
  }

  void _initializeInputFormatters() {
    _inputFormatters = widget.textInputFormatter ?? [];

    if (widget.phoneNumberAutoFormat) {
      _inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }
  }

  Future<void> _openCountryPicker() async {
    CountryData? selectedCountry;

    switch (widget.countryPickerType) {
      case CountryPickerType.dialog:
        selectedCountry = await CountryPicker.showCountryPickerDialog(
          context: context,
          layoutConfig: widget.countryPickerLayoutConfig,
          countryListConfig: widget.countryPickerListConfig,
          searchStyle: widget.countryPickerSearchStyle,
          favouriteCountries: widget.favouriteCountries,
          isDismissible: widget.countryPickerIsDismissible,
          backgroundColor: widget.countryPickerBackgroundColor,
          borderRadius: widget.countryPickerBorderRadius,
          showSearchBar: widget.countryPickerShowSearchBar,
          emptySearchBuilder: widget.countryPickerEmptySearchBuilder,
          onCountrySelect: _updateSelectedCountry,
        );
        break;

      case CountryPickerType.bottomSheet:
        selectedCountry = await CountryPicker.showCountryPickerBottomSheet(
          context: context,
          layoutConfig: widget.countryPickerLayoutConfig,
          countryListConfig: widget.countryPickerListConfig,
          searchStyle: widget.countryPickerSearchStyle,
          favouriteCountries: widget.favouriteCountries,
          isDismissible: widget.countryPickerIsDismissible,
          backgroundColor: widget.countryPickerBackgroundColor,
          showSearchBar: widget.countryPickerShowSearchBar,
          emptySearchBuilder: widget.countryPickerEmptySearchBuilder,
          onCountrySelect: _updateSelectedCountry,
        );
        break;

      case CountryPickerType.cupertinoBottomSheet:
        selectedCountry = await CountryPicker.showCountryPickerCupertinoBottomSheet(
          context: context,
          setInitialValue: _selectedCountry,
          layoutConfig: widget.countryPickerLayoutConfig,
          countryListConfig: widget.countryPickerListConfig,
          isDismissible: widget.countryPickerIsDismissible,
          backgroundColor: widget.countryPickerBackgroundColor,
          onCountryChanged: _updateSelectedCountry,
        );
        break;
    }

    if (selectedCountry != null) {
      setState(() {
        _selectedCountry = selectedCountry ?? _getDefaultCountry();
      });
    }
  }

  void _updateSelectedCountry(CountryData? country) {
    if (country == null) return;

    setState(() {
      _selectedCountry = country;
    });

    if (widget.onCountryChanged != null) {
      widget.onCountryChanged!(country);
    }
  }

  CountryData _getDefaultCountry() {
    return CountryData(
      name: "India",
      code: "IN",
      dialCode: "91",
      minLength: 10,
      maxLength: 10,
      flagUri: 'lib/assets/flags/in.png',
    );
  }

  FormFieldValidator<String>? _buildValidator() {
    if (widget.validator != null) {
      return widget.validator;
    }

    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a phone number';
      }

      if (widget.disableLengthCheck) {
        return null;
      }

      if (_selectedCountry.minLength != null &&
          _selectedCountry.maxLength != null &&
          (value.length < _selectedCountry.minLength! || value.length > _selectedCountry.maxLength!)) {
        return widget.invalidNumberMessage;
      }

      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formFieldKey,
      initialValue:
          (widget.textEditingController.text.isEmpty && widget.initialValue != null) ? _initialPhoneNumber : null,
      autofillHints: widget.disableAutoFillHints ? null : [AutofillHints.telephoneNumberNational],
      onTapOutside: widget.onTapOutside != null ? (_) => widget.onTapOutside!() : null,
      onTap: widget.onTap,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      showCursor: widget.showCursor,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      magnifierConfiguration: widget.magnifierConfiguration,
      decoration: InputDecoration(
        enabled: widget.enabled,
        errorMaxLines: widget.errorMaxLines,
        prefixIcon: _buildCountrySelector(context),
        filled: widget.filled,
        fillColor: widget.fillColor ?? Colors.white,
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(8.0),
        hintText: widget.hintText ?? 'Enter phone number',
        hintStyle: widget.hintTextStyle,
        errorStyle: widget.errorStyle ??
            Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
        suffixIcon: widget.suffixIcon,
        suffixIconConstraints: widget.suffixIconConstraints,
        suffixText: widget.suffixText,
        suffixStyle: widget.suffixTextStyle,
        counterText: widget.counterText ?? (widget.enabled ? null : ''),
        border: _buildBorder(),
        focusedBorder: _buildBorder(),
        enabledBorder: _buildBorder(),
        errorBorder: _buildBorder(isError: true),
        focusedErrorBorder: _buildBorder(isError: true),
      ),
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      inputFormatters: _inputFormatters,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChange,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved != null
          ? (value) {
              widget.onSaved!(
                PhoneNumber(
                  countryISOCode: _selectedCountry.code ?? '',
                  countryCode: '+${_selectedCountry.dialCode}',
                  number: value ?? '',
                ),
              );
            }
          : null,
      readOnly: widget.readOnly,
      validator: _buildValidator(),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.disableLengthCheck ? null : (_selectedCountry.maxLength ?? widget.maxLength),
      buildCounter: (_, {int? currentLength, int? maxLength, bool? isFocused}) => null,
      autofocus: widget.autoFocus,
      autocorrect: widget.autoCorrect,
      enabled: widget.enabled,
      keyboardAppearance: widget.keyboardAppearance,
      autovalidateMode: widget.autovalidateMode,
    );
  }

  OutlineInputBorder _buildBorder({bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        width: widget.borderWidth,
        color: isError
            ? widget.errorBorderColor ?? Theme.of(context).colorScheme.error
            : widget.borderColor ?? const Color(0xFFD0D5DD),
      ),
    );
  }

  Widget _buildCountrySelector(BuildContext context) {
    return InkWell(
      onTap: widget.enabled && !widget.readOnly ? _openCountryPicker : null,
      child: Container(
        decoration: BoxDecoration(
          color: widget.countryPickerBackgroundColor ?? Colors.transparent,
          border: Border(
              right: BorderSide(
            width: widget.borderWidth,
            color: widget.borderColor ?? const Color(0xFFD0D5DD),
          )),
        ),
        margin: widget.countrySelectorMargin ?? const EdgeInsets.symmetric(horizontal: 8.0),
        padding: widget.countrySelectorPadding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.leading) ...[
              widget.dropdownIcon,
              const SizedBox(width: 4),
            ],
            if (widget.showCountryFlag) ...[
              ClipRRect(
                borderRadius: widget.countryFlagBorderRadius ?? BorderRadius.zero,
                child: Image.asset(
                  _selectedCountry.flagUri ?? 'lib/assets/flags/${_selectedCountry.code?.toLowerCase()}.png',
                  package: 'mi_country_picker',
                  width: widget.countryFlagWidth,
                  height: widget.countryFlagHeight,
                ),
              ),
              const SizedBox(width: 4),
            ],
            if (widget.showCountryCode) ...[
              Text(
                '+${_selectedCountry.dialCode}',
                style: widget.countryCodeTextStyle ?? widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 4),
            ],
            if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.trailing) ...[
              widget.dropdownIcon,
              const SizedBox(width: 4),
            ],
            const SizedBox(width: 8),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 8,
              endIndent: 8,
            ),
          ],
        ),
      ),
    );
  }
}
