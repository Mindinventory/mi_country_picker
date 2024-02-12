import 'package:mi_country_picker/mi_country_picker.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          dividerColor: Colors.transparent,
          cardTheme: const CardTheme(color: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(textStyle: const TextStyle(color: Colors.black)))),
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
  CountryData? initialDialogDefaultValue;
  CountryData? initialDialogCustomValue;
  CountryData? initialBottomDefaultValue;
  CountryData? initialBottomCustomValue;
  CountryData? initialCupertinoBottomDefaultValue;
  CountryData? initialCupertinoBottomCustomValue;

  @override
  void didChangeDependencies() {
    initialDialogDefaultValue = CountryPicker.getInitialValue(context: context);
    initialDialogCustomValue = CountryPicker.getInitialValue(context: context, initialCountryValue: "+213");
    initialBottomDefaultValue = CountryPicker.getInitialValue(context: context);
    initialBottomCustomValue = CountryPicker.getInitialValue(context: context, initialCountryValue: "+61");
    initialCupertinoBottomDefaultValue = CountryPicker.getInitialValue(
      context: context,
    );
    initialCupertinoBottomCustomValue = CountryPicker.getInitialValue(context: context, initialCountryValue: "+44");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Country Picker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              Card(
                child: ExpansionTile(
                  expandedCrossAxisAlignment: CrossAxisAlignment.center,
                  collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  initiallyExpanded: true,
                  title: Text(
                    'Country picker using dialog',
                    style: _defaultTextStyle,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 5),
                            child: Column(
                              children: [
                                const Text(
                                  "Default",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    CountryPicker.showCountryPickerDialog(
                                      context: context,
                                      layoutConfig: const LayoutConfig(elementsSequence: Sequence.flagCodeAndCountryName),
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          initialDialogDefaultValue = value;
                                          debugPrint('showCountryPickerDialog default ::${initialDialogDefaultValue?.name}');
                                          setState(() {});
                                        }
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        width: 24,
                                        height: 18,
                                        initialDialogDefaultValue?.flagUri ?? "",
                                        package: "mi_country_picker",
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${initialDialogDefaultValue?.dialCode ?? ""} ${initialDialogDefaultValue?.name ?? ""}",
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 5),
                              child: Column(
                                children: [
                                  const Text(
                                    "Custom",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      CountryPicker.showCountryPickerDialog(
                                        size: const Size(250, 550),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        context: context,
                                        favouriteCountries: ["+91", "+355"],
                                        layoutConfig: const LayoutConfig(
                                            flagWidth: 24,
                                            flagHeight: 24,
                                            elementsSequence: Sequence.codeCountryNameAndFlag,
                                            flagDecoration: BoxDecoration(shape: BoxShape.circle)),
                                      ).then(
                                        (value) {
                                          if (value != null) {
                                            initialDialogCustomValue = value;
                                            debugPrint('showCountryPickerDialog custom ::${initialDialogCustomValue?.name}');
                                            setState(() {});
                                          }
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          width: 24,
                                          height: 18,
                                          initialDialogCustomValue?.flagUri ?? "",
                                          package: "mi_country_picker",
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${initialDialogCustomValue?.dialCode ?? ""} ${initialDialogCustomValue?.name ?? ""}",
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Text(
                    'Country picker using bottom sheet',
                    style: _defaultTextStyle,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 5),
                            child: Column(
                              children: [
                                const Text(
                                  "Default",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                ElevatedButton(
                                  onPressed: () => CountryPicker.showCountryPickerBottom(
                                    layoutConfig: const LayoutConfig(elementsSequence: Sequence.flagCodeAndCountryName),
                                    context: context,
                                  ).then((value) {
                                    if (value != null) {
                                      initialBottomDefaultValue = value;
                                      debugPrint('showCountryPickerBottom :: ${initialBottomDefaultValue?.name}');
                                      setState(() {});
                                    }
                                  }),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        width: 24,
                                        height: 18,
                                        initialBottomDefaultValue?.flagUri ?? "",
                                        package: "mi_country_picker",
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${initialBottomDefaultValue?.dialCode ?? ""} ${initialBottomDefaultValue?.name ?? ""}",
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 10),
                              child: Column(
                                children: [
                                  const Text(
                                    "Custom",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => CountryPicker.showCountryPickerBottom(
                                      countryListConfig: CountryListConfig(),
                                      showDragHandle: true,
                                      context: context,
                                      favouriteCountries: ["+91", "+376"],
                                      layoutConfig: const LayoutConfig(
                                        flagWidth: 24,
                                        flagHeight: 24,
                                        elementsSequence: Sequence.codeCountryNameAndFlag,
                                        flagDecoration: BoxDecoration(shape: BoxShape.circle),
                                      ),
                                    ).then((value) {
                                      if (value != null) {
                                        initialBottomCustomValue = value;
                                        debugPrint('showCountryPickerBottom :: ${initialBottomCustomValue?.name}');
                                        setState(() {});
                                      }
                                    }),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          width: 24,
                                          height: 18,
                                          initialBottomCustomValue?.flagUri ?? "",
                                          package: "mi_country_picker",
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${initialBottomCustomValue?.dialCode ?? ""} ${initialBottomCustomValue?.name ?? ""}",
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Text(
                    'Country picker using cupertino bottom sheet',
                    style: _defaultTextStyle,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 5),
                            child: Column(
                              children: [
                                const Text(
                                  "Default",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    CountryPicker.showCountryPickerCupertinoBottom(
                                      setInitialValue: initialCupertinoBottomDefaultValue,
                                      context: context,
                                      layoutConfig: const LayoutConfig(elementsSequence: Sequence.flagCodeAndCountryName),
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          initialCupertinoBottomDefaultValue = value;
                                          debugPrint(
                                              'showCountryPickerCupertinoBottom :: ${initialCupertinoBottomDefaultValue?.name ?? ""}');
                                          setState(() {});
                                        }
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        width: 24,
                                        height: 18,
                                        initialCupertinoBottomDefaultValue?.flagUri ?? "",
                                        package: "mi_country_picker",
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${initialCupertinoBottomDefaultValue?.dialCode ?? ""} ${initialCupertinoBottomDefaultValue?.name ?? ""}",
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 5),
                              child: Column(
                                children: [
                                  const Text(
                                    "Custom",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      CountryPicker.showCountryPickerCupertinoBottom(
                                        setInitialValue: initialCupertinoBottomCustomValue,
                                        isScrollControlled: true,
                                        context: context,
                                        diameterRatio: 0.8,
                                        layoutConfig: const LayoutConfig(
                                          flagWidth: 24,
                                          flagHeight: 24,
                                          elementsSequence: Sequence.codeCountryNameAndFlag,
                                          flagDecoration: BoxDecoration(shape: BoxShape.circle),
                                        ),
                                      ).then(
                                        (value) {
                                          if (value != null) {
                                            initialCupertinoBottomCustomValue = value;
                                            debugPrint(
                                                'showCountryPickerCupertinoBottom :: ${initialCupertinoBottomCustomValue?.name ?? ""}');
                                            setState(() {});
                                          }
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          width: 24,
                                          height: 18,
                                          initialCupertinoBottomCustomValue?.flagUri ?? "",
                                          package: "mi_country_picker",
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${initialCupertinoBottomCustomValue?.dialCode ?? ""} ${initialCupertinoBottomCustomValue?.name ?? ""}",
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Card(
                child: ExpansionTile(
                  title: Text('Country picker using drop down', style: _defaultTextStyle),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: CountryPickerDropDown(
                          underline: const SizedBox.shrink(),
                          layoutConfig: const LayoutConfig(
                            showCountryName: false,
                            showCountryCode: true,
                            showCountryFlag: true,
                            flagDecoration: BoxDecoration(shape: BoxShape.circle),
                            flagWidth: 18,
                            flagHeight: 18,
                            // textStyle: TextStyle(fontSize: 12, color: Colors.black),
                            elementsSequence: Sequence.flagCodeAndCountryName,
                          ),
                          onSelectValue: (CountryData value) {
                            debugPrint('CountryPickerDropDown ::${value.name}');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
