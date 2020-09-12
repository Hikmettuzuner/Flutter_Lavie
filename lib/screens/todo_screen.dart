import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lavie/data/dbHelper.dart';
import 'package:lavie/models/todo.dart';

import 'home_screen.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var dbHelper = DbHelper();
  List<Todo> todoList;
  int todoCount = 0;

  var _selectedValue;
  var _categories = List<DropdownMenuItem>();

  DateTime _selectedDate;

  var todoBaslikController = TextEditingController();
  var todoAciklamakController = TextEditingController();

  TextEditingController _textEditingController = new TextEditingController();

  final GlobalKey<ScaffoldState> _globalKeyy = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var categories = await dbHelper.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKeyy,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        centerTitle: true,
        title: const Text('Proğram Ekle',
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
            new ListTile(
              leading: const Icon(Icons.category),
              title: new DropdownButtonFormField(
                value: _selectedValue,
                items: _categories,
                hint: Text('Kategoriler', style: TextStyle(fontSize: 20)),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: new InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black)),
                ),
              ),
            ),
            const Divider(
              color: Colors.deepPurpleAccent,
              height: 80.0,
            ),
            FlatButton(
                child: Text('Kaydet',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 18)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Colors.black,
                onPressed: () {
                  addTodo();
                })
          ],
        ),
      ),
    );
  }

  _showSuccessSnacbar(message) async {
    var _snackbar = SnackBar(
      content: message,
      duration: Duration(milliseconds: 700),
      backgroundColor: Colors.deepPurpleAccent,
    );
    _globalKeyy.currentState.showSnackBar(_snackbar);
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

  addTodo() async {
    if (_textEditingController.text != '' &&
        todoAciklamakController.text != '' &&
        todoBaslikController.text != '') {
      var result = await dbHelper.insertTodo(Todo(
        title: todoBaslikController.text,
        description: todoAciklamakController.text,
        category: _selectedValue.toString(),
        todoDate: _textEditingController.text,
        isFinished: 0,
      ));
      Navigator.pop(context, true);
    }
  }
}

/////////KOD BITER

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
