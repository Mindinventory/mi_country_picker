import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale("af"),
        Locale("am"),
        Locale("ar"),
        Locale("az"),
        Locale("be"),
        Locale("bg"),
        Locale("bn"),
        Locale("bs"),
        Locale("ca"),
        Locale("cs"),
        Locale("da"),
        Locale("de"),
        Locale("el"),
        Locale("en"),
        Locale("es"),
        Locale("et"),
        Locale("fa"),
        Locale("fi"),
        Locale("fr"),
        Locale("gl"),
        Locale("ha"),
        Locale("he"),
        Locale("hi"),
        Locale("hr"),
        Locale("hu"),
        Locale("hy"),
        Locale("id"),
        Locale("is"),
        Locale("it"),
        Locale("ja"),
        Locale("ka"),
        Locale("kk"),
        Locale("km"),
        Locale("ko"),
        Locale("ku"),
        Locale("ky"),
        Locale("lt"),
        Locale("lv"),
        Locale("mk"),
        Locale("ml"),
        Locale("mn"),
        Locale("ms"),
        Locale("nb"),
        Locale("nl"),
        Locale("nn"),
        Locale("no"),
        Locale("pl"),
        Locale("ps"),
        Locale("pt"),
        Locale("ro"),
        Locale("ru"),
        Locale("sd"),
        Locale("sk"),
        Locale("sl"),
        Locale("so"),
        Locale("sq"),
        Locale("sr"),
        Locale("sv"),
        Locale("ta"),
        Locale("tg"),
        Locale("th"),
        Locale("tk"),
        Locale("tr"),
        Locale("tt"),
        Locale("uk"),
        Locale("ug"),
        Locale("ur"),
        Locale("uz"),
        Locale("vi"),
        Locale("zh")
      ],
      localizationsDelegates: [
        CountryPickerLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country Picker'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('1. Country Picker using Dialog.'),
              Center(
                child: CountryPickerDialog(
                  onSelectValue: (value) {
                    debugPrint('CountryPickerDialog ${value.name}');
                  },
                  emptySearchBuilder: (context) {
                    // if country not found when searching in search box , then show your widget...
                    return const Center(
                      child: Text('not found'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Text('2. Country Picker using cupertino picker with bottom sheet.'),
              Center(
                child: CountryPickerCupertinoBottomSheet(
                  layoutConfig: const LayoutConfig(elementsSequence: Sequence.flagCodeAndCountryName),
                  onSelectValue: (value) {
                    debugPrint('CountryPickerBottomSheet  ${value.name}');
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Text('3. Country Picker using Drop down.'),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CountryPickerDropDown(
                    layoutConfig: const LayoutConfig(showCountryName: false),
                    onSelectValue: (value) {
                      debugPrint('CountryPickerDropDown ${value.name}');
                    },
                    onTap: () {},
                    iconDisabledColor: Colors.blue,
                    underline: const SizedBox.shrink(),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text('4. Country Picker using Bottom sheet.'),
              Center(
                child: CountryPickerBottomSheet(
                  onSelectValue: (value) {
                    debugPrint('CountryPickerBottomSheet::>>>>${value.name}');
                  },
                  layoutConfig: const LayoutConfig(
                    showCountryFlag: true,
                    showCountryName: true,
                    showCountryCode: true,
                    elementsSequence: Sequence.flagCodeAndCountryName,
                    isDismissible: false,
                  ),
                  countryListConfig: CountryListConfig(
                    selectInitialCountry: "+244",
                    excludeCountry: ["+91", '+1264'],
                    favorite: ["+91", "+1264"],
                    comparator: (a, b) {
                      return a.name!.compareTo(b.name.toString());
                    },
                  ),
                  // showDragHandle: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
