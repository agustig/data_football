import 'package:data_football/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';

class TeamFormScreen extends StatefulWidget {
  const TeamFormScreen({
    Key? key,
    // required this.onSet,
    this.originalTeam,
  })  : isUpdating = (originalTeam != null),
        super(key: key);

  // final Function(FootballTeam) onSet;
  final FootballTeam? originalTeam;
  final bool isUpdating;

  @override
  State<TeamFormScreen> createState() => _TeamFormScreenState();
}

class _TeamFormScreenState extends State<TeamFormScreen> {
  final _nameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _groundController = TextEditingController();
  final _websiteController = TextEditingController();
  String? continentValue;
  int? leagueValue;

  Color currenColor = Colors.white;
  String name = '';
  String fullName = '';
  String ground = '';
  String? logo;
  String website = '';
  League? league;

  @override
  Widget build(BuildContext context) {
    final appBars = <AppBar>[
      AppBar(
        title: const Text('Update Details'),
      ),
      AppBar(
        title: const Text('Create New Team'),
      ),
    ];

    return Scaffold(
      appBar: widget.isUpdating ? appBars[0] : appBars[1],
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          showLogo(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      showName(),
                      showFullName(),
                      showGroundName(),
                      showWebsite(),
                      showLeague(),
                      const Divider(
                        color: Colors.black54,
                      ),
                      Text('${league?.name ?? "halo"}'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showLogo() {
    // final team = widget.originalTeam;
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        image: DecorationImage(image: loadImageProvider(imageSource: widget.originalTeam?.logo))
      ),
      child: Stack(
        children: [
          const Text('halo'),
        ],
      ),
    );
  }

  Widget showName() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Team Name',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        hintText: 'E.g. Madura United',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget showFullName() {
    return TextField(
      controller: _fullNameController,
      decoration: const InputDecoration(
        labelText: 'Team Full Name',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        hintText: 'E.g. Madura United Perkasa',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget showGroundName() {
    return TextField(
      controller: _groundController,
      decoration: const InputDecoration(
        labelText: 'Ground Name',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        hintText: 'E.g. Stadion Gelora Bangkalan',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget showWebsite() {
    return TextField(
      controller: _websiteController,
      decoration: const InputDecoration(
        labelText: 'Website',
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
        hintText: 'E.g. http://www.maduraunitedfc.com/',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget showLeague() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'League',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Container(
              // padding: EdgeInsets.only(left: 20),
              // margin: EdgeInsets.only(left: 20),
              height: 150,
              width: 150,
              child: loadImage(imageSource: league?.logo),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  showContinentDropdown(),
                  showLeagueDropdown(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showContinentDropdown() {
    return FutureBuilder(
      future: Country.getDistinctContinentFromDB(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Row(
            children: [
              DropdownButton<String>(
                hint: const Text('Filter with Continent'),
                value: continentValue,
                menuMaxHeight: double.infinity,
                items: snapshot.data!.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    continentValue = value;
                    resetValue();
                  });
                },
              ),
            ],
          );
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

  Widget showLeagueDropdown() {
    return FutureBuilder(
      future: League.getAllFormDBWithContinent(continentValue),
      builder: (context, AsyncSnapshot<List<League>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final leagues = snapshot.data!;
          final leaguesDropdown = leagues.map((league) {
            return DropdownMenuItem<int>(
              value: league.id,
              child: Text(league.name),
            );
          }).toList();
          leaguesDropdown.add(
            DropdownMenuItem<int>(
              value: -1,
              child: Row(
                children: const [
                  Icon(Icons.add_sharp),
                  Text('Add New League'),
                ],
              ),
            ),
          );
          return Row(
            children: [
              DropdownButton<int>(
                value: leagueValue,
                hint: const Text('Select League Name'),
                items: leaguesDropdown,
                onChanged: (value) {
                  if (value != -1) {
                    setState(() {
                      league = leagues
                          .where((element) => element.id == value)
                          .toList()[0];
                      leagueValue = value;
                    });
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LeagueFormScreen(),
                      ),
                    );
                  }
                },
              )
            ],
          );
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

  @override
  void initState() {
    // Implement initState
    super.initState();
    final team = widget.originalTeam;
    if (team != null) {
      name = team.name;
      _nameController.text = team.name;
      fullName = team.fullName;
      _fullNameController.text = team.fullName;
      ground = team.ground;
      _groundController.text = team.ground;
      logo = team.logo;
      website = team.website;
      _websiteController.text = team.website;
      continentValue = team.league.country.continentName;
      leagueValue = team.league.id;
      league = team.league;
    }

    // _nameController.addListener(() {
    //   setState(() {
    //     name = _nameController.text;
    //   });
    // });
  }

  void resetValue() {
    leagueValue = null;
    name = '';
    fullName = '';
    ground = '';
    logo = null;
    website = '';
    league = null;
  }
}
