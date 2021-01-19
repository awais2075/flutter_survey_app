import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Survey App',style: TextStyle(color: Colors.white,fontSize: 32, fontWeight: FontWeight.bold),),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_circle_rounded),
              title: Text('Submit a New Survey'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/survey_page');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('View All Surveys'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/surveys_page');

              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ));
  }
}
