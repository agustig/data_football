import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';
import 'package:data_football/screens/screens.dart';

class LeagueDetails extends StatelessWidget {
  const LeagueDetails({Key? key, required this.league}) : super(key: key);
  final League league;

  @override
  Widget build(BuildContext context) {
    // League detail
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: loadImageProvider(league.logo),
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        const SizedBox(height: 20),
        showLeagueDetails('Name', league.name),
        showLeagueDetails('Teams', league.numberOfTeams.toString()),
        showLeagueDetails('Country', league.country.name),
        showLeagueDetails('Confederation', league.country.continentName),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        model: league,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Visit Site',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget showLeagueDetails(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    );
  }
}
