import 'package:data_football/models/models.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showFutureCountries();
  }
}

showFutureCountries() {
  return FutureBuilder(
    future: Country.getAllFromDB('SELECT * FROM `countries`'),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text(snapshot.error.toString());
    }

    var countries = snapshot.data as List<Country>;
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return ListTile(
          leading: Text(country.code),
          title: Text(country.name),
          subtitle: Text(country.continentName),
        );
      });
  });
}