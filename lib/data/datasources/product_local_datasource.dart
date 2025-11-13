import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductRemoteDatasource {
  ProductRemoteDatasource._init();

  static final ProductRemoteDatasource instance =
      ProductRemoteDatasource._init();

  final String tableProduct = 'products';
  static Database? _database;

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProduct (
        id INTEGER PRIMARY KEY,
        productId INTEGER,
        name TEXT,
        categoryId INTEGER,
        categoryName TEXT,
        description TEXT,
        image TEXT,
        price TEXT,
        stock INTEGER,
        status INTEGER,
        isFavourite INTEGER,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('dbresto14.db');
    return _database!;
  }

  // insert data Product
  Future<void> insertProduct(Product product) async {
    final db = await instance.database;
    await db.insert(
      tableProduct,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // insert list of Product
  Future<void> insertProducts(List<Product> products) async {
    final db = await instance.database;
    for (var product in products) {
      await db.insert(
        tableProduct,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // get all products
  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableProduct);
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }
}
