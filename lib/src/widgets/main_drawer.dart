import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(height: 20),
          buildListTile(Icons.restaurant, 'Meals'),
          buildListTile(Icons.settings, 'Filters')
        ],
      ),
    );
  }
  
  ListTile buildListTile(IconData iconData, String title) {
    return ListTile(
          onTap: null,
          leading: Icon(
            iconData,
            size: 26,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
  }
}
