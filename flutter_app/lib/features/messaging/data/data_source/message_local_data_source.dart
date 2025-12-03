import 'package:path/path.dart';
import 'package:turbo_vets_assessment/core/constants/constants.dart';
import 'package:turbo_vets_assessment/features/messaging/data/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class MessageLocalDataSource {
  Future<List<MessageModel>> getMessages();
  Future<void> insertMessage(MessageModel message);
  Future<void> deleteMessage(int id);
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '${Constants.DATABASE_NAME}.db');

    return await openDatabase(
      path,
      version: Constants.DATABASE_VERSION,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL,
            sender TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    try {
      final db = await database;
      final messages = await db.query(
        Constants.DATABASE_NAME,
        orderBy: 'timestamp ASC',
      );
      return messages.map((item) => MessageModel.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  @override
  Future<void> insertMessage(MessageModel message) async {
    try {
      final db = await database;
      await db.insert(Constants.DATABASE_NAME, message.toMap());
    } catch (e) {
      throw Exception('Failed to insert message: $e');
    }
  }

  @override
  Future<void> deleteMessage(int id) async {
    try {
      final db = await database;
      await db.delete(
        Constants.DATABASE_NAME,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}
