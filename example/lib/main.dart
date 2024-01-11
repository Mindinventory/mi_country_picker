import 'package:country_picker/country_picker.dart';
import 'package:example/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Dimension dimension = Dimension(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width);

    return ScreenUtilInit(
        designSize: const Size(1900, 1900),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
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
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CountryPikersDialog(
                      showCircularFlag: true,
                      favorite: const ['+91', '+376'], // set your favorite country
                      countryPickerThemeData:
                          const CountryPickerThemeData(), // with this property ,set background clr of dialog, textStyle of of country name, decorate the search field, set flag size....
                      comparator: (a, b) {
                        /// show country list with Alphabetic order.
                        return a.name!.compareTo(b.name.toString());
                      },
                      emptySearchBuilder: (context) {
                        /// if country not found when searching in search box , then show your widget...
                        return const Center(child: Text('not found'));
                      },
                    ),
                  ],
                )
                // body: Center(
                //   child: Container(
                //     color: Colors.red,
                //     width: MediaQuery.sizeOf(context).width,
                //     child: Row(
                //       children: [
                //         Container(
                //           width: 500.w,
                //           height: 100,
                //           color: Colors.red,
                //         ),
                //         Container(
                //           width: 100.w,
                //           height: 100.w,
                //           color: Colors.red,
                //         ),
                //         Container(
                //           width: 500.w,
                //           height: 100,
                //           color: Colors.black,
                //         ),
                //       ],
                //     )
                //     ,
                //   ),
                // ),
                ),
          );
        });
  }
}
