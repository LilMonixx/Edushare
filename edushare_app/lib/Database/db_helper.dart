import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class DBHelper {
  static Database? _db;

  // ================= GET DATABASE (SINGLETON) =================
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // ================= INIT DATABASE =================
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'Edushare.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        print("🔥 DATABASE CREATED");

        // ================= USER =================
        await db.execute('''
          CREATE TABLE User (
            UserID TEXT PRIMARY KEY,
            Name TEXT NOT NULL,
            Email TEXT,
            NumberOfPost INTEGER DEFAULT 0,
            Avatar TEXT,
            LocalAvatar TEXT,
            Status TEXT,
            CreatedAt TEXT,
            Role TEXT
          )
        ''');

        // ================= POST =================
        await db.execute('''
          CREATE TABLE Post (
            PostID TEXT PRIMARY KEY,
            UserID TEXT,
            Title TEXT,
            Content TEXT,
            Subject TEXT,
            Status TEXT,
            CreatedAt TEXT,
            UpdatedAt TEXT,
            FOREIGN KEY (UserID) REFERENCES User(UserID)
          )
        ''');

        // ================= ATTACHMENT =================
        await db.execute('''
          CREATE TABLE Attachment (
            AttachmentID TEXT PRIMARY KEY,
            PostID TEXT,
            Url TEXT,
            FileName TEXT,
            FileType TEXT,
            FileSize TEXT,
            CreatedAt TEXT,
            FOREIGN KEY (PostID) REFERENCES Post(PostID)
          )
        ''');

        // ================= LOCAL FILE (OFFLINE DOWNLOAD) =================
        await db.execute('''
          CREATE TABLE LocalFile (
            ID TEXT PRIMARY KEY,
            AttachmentID TEXT,
            UserID TEXT,
            LocalPath TEXT,
            Name TEXT,
            Type TEXT,
            Size TEXT,
            DownloadedAt TEXT,
            FOREIGN KEY (UserID) REFERENCES User(UserID),
            FOREIGN KEY (AttachmentID) REFERENCES Attachment(AttachmentID)
          )
        ''');
      },
    );
  }

  // =========================================================
  // ================= USER METHODS ==========================
  // =========================================================

  Future<void> upsertUser(Map<String, dynamic> u) async {
    final dbClient = await db;

    await dbClient.insert(
      "User",
      u,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    final dbClient = await db;

    final res = await dbClient.query(
      "User",
      where: "UserID = ?",
      whereArgs: [id],
    );

    return res.isNotEmpty ? res.first : null;
  }

  Future<int> insertPost(Map<String, dynamic> post) async {
    final dbClient = await db;
    return await dbClient.insert(
      'Post',
      post,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final dbClient = await db;
    return await dbClient.query('Post');
  }

  // =========================================================
  // ================= ATTACHMENT ============================
  // =========================================================

  Future<int> insertAttachment(Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.insert(
      'Attachment',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAttachments() async {
    final dbClient = await db;
    return await dbClient.query('Attachment');
  }

  // =========================================================
  // ================= LOCAL FILE (DOWNLOAD) =================
  // =========================================================

  Future<int> insertLocalFile(Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.insert(
      'LocalFile',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLocalFiles() async {
    final dbClient = await db;
    return await dbClient.query('LocalFile');
  }
}

