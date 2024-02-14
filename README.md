# mi_country_picker

<a href="https://developer.android.com" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-android-blue">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Linux-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Mac-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-web-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Windows-blue">
</a>

A Flutter package for selecting country codes from a list. It offers multiple modes for the country code picker and supports the locale of the current device in 70 different languages.

## Overview
<img  src="https://github.com/Mindinventory/country_picker/blob/dev-manish/lib/assets/cupertino_bottom.gif"  width="250" height=500/> <img  src="https://github.com/Mindinventory/country_picker/blob/dev-manish/lib/assets/bottom.gif"  width="250" height=500/> 

<img  src="https://github.com/Mindinventory/country_picker/blob/dev-manish/lib/assets/dialog.gif"  width="250" height=500/>  <img  src="https://github.com/Mindinventory/country_picker/blob/dev-manish/lib/assets/dropdown.gif"  width="250" height=500/>
## localization support
<img  src="https://github.com/Mindinventory/country_picker/blob/dev-manish/lib/assets/localization_support.gif"  width="250" height=500 />
## Example
For Country picker dialog
```dart
final country= await CountryPicker.showCountryPickerDialog(context: context);
```
For Country picker bottom sheet
```dart
final country= await CountryPicker.showCountryPickerBottomSheet(context: context);
```

For Country picker cupertino bottom sheet
```dart
final country = await CountryPicker.showCountryPickerCupertinoBottomSheet(context: context);
```
For the Country picker dropdown
```dart
CountryPickerDropDown(
      onSelectValue: (CountryData value) {
        debugPrint('CountryPickerDropDown ::${value.name}');
      },
    );
```
get the initial country with `CountryPicker.getInitialValue`, by default, it takes `+91` code
```dart
CountryPicker.getInitialValue(context: context,initialCountryValue: "+1"); 
```

### For localization
Add the `CountryPickerLocalizations.delegate` to the list of your app delegates.
```dart
 return MaterialApp(
    supportedLocales: [
        Locale("hi"),
        Locale("tk"),
        Locale("uk"),
        ...
        ...
        ...
        Locale("zh")
      ],
      localizationsDelegates: [
        CountryPickerLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
```
----

### CountryPicker
The **`CountryPicker`** class encapsulates all functionalities of this package. Utilize these optional properties to customize the appearance and view of the picker according to your preferences.

|Fields|Type|Description
|:---:|:---:|:---|
| **context** | `BuildContext` | A handle to the location of a widget in the widget tree `Required`.|
|**favouriteCountries**|`List<String>?`| favouriteCountries will be placed on the top of list.|
|**barrierColor**| `Color?`|barrierColor that covers the screen behind a modal or overlay widget.
|**isDismissible**| `bool?` | isDismissible determines whether the widget can be dismissed or closed by tapping outside of it.
|**backgroundColor**| `Color?`| backgroundColor is a property to set the background color of the country picker widget.
|**useSafeArea**|`bool?`| useSafeArea is for visible/avoids overlapping with system UI elements.

**`LayoutConfig`** and **`SearchStyle`** models are used to configure the layout and styling of the interface.
|Fields|Type|Description
|:---:|:---:|:---|
|**textStyle**| `TextStyle?`| to set the Style for country list elements.
|**elementsSequence**| `Sequence`| To set the Sequence of countries elements by default it is `Sequence.codeCountryNameAndFlag`.
|**flagWidth**| `bool`| set width of the flag by default is 24.
|**flagHeight**| `bool`| set height of the flag by default is 18.
|**flagDecoration**| `Decoration?`| set decoration of the flag.
|**showCountryName**| `bool`| show/hide country name by default is true.
|**showCountryFlag**| `bool`| show/hide country flag by default it's true.
|**showCountryCode**| `bool`| show/hide country code by default it's true.
|**searchFieldInputDecoration**| `InputDecoration?`| to decorate or customize the country flag.
|**searchFieldInputDecoration**| `InputDecoration?`| to decorate or customize the country flag.
|**hintText**| `String?`| give the hint in searchBar.
|**searchBoxHeight**|`double?`| set the height of search bar.
|**searchBoxHeight**|`double?`| set the height of search bar.
|**searchBoxMargin**|`EdgeInsetsGeometry?`| set the margin of SearchBox.

**`CountryListConfig`** model is used to manipulate the country list.
|Fields|Type|Description
|:---:|:---:|:---|
|**countryFilter**|`List<String>?`| Provide the list of countries name/code/dialCode to show the list of countries in Country picker.
|**comparator**|`Comparator<CountryData>?`| comparator is used to change the order of country list.
|**excludeCountry**|`List<String>??`| remove particular countries from our list.

## Guideline for contributors
Contribution towards our repository is always welcome, we request contributors to create a pull request to the develop branch only.

## Guideline to report an issue/feature request
It would be great for us if the reporter could share the below things to understand the root cause of the issue.
- Library version
- Code snippet
- Logs if applicable
- Device specification like (Manufacturer, OS version, etc)
- Screenshot/video with steps to reproduce the issue

# LICENSE!
mi_country_picker is [MIT-licensed](https://git.mindinventory.com/miopensource/mi-country-picker/-/blob/dev-manish/LICENSE).

# Let us know!

We’d be really happy if you send us links to your projects where you use our component. Just send an email to sales@mindinventory.com And do let us know if you have any questions or suggestions regarding our work.
