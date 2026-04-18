import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Database initialize karna
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('learning_app.db'); // Database ka naam
    return _database!;
  }

  // Database ka path set karna
  Future<Database> _initDB(String filePath) async {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Table create karna
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // ==========================================
  // SIGNUP LOGIC (Register User)
  // ==========================================
  Future<bool> registerUser(String name, String email, String password) async {
    final db = await instance.database;
    try {
      await db.insert(
        'users',
        {
          'name': name,
          'email': email,
          'password': password,
        },
        conflictAlgorithm: ConflictAlgorithm.fail, // Agar email same hui to fail ho jayega
      );
      return true; // Register ho gaya
    } catch (e) {
      return false; // Email already exist karti hai
    }
  }

  // ==========================================
  // LOGIN LOGIC (Verify User)
  // ==========================================
  Future<bool> verifyLogin(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty; // Agar user mil gaya to true, warna false
  }
}