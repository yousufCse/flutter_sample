import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item_model.dart';

class NewsDbProvider {
  Database db;

  init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, 'items.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, version) {
        newDb.execute("""
          CREATE_TABLE
          """);
      },
    );
  }
}
