import 'package:mysql1/mysql1.dart';
import 'package:data_football/config.dart' as config;

class Storage {
  Storage();

  String host = config.dbHost;
  int port = config.dbPort;
  String user = config.dbUser;
  String password = config.dbPassword;
  String db = config.dbName;

  Future<MySqlConnection> getConnection() {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      db: db,
    );
    return MySqlConnection.connect(settings);
  }
}

Future<List<ResultRow>> getStorage(String sql, [List<Object?>? values]) async {
  final db = Storage();
  final results = <ResultRow>[];
  await db.getConnection().then((conn) async {
    await conn.query(sql, values).then((data) {
      for (var row in data) {
        results.add(row);
      }
    });

    conn.close();
  });

  return results;
}

Future<Results> saveStorage(String sql, [List<Object?>? values]) async {
  final db = Storage();
  final conn = await db.getConnection();
  final results = await conn.query(sql, values);
  return results;
}
