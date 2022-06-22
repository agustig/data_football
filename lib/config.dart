// All public config variable in this file.
// API Key, Database config, etc.

import 'dart:io';

/// API key obtained from https://www.football-data.org/.
///
/// Register in https://www.football-data.org/client/register
/// for the key and put here.
const dataFootballApiKey = ''; // Insert your Football-data.org API key here!

/// Database host, can be URL or IP address
final dbHost = defaultLocalhost(); // Change if dbHost is not use local host

/// Database port, usually 3306
const dbPort = 3306;

/// Database name
const dbName = 'dataFootball';

/// Database user
const dbUser = 'root';

/// Database password
const String dbPassword = '';

/// Football news source url from Google News
const newsFeedUrl =
    'https://news.google.com/rss/topics/CAAqJQgKIh9DQkFTRVFvSUwyMHZNREoyZURRU0JXVnVMVWRDS0FBUAE?hl=en-US&gl=US&ceid=US%3Aen';

/// Return local IP Address based on Platform runtime
String defaultLocalhost() {
  // '10.0.2.2' is default local IP address on Android Emulator (AVD Manager)
  // instead '127.0.0.1'
  if (Platform.isAndroid) {
    return '10.0.2.2';
  } else {
    return '127.0.0.1';
  }
}