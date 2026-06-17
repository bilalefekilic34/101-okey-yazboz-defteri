import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('okey101.db');
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
      CREATE TABLE games(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        team1_name TEXT,
        team2_name TEXT,
        total_rounds INTEGER,
        game_date TEXT,
        is_finished INTEGER,
        winner_team TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE round_scores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id INTEGER,
        round_number INTEGER,
        team1_score INTEGER,
        team2_score INTEGER,
        team1_penalty INTEGER,
        team2_penalty INTEGER,
        FOREIGN KEY (game_id) REFERENCES games (id) ON DELETE CASCADE
      )
    ''');
  }

  // 1. Yeni Oyun Başlat
  Future<int> createNewGame(Game game) async {
    final db = await instance.database;
    return await db.insert('games', game.toMap());
  }

  // 2. El Skorunu Kaydet
  Future<int> saveRoundScore(RoundScore score) async {
    final db = await instance.database;
    return await db.insert('round_scores', score.toMap());
  }

  // 3. Oyun Geçmişini Getir
  Future<List<Game>> getGameHistory() async {
    final db = await instance.database;
    final result = await db.query(
      'games',
      where: 'is_finished = ?',
      whereArgs: [1],
      orderBy: 'game_date DESC',
    );
    return result.map((json) => Game.fromMap(json)).toList();
  }

  // 4. Canlı Skor İçin Elleri Getir
  Future<List<RoundScore>> getRoundScoresForGame(int gameId) async {
    final db = await instance.database;
    final result = await db.query(
      'round_scores',
      where: 'game_id = ?',
      whereArgs: [gameId],
      orderBy: 'round_number ASC',
    );
    return result.map((json) => RoundScore.fromMap(json)).toList();
  }

  // 5. Oyunu Bitir
  Future<int> finishGame(int gameId, String winnerTeam) async {
    final db = await instance.database;
    return await db.update(
      'games',
      {'is_finished': 1, 'winner_team': winnerTeam},
      where: 'id = ?',
      whereArgs: [gameId],
    );
  }
}