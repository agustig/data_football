import 'package:flutter/material.dart';
import 'package:data_football/screens/screens.dart';
import 'package:data_football/models/models.dart';

class TeamFormScreen extends StatefulWidget {
  const TeamFormScreen({
    Key? key,
    this.originalTeam,
  })  : isUpdating = (originalTeam != null),
        super(key: key);

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
  int? id;
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
            padding: const EdgeInsets.all(20),
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
                      const SizedBox(height: 20),
                      saveButton(),
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
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            image: loadImageProvider(logo),
            fit: BoxFit.scaleDown,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              child: InkWell(
                onTap: () {
                  // Call upload image page
                  getUploadImageForm(context);
                },
                child: Container(
                  width: 180,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    color: Colors.black87,
                  ),
                  child: Center(
                    child: Text(
                      (logo != null) ? "Change Image" : "Add Image",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  showContinentDropdown(),
                  showLeagueDropdown(),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: loadImage(imageSource: league?.logo),
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
          return DropdownButton<String>(
            hint: const Text('Filter with Continent'),
            value: continentValue,
            items: snapshot.data!.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (value) {
              setState(() {
                continentValue = value;
                resetLeagueValue();
              });
            },
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
          return DropdownButton<int>(
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
                Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => const LeagueFormScreen(),
                    ))
                    .then((value) => setState(() {}));
              }
            },
          );
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }

  Widget saveButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Collect all Team data to Save
              final footballTeam = FootballTeam(
                id: id,
                name: _nameController.text,
                fullName: _fullNameController.text,
                ground: _groundController.text,
                logo: logo!,
                website: _websiteController.text,
                league: league!,
              );

              // Save new Team detail to Storage
              footballTeam.saveToDB().then((value) {
                // Check callback value thats returns auto increment id
                // from Database for new added data, and 0 for update old data
                if (value == 0) {
                  // Back to previous page with edited team value
                  Navigator.pop(context, footballTeam);
                } else {
                  // Back to previous page
                  Navigator.pop(context);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline6,
            ),
            child: const Text('Save'),
          ),
        )
      ],
    );
  }

  Future<void> getUploadImageForm(BuildContext context) async {
    final String? logoSource = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageUploadForm(
          imageSource: logo,
        ),
      ),
    );

    if (!mounted) return;
    setState(() {
      logo = logoSource ?? logo;
    });
  }

  @override
  void initState() {
    // Implement initState
    super.initState();
    final team = widget.originalTeam;
    if (team != null) {
      _nameController.text = team.name;
      _fullNameController.text = team.fullName;
      _groundController.text = team.ground;
      _websiteController.text = team.website;
      id = team.id;
      name = _nameController.text;
      fullName = _fullNameController.text;
      ground = _groundController.text;
      logo = team.logo;
      website = _websiteController.text;
      continentValue = team.league.country.continentName;
      leagueValue = team.league.id;
      league = team.league;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullNameController.dispose();
    _groundController.dispose();
    _websiteController.dispose();

    //  implement super.dispose
    super.dispose();
  }

  void resetLeagueValue() {
    leagueValue = null;
    league = null;
  }
}
