import 'package:data_football/models/models.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isBoxView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showFuturePlayers(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add change state view function
          setState(() {
            isBoxView = !isBoxView;
          });
        },
        child: Icon(isBoxView ? Icons.list : Icons.grid_view),
      ),
    );
  }

  Widget showFuturePlayers() {
    return FutureBuilder(
      future: Player.manyFromDB(),
      builder: (context, AsyncSnapshot<List<Player>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return showPlayersListView(snapshot.data!);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget showPlayersListView(List<Player> players) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return ListTile(
          onTap: () {
            // TODO: Add player profile page
          },
          contentPadding: const EdgeInsets.all(8),
          leading: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: loadImageProvider(imageSource: player.image),
                  fit: BoxFit.fitWidth),
            ),
          ),
          title: Text(player.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Age: ${calculateAge(player.dateOfBirth)}'),
              Text('Team: ${player.currentTeam.name}'),
              Text('Position: ${player.position}'),
            ],
          ),
        );
      },
    );
  }
}
