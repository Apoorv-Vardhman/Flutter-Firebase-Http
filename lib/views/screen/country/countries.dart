import 'package:flutter/material.dart';
import 'package:mvvm_angela/app/app_routes.dart';
import 'package:mvvm_angela/views/resource/app_color.dart';
import 'package:mvvm_angela/views/screen/login/widget/countrypicker/countries.dart';
import 'package:mvvm_angela/views/screen/login/widget/countrypicker/country.dart';
import 'package:mvvm_angela/views/screen/login/widget/countrypicker/utils/utils.dart';

class CountriesPage extends StatefulWidget {
  ///It should be one of the ISO ALPHA-2 Code that is provided
  ///in countryList map of countries.dart file.
  final String? initialValue;

  const CountriesPage({Key? key, this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CountriesState();
}

class CountriesState extends State<CountriesPage> {
  late List<Country> _countries;
  Country? _selectedCountry;

  @override
  void initState() {
    _countries = countryList.toList();
    if (widget.initialValue != null) {
      try {
        _selectedCountry = _countries.firstWhere(
          (country) => country.isoCode == widget.initialValue!.toUpperCase(),
        );
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _buildCountriesList();

  Widget _buildCountriesList() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 1);
          },
          itemCount: _countries.length,
          itemBuilder: (context, index) {
            final item = _countries[index];
            final isSelected = _selectedCountry == item;
            return Ink(
              color: isSelected ? AppColors.primary_blue : AppColors.white,
              child: ListTile(
                title: buildRow(item, isSelected),
                onTap: () {
//                  widget.onValuePicked(item);
                  AppRoutes.popWithData(context, item);
                },
              ),
            );
          },
        ));
  }

  Widget buildRow(Country country, bool isSelected) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
            child: Text(
          "+${country.phoneCode} ${country.name}",
          style: TextStyle(color: isSelected ? AppColors.white : null),
        )),
      ],
    );
  }
}
