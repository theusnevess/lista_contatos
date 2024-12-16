import 'package:sqflite/sqlite_api.dart';
import 'db_connection.dart';

class Repository {
  late DBConnection dbConnection;
  Repository() {
    dbConnection = DBConnection();
  }

  static Database? _database;

//Instância do banco de dados
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await dbConnection.setDatabase();
      return _database;
    }
  }

  //Insere contato
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //Lê todos os registros
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //Lê os registros pelo Id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  //Editar contato
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: "id=?", whereArgs: [data['id']]);
  }

  //Deletar contato
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$itemId");
  }
}
