import 'dart:async';

import 'package:lavie/models/category.dart';
import 'package:lavie/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database _dbb;

  Future<Database> get dbb async {
    if (_dbb == null) {
      _dbb = await initializeDb();
    }
    return _dbb;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "etrade.db");
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database dbb, int version) async {
    await dbb.execute(
        "Create table categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    await dbb.execute(
        "Create table todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, category TEXT, tododate TEXT, isfinished INTEGER)");
  }

  ///normal Listeleme
  ///DÜZELT
  Future<List<Category>> getCategory() async {
    Database db = await this.dbb;
    var result = await db.rawQuery("Select * From categories order by id desc");
    return List.generate(result.length, (i) {
      return Category.fromObject(result[i]);
    });
  }

  Future<List<Todo>> getTodo() async {
    Database db = await this.dbb;
    var result = await db.rawQuery("Select * From todos order by id desc");
    return List.generate(result.length, (i) {
      return Todo.fromObject(result[i]);
    });
  }

  ///Ekleme işlemi için

  Future<int> insert(Category category) async {
    Database db = await this.dbb;
    var result = await db.insert("categories", category.toMap());
    return result;
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.dbb;
    var result = await db.insert("todos", todo.todoMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.dbb;
    var result = await db.rawDelete("delete from categories where id=$id");

    return result;
  }

  Future<int> update(Category category) async {
    Database db = await this.dbb;
    var result = await db.update("categories", category.toMap(),
        where: "id=?", whereArgs: [category.id]);
    return result;
  }

  readCategoryById(categoryId) async {
    return await readDataById('categories', categoryId);
  }

  readDataById(table, itemId) async {
    Database db = await this.dbb;
    return await db.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  readCategories() async {
    return await readData('categories');
  }

  readData(table) async {
    Database db = await this.dbb;
    return await db.query(table);
  }

  saveTodo(Todo todo) async {
    Database db = await this.dbb;
    return await db.insert('todos', todo.todoMap());
  }
}
