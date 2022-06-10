import 'package:intl/intl.dart';
import 'package:data_football/models/models.dart';

class Match {
  Match({
    required this.utcDate,
    required this.matchday,
    required this.competition,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
  });

  final DateTime utcDate;
  final int matchday;

  /// [competition] will store map data from api like this:
  /// {
  ///   "id": 2013,
  ///   "name": "Campeonato Brasileiro Série A",
  ///   "code": "BSA",
  ///   "type": "LEAGUE",
  ///   "emblem": "https://crests.football-data.org/764.svg"
  /// },
  final Map<String, dynamic> competition;

  /// [homeTeam] will store map data from api like this:
  /// {
  ///   "id": 1838,
  ///   "name": "América FC",
  ///   "shortName": "América (MG)",
  ///   "tla": "AMÉ",
  ///   "crest": "https://crests.football-data.org/1838.png"
  /// },
  final Map<String, dynamic> homeTeam;

  /// [awayTeam] will store map data from api like this (like as homeTeam):
  /// {
  ///   "id": 1838,
  ///   "name": "América FC",
  ///   "shortName": "América (MG)",
  ///   "tla": "AMÉ",
  ///   "crest": "https://crests.football-data.org/1838.png"
  /// },
  final Map<String, dynamic> awayTeam;

  /// [score] will store map data from api like this:
  /// {
  ///   "winner": "HOME_TEAM",
  ///   "duration": "REGULAR",
  ///   "fullTime": {"home": 2, "away": 1},
  ///   "halfTime": {"home": 1, "away": 1}
  /// },
  final Map<String, dynamic> score;

  /// [Match.fromJson] can import the match result data from json
  /// and return to Match object.
  factory Match.fromJson(Map<String, dynamic> jsonMap) {
    return Match(
      utcDate: DateFormat('yyyy-MM-ddTHH:mm:ssZ')
          .parse(jsonMap['utcDate'] as String),
      matchday: jsonMap['matchday'] as int,
      competition: jsonMap['competition'] as Map<String, dynamic>,
      homeTeam: jsonMap['homeTeam'] as Map<String, dynamic>,
      awayTeam: jsonMap['awayTeam'] as Map<String, dynamic>,
      score: jsonMap['score'] as Map<String, dynamic>,
    );
  }

  /// [getLatestMatches] gets lot matches data from APIs
  /// and reformat into List of Match object
  static Future<List<Match>> getLatestMatches() async {
    final availabeCompetitions = <String>[];
    try {
      // Get all league data from Database
      final leagues = await League.getAllFromDB();

      // Get all competitions data from api
      final getCompetitions = await footballDataApis(
        endPoint: 'competitions',
      );
      final competitions = getCompetitions['competitions'];

      // Filter and combine league and competitions to one array

      for (var competition in competitions) {
        for (var league in leagues) {
          if (competition['name'] == league.name) {
            availabeCompetitions.add(competition['code']!);
          }
        }
      }
    } catch (error) {
      return Future.error(error.toString());
    }

    // Declare and initiate variabel for filter result
    final dateToday = DateTime.now();
    final dateYesterday = dateToday.subtract(const Duration(days: 7));

    final lastMatches = <Match>[];
    final jsonMatches = await footballDataApis(
      endPoint: 'matches/',
      filters: {
        'dateFrom': DateFormat('yyyy-MM-dd').format(dateYesterday),
        'dateTo': DateFormat('yyyy-MM-dd').format(dateToday),
        'status': 'FINISHED',
        'competitions': availabeCompetitions.join(','),
      },
    );
    for (var jsonMatch in jsonMatches['matches']) {
      final math = Match.fromJson(jsonMatch);
      lastMatches.add(math);
    }
    return lastMatches;
  }
}
