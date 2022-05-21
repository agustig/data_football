import 'models.dart';
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
    required this.possition,
    required this.appearances,
    required this.goals,
    required this.image,
  });

  final int? id;
  final String fullName;
  final String nationality;
  final DateTime dateOfBirth;
  final Country birthCountry;
  final String name;
  final int jarseyNumber;
  final FootballTeam currentTeam;
  final FootballTeam lastTeam;
  final String possition;
  final int appearances;
  final int goals;
  final String image;

  // Future<Player>? oneFromDB(int id) async {
  //   return await
  // }
}
