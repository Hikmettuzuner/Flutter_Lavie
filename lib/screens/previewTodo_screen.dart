import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavie/data/dbHelper.dart';
import 'package:lavie/models/todo.dart';

class Previewtodo extends StatefulWidget {
  Todo todoList;
  Previewtodo(this.todoList);
  @override
  State<StatefulWidget> createState() {
    return _Previewtodo(todoList);
  }
}

class _Previewtodo extends State {
  var dbHelper = DbHelper();
  DateTime _selectedDate;

  Todo todoList;
  _Previewtodo(this.todoList);
  final GlobalKey<ScaffoldState> _globalKeyy = GlobalKey<ScaffoldState>();
  var todoBaslikController = TextEditingController();
  var todoAciklamakController = TextEditingController();
  var _textEditingController = TextEditingController();

  @override
  void initState() {
    todoBaslikController.text = todoList.title;
    todoAciklamakController.text = todoList.description;
    _textEditingController.text = todoList.todoDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKeyy,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        centerTitle: true,
        title: const Text('Proğram Detay',
            style: TextStyle(color: Colors.deepPurpleAccent)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Divider(
              color: Colors.deepPurpleAccent,
              height: 80.0,
            ),
            new ListTile(
              leading: const Icon(Icons.work),
              title: new TextField(
                controller: todoBaslikController,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: new InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black)),
                  hintText: "Başlık",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            new ListTile(
              leading: const Icon(Icons.description),
              title: new TextField(
                controller: todoAciklamakController,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: new InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black)),
                  hintText: "Açıklama",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            new ListTile(
              leading: const Icon(Icons.work),
              title: new TextField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: new InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black)),
                ),
                focusNode: AlwaysDisabledFocusNode(),
                controller: _textEditingController,
                onTap: () {
                  _selectDate(context);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.deepPurpleAccent,
              height: 80.0,
            ),
            FlatButton(
                child: Text('Güncelle',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 18)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black),
                ),
                color: Colors.black,
                onPressed: () {})
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _textEditingController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

////KOD BITER
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
