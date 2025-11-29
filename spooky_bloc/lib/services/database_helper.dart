import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/audio_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? database;

  DatabaseHelper._init();

  Future<Database?> getDatabase() async {
    if (database != null) {
      return database;
    } else {
      database = await initializeDatabase("data.db");
      return database;
    }
  }

  Future<Database?> initializeDatabase(String fileName) async {
    String databasePath;
    String path;
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }

    if (Platform.isWindows || Platform.isLinux) {
      //ruta
      databasePath = await databaseFactoryFfi.getDatabasesPath();
      path = join(databasePath, fileName);
      return await databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(version: 1, onCreate: createAudioItem)
      );
    }
    if (Platform.isIOS||Platform.isAndroid)
    {
      databasePath = await getDatabasesPath(); //ruta
      path = join(databasePath,fileName);
      return openDatabase(path,version: 1,onCreate: createAudioItem);
    }
  }

  FutureOr<void> createAudioItem(Database database, int version) async{
    //mensaje debug
    print("ayuda");
    await database.execute(
        """
        create table audio_items
        (
          id integer primary key autoincrement,
          asset_path text not null,
          title text not null,
          artist text not null,
          image_path text not null
        )
      """
    );
  }
  Future<AudioItemModel> create (AudioItemModel audioItemModel) async{
    final dataBase = await instance.getDatabase();
    final id = await dataBase?.insert("audio_items", audioItemModel.toMap());
    return await AudioItemModel(
      id: id,
      assetPath: audioItemModel.assetPath,
      title: audioItemModel.title,
      artist: audioItemModel.artist,
      imagePath: audioItemModel.imagePath,
    );
  }

  Future<List<AudioItemModel>> read() async {
    final db = await instance.getDatabase();
    final result = await db?.rawQuery('SELECT COUNT(*) as count FROM audio_items');
    //contar
    final int count = Sqflite.firstIntValue(result!) ?? 0;

    if (count == 0) {
      print("Base de datos vacía. Insertando datos por defecto...");

      final List<AudioItemModel> defaultSongs = [
        AudioItemModel(
            assetPath: "soy_vagabundo.mp3",
            title: "Soy Vagabundo",
            artist: "Héctor Lavoe",
            imagePath: "assets/soy_vagabundo.jpg"
        ),
        AudioItemModel(
            assetPath: "blue.flac",
            title: "Blue in Green",
            artist: "Miles Davis",
            imagePath: "assets/blue.jpg"
        ),
        AudioItemModel(
            assetPath: "born.mp3",
            title: "Born Under Punches",
            artist: "Talking Heads",
            imagePath: "assets/born.jpg"
        ),
        AudioItemModel(
            assetPath: "funky.mp3",
            title: "Funky Holo Holor Bird",
            artist: "Masayoshi Takanaka",
            imagePath: "assets/funky.jpg"
        ),
        AudioItemModel(
            assetPath: "ramparts.mp3",
            title: "Ramparts",
            artist: "John Frusciante",
            imagePath: "assets/ramparts.jpg"
        ),
        AudioItemModel(
            assetPath: "allthat.mp3",
            title: "All That",
            artist: "Mayelo",
            imagePath: "assets/allthat_colored.jpg"
        ),
        AudioItemModel(
            assetPath: "love.mp3",
            title: "Love",
            artist: "Love",
            imagePath: "assets/love_colored.jpg"
        ),
        AudioItemModel(
            assetPath: "thejazzpiano.mp3",
            title: "Jazz Piano",
            artist: "The Jazz Piano",
            imagePath: "assets/thejazzpiano_colored.jpg"
        ),


      ];
      for (var song in defaultSongs) {
        print("ID: ${song.id}, Asset Path: ${song.assetPath}, Title: ${song.title}, Artist: ${song.artist}, Image Path: ${song.imagePath}");
        await db?.insert("audio_items", song.toMap());
      }
    }
    final data = await db?.query('audio_items');
    return data!.map((e) => AudioItemModel.fromMap(e)).toList();
  }


  Future <int?> update (AudioItemModel audioItemModel) async{
    final dataBase = await instance.getDatabase();
    return await dataBase?.update(
      "audio_items",
      audioItemModel.toMap(),
      where: "id = ?",
      whereArgs: [audioItemModel.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void close () async{
    final dataBase = await instance.getDatabase();
    await dataBase?.close();
  }
}
