import 'package:flutter/material.dart';
import 'package:data_football/models/models.dart';
import 'package:data_football/screens/screens.dart';

class LeagueFormScreen extends StatefulWidget {
  const LeagueFormScreen({Key? key, this.league}) : super(key: key);
  final League? league;

  @override
  State<LeagueFormScreen> createState() => _LeagueFormScreenState();
}

class _LeagueFormScreenState extends State<LeagueFormScreen> {
  // Initiate [_title] name on this screen
  String _title = 'Add League';

  // Declare variabel that will use to league properties
  int? _id;
  String _name = '';
  Country? _country;
  int _numberOfTeams = 0;
  String? _logo;
  String? _website;

  // Declare and initiate variable for field details
  final countries = <Country>[];
  String? _countryCode;
  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Add League Form Screen
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              showLogo(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textField(
                      controller: _nameController,
                      label: 'League Name',
                      hint: 'Liga 1',
                    ),
                    countryDropdown(),
                    const SizedBox(height: 10),
                    teamsSlider(),
                    textField(
                      controller: _websiteController,
                      label: 'Website',
                      hint: 'https://ligaindonesiabaru.com',
                    ),
                    const SizedBox(height: 20),
                    saveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            image: loadImageProvider(_logo),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: InkWell(
                onTap: () async {
                  // Call ImageUploadForm and wait for new logo source
                  final String? updatedLogo = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageUploadForm(
                        imageSource: _logo,
                      ),
                    ),
                  );

                  // Change state of the page
                  setState(() {
                    // Asign new logo source to _logo variable if not null
                    _logo = updatedLogo ?? _logo;
                  });
                },
                child: Container(
                  width: 180,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (_logo != null) ? 'Change Logo' : 'Add Logo',
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

  Widget textField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
          hintText: hint,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget countryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Country',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _countryCode,
                  hint: const Text('Select Country'),
                  items: countries.map(
                    (countryValue) {
                      return DropdownMenuItem(
                        value: countryValue.code,
                        child: Text(countryValue.name),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _country = countries
                          .where((countryValue) => countryValue.code == value)
                          .toList()[0];
                      _countryCode = value;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _country?.continentName ?? '???',
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget teamsSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Number of Teams',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Slider(
                  value: _numberOfTeams.toDouble(),
                  min: 0.0,
                  max: 32.0,
                  divisions: 32,
                  label: _numberOfTeams.toString(),
                  onChanged: (value) {
                    setState(() {
                      _numberOfTeams = value.toInt();
                    });
                  },
                ),
              ),
              Expanded(
                child: Text(_numberOfTeams.toString(),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () {
              _name = _nameController.text;
              _website = _websiteController.text;

              final league = League(
                id: _id,
                name: _name,
                country: _country!,
                numberOfTeams: _numberOfTeams,
                logo: _logo!,
                website: _website!,
              );

              league.saveToDB().then((value) {
                if (value == 0) {
                  Navigator.pop(context, league);
                } else {
                  Navigator.pop(context);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline6,
            ),
            child: const Text('Save'),
          ))
        ],
      ),
    );
  }

  @override
  void initState() {
    // Get async country list data
    () async {
      countries.addAll(await Country.getAllFromDB());
      countries.sort((a, b) => a.name.compareTo(b.name));
      setState(() {});
    }();

    super.initState();
    final league = widget.league;

    // Check league's value if not null that means this page about edit/update
    // older league data
    if (league != null) {
      // Set [_title] name to 'Edit'
      _title = 'Edit League Details';

      // Initate controller or field value
      _nameController.text = league.name;
      _websiteController.text = league.website;
      _countryCode = league.country.code;

      // Initiate the variable with league data
      _id = league.id;
      _name = _nameController.text;
      _country = league.country;
      _numberOfTeams = league.numberOfTeams;
      _logo = league.logo;
      _website = _websiteController.text;
    }
  }

  @override
  void dispose() {
    // Dispose controller
    _nameController.dispose();
    _websiteController.dispose();

    super.dispose();
  }
}
