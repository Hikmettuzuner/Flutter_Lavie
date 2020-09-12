import 'package:flutter/material.dart';
import 'package:lavie/data/dbHelper.dart';
import 'package:lavie/models/category.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var dbHelper = DbHelper();
  var _category = Category();
  List<Category> categoriess;

  clearTextInput() {
    txtNameEkle.clear();
    txtDescriptionEkle.clear();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  var category;
  int categoryCount = 0;

  @override
  void initState() {
    getCategories();
  }

  var txtName = TextEditingController();
  var txtDescription = TextEditingController();

  var txtNameEkle = TextEditingController();
  var txtDescriptionEkle = TextEditingController();

  var edittxtName = TextEditingController();
  var edittxtDescription = TextEditingController();

  _showFormDialogg(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actions: <Widget>[
              FlatButton(
                color: Colors.lightGreen,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("İptal"),
                textColor: Colors.white,
              ),
              FlatButton(
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  addCategory();
                },
                child: Text("Kaydet"),
              )
            ],
            title: Text("Kategori Ekleyiniz"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Kategori Yazınız',
                      labelText: 'Kategori',
                    ),
                    controller: txtNameEkle,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Detay Belirtiniz',
                      labelText: 'Detay',
                    ),
                    controller: txtDescriptionEkle,
                  )
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actions: <Widget>[
              FlatButton(
                color: Colors.lightGreen,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("İptal"),
                textColor: Colors.white,
              ),
              FlatButton(
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = edittxtName.text;
                  _category.description = edittxtDescription.text;
                  var result = updateCategory(_category);
                },
                child: Text("Güncelle"),
              )
            ],
            title: Text("Kategori Güncelle"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Kategori Belirtiniz',
                      labelText: 'Kategori',
                    ),
                    controller: edittxtName,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Detay Belirtiniz',
                      labelText: 'Detay',
                    ),
                    controller: edittxtDescription,
                  )
                ],
              ),
            ),
          );
        });
  }

  _deeFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actions: <Widget>[
              FlatButton(
                color: Colors.lightGreen,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("İptal"),
                textColor: Colors.white,
              ),
              FlatButton(
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () async {
                  deleteFunction(categoryId);
                },
                child: Text("Sil"),
              )
            ],
            title: Text("Silmek İstediğinize Emin misiniz ?"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      key: _globalKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        centerTitle: true,
        title: const Text('Kategori Listesi',
            style: TextStyle(color: Colors.deepPurpleAccent)),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        bottom: true,
        child: buildCategoryList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            _showFormDialogg(context);
          },
          label: new Text(" Ekle"),
          icon: Icon(Icons.add_box),
          backgroundColor: Colors.deepPurpleAccent),
    );
  }

  deleteFunction(categorId) async {
    var result = await dbHelper.delete(categorId);
    if (result > 0) {
      _showSuccessSnacbar(
        Text("Silme Başarılı !"),
      );
      Navigator.pop(context);
      getCategories();
    } else {
      _showSuccessSnacbar("Hata Var");
    }
  }

  addCategory() async {
    if (txtNameEkle.text != '' && txtDescriptionEkle.text != '') {
      var result = await dbHelper.insert(
        Category(
          name: txtNameEkle.text,
          description: txtDescriptionEkle.text,
        ),
      );
      if (result > 0) {
        clearTextInput();
        _showSuccessSnacbar(
          Text("Ekeleme Başarılı !"),
        );
        Navigator.of(context, rootNavigator: true).pop();
        getCategories();
      }
      // dismisses only the dialog and returns nothing

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),

    } else {
      showAlertDialog();
    }
    // print(result);
    // Navigator.pop(context, true);
  }

  ListView buildCategoryList() {
    return ListView.builder(
        itemCount: categoryCount,
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
                  onPressed: () {
                    _editCategory(context, categoriess[position].id);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(categoriess[position].name,
                        style: TextStyle(color: Colors.white)),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _deeFormDialog(context, categoriess[position].id);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void getCategories() async {
    var productFuture = dbHelper.getCategory();
    productFuture.then((data) {
      setState(() {
        this.categoriess = data;
        categoryCount = data.length;
        if (categoryCount == 0) {
          alert();
        }
      });
    });
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.white,
        title: new Text('UYARI'),
        content: Text('Lütfen Boş Alan Bırakmayınız'),
        actions: <Widget>[
          new FlatButton(
            color: Colors.lightGreen,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('Geri Gel'),
          ),
        ],
      ),
    );
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await dbHelper.readCategoryById(categoryId);
    setState(() {
      edittxtName.text = category[0]['name'] ?? 'No Name';
      edittxtDescription.text = category[0]['description'] ?? 'No Name';
    });
    _editFormDialog(context);
  }

  updateCategory(Category _category) async {
    var result = await dbHelper.update(
      Category.withId(
        id: _category.id,
        name: edittxtName.text,
        description: edittxtDescription.text,
      ),
    );
    Navigator.pop(context);

    getCategories();
    _showSuccessSnacbar(
      Text("Güncelleme Başarılı !"),
    );
  }

  _showSuccessSnacbar(message) async {
    var _snackbar = SnackBar(
      content: message,
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.deepPurpleAccent,
    );
    _globalKey.currentState.showSnackBar(_snackbar);
  }

  void alert() async {
    var alertStyle = AlertStyle(
      overlayColor: Colors.grey,
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Color.fromRGBO(91, 55, 185, 1.0),
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: "Uyarı",
      desc: "Herhangi Bir Kategori Bulunmamaktadır!",
      buttons: [
        DialogButton(
          child: Text(
            "Kategori Ekle",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(91, 55, 185, 1.0),
          radius: BorderRadius.circular(10.0),
        ),
      ],
    ).show();
  }
  // super.initState();}
}
