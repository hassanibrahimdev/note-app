import 'package:note_app/database/note.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class NoteDatabase {
  Future<void> insertNote(Note note) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'notes',
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getAllNotes() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return Note.fromJson(maps[i]);
    });
  }

  Future<void> addToFavorites(String id, int isFavorite) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'notes',
      {'is_favorite': isFavorite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> archiveNotes(List<String> ids, int isArchived) async {
    final db = await DatabaseHelper.instance.database;
    String placeholders = List.filled(ids.length, "?").join(",");
    await db.update(
      'notes',
      {'is_archived': isArchived},
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<void> moveToTrash(List<String> ids) async {
    final db = await DatabaseHelper.instance.database;
    String placeholders = List.filled(ids.length, "?").join(",");
    int deletedAt =
        DateTime
            .now()
            .millisecondsSinceEpoch + 1 * 60 * 1000;
    await db.update(
      'notes',
      {'is_deleted': 1, 'deleted_at': deletedAt},
      where: "id IN ($placeholders)",
      whereArgs: ids,
    );
  }

  Future<void> removeFromTrash(List<String> ids) async {
    final db = await DatabaseHelper.instance.database;
    String placeholders = List.filled(ids.length, "?").join(",");
    await db.update(
      'notes',
      {'is_deleted': 0, 'deleted_at': null},
      where: "id IN ($placeholders)",
      whereArgs: ids,
    );
  }

  Future<void> deleteNotes(List<String> ids) async {
    final db = await DatabaseHelper.instance.database;
    String placeholders = List.filled(ids.length, "?").join(",");
    await db.delete('notes', where: "id IN ($placeholders)", whereArgs: ids);
  }

  Future<void> syncData(List<String> notes) async {
    final db = await DatabaseHelper.instance.database;
    String placeholders = List.filled(notes.length, "?").join(",");
    await db.update(
      'notes',
      {'is_synced': 1},
      where: "id IN ($placeholders)",
      whereArgs: notes,
    );
  }

}
