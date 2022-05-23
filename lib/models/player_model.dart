import 'package:intl/intl.dart';
import 'package:data_football/models/models.dart';
import 'package:data_football/storage/storage.dart';

class Player {
  const Player({
    this.id,
    required this.fullName,
    required this.nationality,
    required this.dateOfBirth,
    required this.birthCountry,
    required this.name,
    required this.jarseyNumber,
    required this.currentTeam,
    required this.lastTeam,
    required this.position,
    required this.image,
  });

  final int? id;
  final String fullName;
  final Country nationality;
  final DateTime dateOfBirth;
  final Country birthCountry;
  final String name;
  final int jarseyNumber;
  final FootballTeam currentTeam;
  final FootballTeam lastTeam;
  final String position;
  final String image;

  static Future<List<Player>> manyFromDB(
      [String? sql, List<Object?>? values]) async {
    final sqlString = sql ??
        'SELECT full_name, nationality, date_of_birth, birth_country,'
            ' name, jarsey_number, current_team, last_team, position, image FROM players';

    final players = <Player>[];
    for (var row in await getStorage(sqlString, values)) {
      final player = Player(
        fullName: row[0],
        nationality: await Country.getOneFromDBWithCode(row[1]),
        dateOfBirth:
            DateFormat('yyyy-MM-dd').parse(row[2].toString().split(" ")[0]),
        birthCountry: await Country.getOneFromDBWithCode(row[3]),
        name: row[4],
        jarseyNumber: row[5],
        currentTeam: await FootballTeam.oneFromDBWithId(row[6]),
        lastTeam: await FootballTeam.oneFromDBWithId(row[7]),
        position: row[8],
        image: row[9],
      );
      players.add(player);
    }

    return players;
  }
}
