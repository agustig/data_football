import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';
import 'package:data_football/screens/screens.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({
    Key? key,
    required this.team,
  }) : super(key: key);
  final FootballTeam team;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  late FootballTeam _team;
  late League _league;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_team.name} Details'),
        actions: [
          IconButton(
            onPressed: () async {
              final FootballTeam? updatedTeam =
                  await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TeamFormScreen(
                    originalTeam: _team,
                  ),
                ),
              );

              if (updatedTeam != null) {
                setState(() {
                  _team = updatedTeam;
                });
              }
            },
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
            child: loadImage(imageSource: _team.logo),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _team.fullName,
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
            _team.ground,
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
            showDialog(
              context: context,
              builder: (context) {
                // var league = _team.league;
                return AlertDialog(
                  content: LeagueDetails(league: _league),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        final League? updatedLeague =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LeagueFormScreen(
                              league: _league,
                            ),
                          ),
                        );

                        if (updatedLeague != null) {
                          setState(() {
                            _league = updatedLeague;
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Text(
            _league.name,
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
                    builder: (context) => WebViewScreen(
                      model: _team,
                    ),
                  ),
                );
              },
              child: Text(
                _team.website,
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

  @override
  void initState() {
    super.initState();

    // Get team detail from parent class
    _team = widget.team;
    _league = _team.league;
  }
}
