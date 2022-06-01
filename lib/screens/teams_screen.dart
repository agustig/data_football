import 'package:flutter/material.dart';
import 'package:data_football/screens/screens.dart';
import 'package:data_football/models/models.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showFutureTeams(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => const TeamFormScreen(),
              ))
              .then((value) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget showFutureTeams() {
    return FutureBuilder(
      future: FootballTeam.manyFromDB(),
      builder: (context, AsyncSnapshot<List<FootballTeam>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var teams = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                            builder: (context) => TeamDetails(team: team),
                          ))
                          .then((value) => setState(() {}));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: loadImage(imageSource: team.logo),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          team.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
