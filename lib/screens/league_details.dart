import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';

class LeagueDetails extends StatelessWidget {
  const LeagueDetails({Key? key, required this.league}) : super(key: key);
  final League league;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${league.name} Details'),
      ),
      body: Center(
        child: Text(league.name),
      ),
    );
  }
}
