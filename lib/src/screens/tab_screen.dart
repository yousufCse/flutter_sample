import 'package:flutter/material.dart';
import './categories_screen.dart';
import './favorite_screen.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = 'tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pages = [
    {'page': CategoriesScreen(), 'title': 'Categories'},
    {'page': FavoriteScreen(), 'title': 'Your Favorite'},
  ];

  int _selectedIndex = 0;

  _selectTab(int index) {
    this.setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.category),
            title: const Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text('Favorite'),
          ),
        ],
      ),
    );
  }
}
