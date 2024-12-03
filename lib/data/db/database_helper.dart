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

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth_app.db');

    return await openDatabase(
      path,
      version: 2, // Incremented version for migration
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add `studentId` column for students
          await db.execute("ALTER TABLE users ADD COLUMN studentId BIGINT");
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          role TEXT,
          class TEXT,
          studentId BIGINT
        )
        ''');
      },
    );
  }

  Future<int> registerUser(String name, String email, String password,
      String role, String userClass, String? studentId) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'class': userClass,
        'studentId':
            role == 'Student' ? studentId : null, // Only set for students
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
