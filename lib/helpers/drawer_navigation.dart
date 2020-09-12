import 'package:flutter/material.dart';
import 'package:lavie/screens/cagetories_screen.dart';
import 'package:lavie/screens/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/businesss.png'),
                    fit: BoxFit.fitHeight),
                color: Colors.black,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Anasayfa"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              )),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text("Kategoriler"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoriesScreen(),
                ),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.bug_report),
                title: Text("Dneme"),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
