import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';
import 'package:data_football/screens/screens.dart';

class PlayerDetails extends StatelessWidget {
  const PlayerDetails({Key? key, required this.player}) : super(key: key);
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add navigation to edit page
            },
            icon: const Icon(Icons.edit_note),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          backgroundBlendMode: BlendMode.hardLight,
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: loadImageProvider(player.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            showDetailRow('Full Name', player.fullName),
            showDetailRow(
                'Date of Birth',
                '${DateFormat.yMMMMd().format(player.dateOfBirth)} '
                    '(Age: ${calculateAge(player.dateOfBirth)})'),
            showDetailRow('Birth Country', player.birthCountry.name),
            showDetailSection('Team Information'),
            showDetailRow(
              'Current Team',
              player.currentTeam.name,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeamDetails(team: player.currentTeam),
                  ),
                );
              },
            ),
            showDetailRow('Jarsey Number', player.jarseyNumber.toString()),
            showDetailRow('Position', player.position),
            showDetailRow(
              'Last Team',
              player.lastTeam.name,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeamDetails(team: player.lastTeam),
                  ),
                );
              },
            ),
            showDetailSection('Nationality'),
            showDetailRow('Team County', player.nationality.name),
          ],
        ),
      ),
    );
  }

  Widget showDetailSection(String section) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 2,
            bottom: 2,
          ),
          margin: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
          ),
          child: Text(
            section,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget showDetailRow(String label, String value,
      {void Function()? onTap}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$label:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: (onTap != null)
                  ? InkWell(
                      onTap: () {
                        onTap();
                      },
                      child: Text(
                        value,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
