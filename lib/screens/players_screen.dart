import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';

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
          // Add change state view function
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
          return isBoxView
              ? showPlayersGridView(snapshot.data!)
              : showPlayersListView(snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
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
                  image: loadImageProvider(player.image),
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

  Widget showPlayersGridView(List<Player> players) {
    return GridView.builder(
      padding: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: players.length,
      itemBuilder: (BuildContext context, index) {
        final player = players[index];
        return InkWell(
          onTap: () {
            // TODO: Add Navigation to player details
          },
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blueGrey,
                      offset: Offset(0.9, 1.9),
                      blurRadius: 50,
                      spreadRadius: 0.9,
                      blurStyle: BlurStyle.inner,
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.grey, Colors.blue.shade50],
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: loadImageProvider(player.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                player.name,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
