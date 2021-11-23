import 'package:path/path.dart';
import 'package:pro_gen/app/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class MockRepository {
  static const String kProductsTable = 'products';

  Future<Database> _getDB() async {
    final localPath = await getDatabasesPath();
    final dbPath = join(localPath, "data_base.db");
    final database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, lastDB) {
        String sql =
            "CREATE TABLE $kProductsTable (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, price DOUBLE, discount DOUBLE, percentage FLOAT, is_available INTEGER )";
        db.execute(sql);
      },
    );
    return database;
  }

  Future<void> createProduct(ProductModel product) async {
    Database db = await _getDB();
    await db.insert(
      kProductsTable,
      product.toMap(),
    );
  }

  Future<List<ProductModel>> readProducts() async {
    Database db = await _getDB();
    final result = await db
        .rawQuery('SELECT * FROM $kProductsTable ORDER BY UPPER(name) ASC');
    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<List<ProductModel>> searchProducts(String search) async {
    Database db = await _getDB();
    final result = await db
        .rawQuery("SELECT * FROM $kProductsTable WHERE name LIKE '%$search%'");
    return result.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<void> deleteProduct(int productId) async {
    Database db = await _getDB();
    db.delete(
      kProductsTable,
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    Database db = await _getDB();
    db.update(
      kProductsTable,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
}
