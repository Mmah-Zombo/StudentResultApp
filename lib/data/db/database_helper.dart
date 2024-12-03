import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Future<void> deleteDatabaseFile() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, 'auth_app.db');
  //   await deleteDatabase(path);
  //   print('Database deleted.');
  // }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          role TEXT,
          class TEXT
        )
        ''');
      },
    );
  }

  Future<int> registerUser(String name, String email, String password,
      String role, String userClass) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'class': userClass,
      });
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        // Email already exists
        throw Exception('Email already registered!');
      }
      rethrow; // Re-throw other exceptions
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}
