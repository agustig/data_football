import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';
import 'package:data_football/screens/screens.dart';

class TeamDetails extends StatelessWidget {
  const TeamDetails({
    Key? key,
    required this.team,
  }) : super(key: key);
  final FootballTeam team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${team.name} Details'),
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TeamFormScreen(originalTeam: team),
                ),
              );
            }),
            icon: const Icon(Icons.edit_note),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            height: 400,
            width: 400,
            child: loadImage(imageSource: team.logo),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              team.fullName,
              style: Theme.of(context).textTheme.headlineSmall,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.visible,
              // textDirection: ,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          groundDetail(context),
                          leagueDetail(context),
                        ],
                      ),
                      const Divider(color: Colors.black54),
                      websiteDetail(context),
                      const Divider(color: Colors.black54),
                      const SizedBox(height: 40)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget groundDetail(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ground',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
          onPressed: null,
          child: Text(
            team.ground,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget leagueDetail(BuildContext context) {
    return Column(
      children: [
        Text(
          'League',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LeagueDetails(league: team.league),
              ),
            );
          },
          child: Text(
            team.league.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget websiteDetail(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              'Website',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(team: team),
                  ),
                );
              },
              child: Text(
                team.website,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
