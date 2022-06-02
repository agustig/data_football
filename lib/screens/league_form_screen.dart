import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';

class LeagueFormScreen extends StatelessWidget {
  const LeagueFormScreen({Key? key, this.league}) : super(key: key);
  final League? league;

  @override
  Widget build(BuildContext context) {
    // TODO: Add League Form Screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello'),
      ),
      body: const Center(
        child: Text('LeagueFormScreen'),
      ),
    );
  }
}
