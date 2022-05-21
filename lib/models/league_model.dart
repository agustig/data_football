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
    const String sql = 'SELECT * FROM leagues WHERE id = ?';
    final leagues = await getAllFromDB(sql, [id]);
    return leagues[0];
  }

  static Future<List<League>> getAllFormDBWithContinent([String? value]) async {
    if (value == null) {
      return getAllFromDB();
    } else {
      const sql =
          'SELECT * FROM leagues WHERE country = '
          'ANY (SELECT code FROM countries WHERE continent_name = ?)';

      return getAllFromDB(sql, [value]);
    }
  }

  static Future<List<League>> getAllFromDB([
    String sql = 'SELECT * FROM leagues',
    List<Object?>? values,
  ]) async {
    final leagues = <League>[];
    for (var row in await getStorage(sql, values)) {
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
