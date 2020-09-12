import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lavie/data/dbHelper.dart';
import 'package:lavie/models/todo.dart';
import 'package:lavie/screens/cagetories_screen.dart';
import 'package:lavie/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State {
////// Listeleme Kodları

  var dbHelper = DbHelper();
  List<Todo> todoList;
  int todoCount = 0;

  @override
  void initState() {
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
            child: Text(
              "Kategori Ekle",
              style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.deepPurpleAccent,
          )
        ],
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        title: const Text('Listem',
            style: TextStyle(color: Colors.deepPurpleAccent)),
        backgroundColor: Colors.black,
      ),
      body: buildProductList(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            gotoTodoScreenn();
          },
          label: new Text(" Ekle"),
          icon: Icon(Icons.add_box),
          backgroundColor: Colors.deepPurpleAccent),
    );
  }

  ListView buildProductList() {
    return ListView.builder(
        itemCount: todoCount,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.orangeAccent,
              elevation: 10,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        todoList[position].title == null
                            ? 'Tarih Bilgisi Bulunmamakta..'
                            : todoList[position].title.toString(),
                        style: TextStyle(color: Colors.white)),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void gotoTodoScreenn() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoScreen()));
    if (result != null) {
      if (result) {
        getProducts();
      }
    }
  }

  void getProducts() async {
    var productFuture = dbHelper.getTodo();
    productFuture.then((data) {
      setState(() {
        this.todoList = data;
        todoCount = data.length;
      });
    });
  }
}
