import 'package:data_football/models/models.dart';
import 'package:data_football/storage/storage.dart';

class League {
  const League({
    this.id,
    required this.name,
    required this.country,
    required this.numberOfTeams,
    required this.logo,
    required this.website,
  });

  final int? id;
  final String name;
  final Country country;
  final int numberOfTeams;
  final String logo;
  final String website;

  static Future<League> oneFromDBWithId(int id) async {
    const String sqlString =
        'SELECT id, name, country, number_of_team, logo, website '
        'FROM leagues WHERE id = ?';
    final leagues = await getAllFromDB(sqlString, [id]);
    return leagues[0];
  }

  static Future<List<League>> getAllFormDBWithContinent([String? value]) async {
    if (value == null) {
      return getAllFromDB();
    } else {
      const sqlString =
          'SELECT id, name, country, number_of_team, logo, website '
          'FROM leagues WHERE country = '
          'ANY (SELECT code FROM countries WHERE continent_name = ?)';

      return getAllFromDB(sqlString, [value]);
    }
  }

  static Future<List<League>> getAllFromDB([
    String? sql,
    List<Object?>? values,
  ]) async {
    final sqlString = sql ??
        'SELECT id, name, country, number_of_team, logo, website '
            'FROM leagues';
    final leagues = <League>[];
    for (var row in await getStorage(sqlString, values)) {
      final league = League(
        id: row[0],
        name: row[1],
        country: await Country.getOneFromDBWithCode(row[2]),
        numberOfTeams: row[3],
        logo: row[4],
        website: row[5],
      );
      leagues.add(league);
    }
    return leagues;
  }
}
