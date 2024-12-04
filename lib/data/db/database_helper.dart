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
        // Handle schema changes
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS subjects(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              year TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS results(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              studentId BIGINT,
              subjectId INTEGER,
              grade TEXT,
              FOREIGN KEY (studentId) REFERENCES users(studentId),
              FOREIGN KEY (subjectId) REFERENCES subjects(id)
            )
          ''');
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
        // Create the subjects table
        await db.execute('''
          CREATE TABLE modules(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            year TEXT
          )
        ''');

        // Create the results table
        await db.execute('''
          CREATE TABLE results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId BIGINT,
            moduleId INTEGER,
            grade TEXT,
            FOREIGN KEY (studentId) REFERENCES users(studentId),
            FOREIGN KEY (moduleId) REFERENCES modules(id)
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

  // Insert a subject
  Future<int> insertModule(String title, String year) async {
    final db = await database;
    return await db.insert('subjects', {
      'title': title,
      'year': year,
    });
  }

  // Insert a result
  Future<int> insertResult(
      String studentId, int subjectId, String grade) async {
    final db = await database;
    return await db.insert('results', {
      'studentId': studentId,
      'subjectId': subjectId,
      'grade': grade,
    });
  }

  // Get all results for a specific student
  Future<List<Map<String, dynamic>>> getStudentResults(String studentId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT subjects.title, subjects.year, results.grade
      FROM results
      INNER JOIN subjects ON results.subjectId = subjects.id
      WHERE results.studentId = ?
    ''', [studentId]);
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await database;
    return await db.query(
      'users',
      where: 'role = ?',
      whereArgs: ['Student'], // Filter rows where role is "Lecturer"
    );
  }

  Future<double> calculateCGPA(String studentId) async {
    final db = await database;

    // Fetch all grades for the student
    final results = await db.rawQuery('''
    SELECT grade FROM results WHERE studentId = ?
  ''', [studentId]);

    if (results.isEmpty) return 0.0;

    // Grade mapping
    final gradeMap = {
      "A+": 4.0,
      "A": 4.0,
      "A-": 4.0,
      "B+": 3.5,
      "B": 3.0,
      "B-": 3.0,
      "C+": 2.5,
      "C": 2.0,
      "D": 1.5,
      "F": 0.0,
    };

    // Convert grades to grade points and calculate average
    double totalPoints = 0.0;
    int subjectCount = 0;

    for (final result in results) {
      final grade = result['grade'];
      if (gradeMap.containsKey(grade)) {
        totalPoints += gradeMap[grade]!;
        subjectCount++;
      }
    }

    if (subjectCount == 0) return 0.0;

    return totalPoints / subjectCount;
  }
}
