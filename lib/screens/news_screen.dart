import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Match Results',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 300,
            child: matchResults(),
          )
        ],
      ),
    );
  }

  /// [matchResults] shows list of Football Match Result
  Widget matchResults() {
    const scoreTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
    return FutureBuilder(
      future: Match.getLatestMatches(),
      builder: (BuildContext context, AsyncSnapshot<List<Match>> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: SizedBox(
                width: 360,
                child: Center(child: Text(snapshot.error.toString())),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final matches = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: matches.map((match) {
              final competition = match.competition;
              final home = match.homeTeam;
              final away = match.awayTeam;
              final score = match.score;
              final fullTimeScore = score['fullTime']! as Map<String, dynamic>;
              final halfTimeScore = score['halfTime']! as Map<String, dynamic>;
              return Card(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 360,
                  child: Column(
                    children: [
                      Text(
                        competition['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child:
                                        loadImage(imageSource: home['crest']),
                                  ),
                                  Text(
                                    home['name'],
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  fullTimeScore['home'].toString(),
                                  style: scoreTextStyle,
                                ),
                                const SizedBox(
                                  width: 20,
                                  child: Text(
                                    '-',
                                    textAlign: TextAlign.center,
                                    style: scoreTextStyle,
                                  ),
                                ),
                                Text(
                                  fullTimeScore['away'].toString(),
                                  style: scoreTextStyle,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child:
                                        loadImage(imageSource: away['crest']),
                                  ),
                                  Text(
                                    away['name'],
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        DateFormat.MMMMEEEEd().format(match.utcDate),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.amber[200],
                              child: Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Half Time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.amber[50],
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      halfTimeScore['home'].toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      halfTimeScore['away'].toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.amber[200],
                              child: Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Full Time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.amber[50],
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fullTimeScore['home'].toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      fullTimeScore['away'].toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
