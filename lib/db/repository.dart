import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//Classe responsável pela criação e gerenciamento da conexão com o banco de dados
class DBConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = p.join(directory.path, "crud_user.db");
    var database =
    await openDatabase(path, version: 1, onCreate: createDatabase);
    return database;
  }

//É chamado quando o banco de dados for criado
  Future<void> createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE users (id INTEGER PRIMARY KEY, nome TEXT, telefone TEXT, email TEXT)";
    await database.execute(sql);
  }
}