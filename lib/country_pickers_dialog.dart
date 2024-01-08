import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/country_code.dart';
import 'package:country_picker/src/country_selection_dialog.dart';
import 'package:flutter/material.dart';

class CountryPikersDialog extends StatefulWidget {
  /// it is optional argument to set your own custom country list
  final List<Map<String, String>>? listOfCountries;

  /// using this comparator to change the order of options.
  final Comparator<CountryCode>? comparator;
  final List<String>? countryFilter;

  const CountryPikersDialog({super.key, this.listOfCountries = codes, this.countryFilter, this.comparator});

  @override
  // ignore: no_logic_in_create_state
  State<CountryPikersDialog> createState() {
    List<CountryCode>? countriesElements = listOfCountries?.map((element) => CountryCode.fromJson(element)).toList();

    if (comparator != null) {
      countriesElements?.sort(comparator);
    }

    if (countryFilter != null && countryFilter!.isNotEmpty) {
      final uppercaseFilterElement = countryFilter?.map((e) => e.toUpperCase()).toList();
      countriesElements = countriesElements
          ?.where((element) =>
              uppercaseFilterElement!.contains(element.name) ||
              uppercaseFilterElement.contains(element.dialCode) ||
              uppercaseFilterElement.contains(element.code))
          .toList();
    }

    return _CountryPikersDialogState();
  }
}

class _CountryPikersDialogState extends State<CountryPikersDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCountryPickerDialog(context);
      },
      child: const Text("onTap"),
    );
  }

  Future<void> showCountryPickerDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: Dialog(
            child: CountrySelectionDialog(),
          ),
        );
      },
    );
  }
}
