import 'package:zilol_ays_tea/Models/KarzinaModel.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

final String tableCart = 'karzina';
final String tableHistory = 'History';

final String columnId = 'id';
final String columnnomi = 'nomi';
final String columntovarId = 'tovarId';
final String columnbrendId = 'brendId';
final String columnblokSoni = 'blokSoni';
final String columnkirimNarxi = 'kirimNarxi';
final String columnnalichNarxi = 'nalichNarxi';
final String columnperechNarxi = 'perechNarxi';
final String columnoptomNarxi = 'optomNarxi';
final String columnrasmi = 'rasmi';
final String columnuserId = 'userId';
final String columnqoldiq = 'qoldiq';
final String columnmiqdorBlok = 'miqdorBlok';
final String columnmiqdorSoni = 'miqdorSoni';

class DataHelper {
  static Database? _database;
  static DataHelper? _alarmHelper;

  DataHelper._createInstance();

  factory DataHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = DataHelper._createInstance();
    }
    return _alarmHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    if (_database != null) return _database!;
    var dir = await getDatabasesPath();
    var path = p.join(dir, 'core1.db');


    var database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''create table $tableCart (
          $columnId integer primary key autoincrement, 
          $columnnomi text not null,
          $columntovarId text not null,
          $columnbrendId text not null,
          $columnblokSoni text not null,
          $columnkirimNarxi text not null,
          $columnnalichNarxi text not null,
          $columnperechNarxi text not null,
          $columnoptomNarxi text not null,
          $columnrasmi text not null,
          $columnuserId text not null,
          $columnqoldiq text not null,
          $columnmiqdorBlok text not null,
          $columnmiqdorSoni text not null) 
          ''');
      },
    );
    return database;
  }

  void insertCart(KarzinaModel karzinaModel) async {
    var db = await this.database;
    var result = await db.insert(tableCart, karzinaModel.toMap());
    print('result : $result');
  }

  //
  // void insertArxiv(String turi, String mijozNomi, String document, String val_turi, String summa) async {
  //   var dbConnection = await database;
  //   String query =
  //       'INSERT INTO $tableHistory (turi, mijozNomi, document, val_turi, summa) VALUES(\'$turi\', \'$mijozNomi\', \'$document\', \'$val_turi\', \'$summa\')';
  //   await dbConnection.transaction((transaction) async {
  //     return await transaction.rawInsert(query);
  //   });
  // }

  void update(KarzinaModel karzinaModel) async {
    var db = await this.database;
    int updateCount = await db.update(tableCart, karzinaModel.toMap(),
        where: '$columnId = ?', whereArgs: [karzinaModel.id]);
    print('update result : $updateCount');
  }

  // Future getTotal() async {
  //   var db = await this.database ;
  //   var result = await db.rawQuery("select sum(sotish_narxi) as Total from karzina where valyuta_turi = 1");
  //
  // }
  void upsert(KarzinaModel karzinaModel, bool isNew) async {
    var db = await this.database;
    if (isNew) {
      var result = await db.insert(tableCart, karzinaModel.toMap());
      print('result : $result');
    } else {
      int updateCount = await db.update(tableCart, karzinaModel.toMap(),
          where: '$columnId = ?', whereArgs: [karzinaModel.id]);
      print('update result : $updateCount');
    }
  }

  Future<List<KarzinaModel>> getCart() async {
    List<KarzinaModel> _cart = [];
    var db = await this.database;
    var result = await db.query(tableCart);
    result.forEach((element) {
      var _cartInfo = KarzinaModel.fromMap(element);
      _cart.add(_cartInfo);
    });
    return _cart;
  }

  Future<KarzinaModel?> getCartById(String tovar_id) async {
    KarzinaModel? _cart;
    var db = await this.database;
    var result = await db.rawQuery("select * from $tableCart where $columntovarId = '" + tovar_id+ "'");
    result.forEach((element) {
      _cart = KarzinaModel.fromMap(element);
    });
    return _cart;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableCart, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTolov(int id) async {
    var db = await this.database;
    return await db.delete("tolov", where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> getCount() async {
    Database db = await this.database;
    var x = await db.rawQuery('SELECT COUNT (*) from $tableCart');
        int? count = Sqflite.firstIntValue(x);
    return count;
  }
}
