//DBhelper
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class User {
  final String email;
  final String password;
  final String? name;
  final String? phone;
  final String? jobRole;
 
  User({
    required this.email,
    required this.password,
    this.name,
    this.phone,
    this.jobRole,
  });
 
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name ?? '',
      'phone': phone ?? '',
      'job_role': jobRole ?? '',
    };
  }
 
  static User fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      name: map['name'],
      phone: map['phone'],
      jobRole: map['job_role'],
    );
  }
}
 
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
 
  DatabaseHelper._init();
 
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('immodrops.db');
    return _database!;
  }
 
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
 
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
 
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        email TEXT PRIMARY KEY,
        password TEXT NOT NULL,
        name TEXT,
        phone TEXT,
        job_role TEXT
      )
    ''');
  }
 
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
 
  Future<User?> getUser(String email) async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
 
    if (maps.isEmpty) {
      return null;
    }
 
    return User.fromMap(maps.first);
  }
 
  Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
 
  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'email = ?',
      whereArgs: [user.email],
    );
  }
 
  Future close() async {
    final db = await database;
    db.close();
  }
}
