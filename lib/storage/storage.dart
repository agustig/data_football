import 'package:mysql1/mysql1.dart';

class Storage {
  Storage();

  String host = '127.0.0.1';
  int port = 3306;
  String user = 'root';
  String db = 'dataFootball';

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
