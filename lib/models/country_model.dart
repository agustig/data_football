import 'package:data_football/storage/storage.dart';

class Country {
  const Country({
    required this.code,
    required this.name,
    required this.continentName,
  });

  final String code;
  final String name;
  final String continentName;

  static Future<Country> getOneFromDBWithCode(String code) async {
    const sql =
        'SELECT code, name, continent_name FROM countries WHERE code = ?';
    final countries = await getAllFromDB(sql, [code]);

    return countries[0];
  }

  static Future<List<String>> getDistinctContinentFromDB() async {
    const sql = 'SELECT DISTINCT continent_name FROM countries';
    final continents = <String>[];
    for (var row in await getStorage(sql)) {
      continents.add(row[0]);
    }

    return continents;
  }

  static Future<List<Country>> getAllFromDB(
      [String? sql, List<Object?>? values]) async {
    final sqlString = sql ?? 'SELECT code, name, continent_name FROM countries';
    final countries = <Country>[];
    for (var row in await getStorage(sqlString, values)) {
      final country = Country(
        code: row[0],
        name: row[1],
        continentName: row[2],
      );
      countries.add(country);
    }

    return countries;
  }
}
