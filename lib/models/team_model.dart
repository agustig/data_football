import 'package:data_football/models/models.dart';
import 'package:data_football/storage/storage.dart';

class FootballTeam {
  const FootballTeam({
    this.id,
    required this.name,
    required this.fullName,
    required this.ground,
    required this.logo,
    required this.website,
    required this.league,
  });

  final int? id;
  final String name;
  final String fullName;
  final String ground;
  final String logo;
  final String website;
  final League league;

  static Future<FootballTeam> oneFromDBWithId(int id) async {
    const sql = 'SELECT * FROM teams WHERE id = ?';
    final teams = await manyFromDB(sql, [id]);
    return teams[0];
  }

  static Future<List<FootballTeam>> manyFromDB([
    String sql = 'SELECT * FROM teams',
    List<Object?>? values,
  ]) async {
    final teams = <FootballTeam>[];
    for (var row in await getStorage(sql, values)) {
      final team = FootballTeam(
        id: row[0],
        name: row[1],
        fullName: row[2],
        ground: row[3],
        logo: row[4],
        website: row[5],
        league: await League.oneFromDBWithId(row[6]),
      );
      teams.add(team);
    }

    return teams;
  }
}
