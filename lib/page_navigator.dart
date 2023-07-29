import 'package:daily_space/views/saved_apods_view.dart';
import 'package:daily_space/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const PageNavigator(),
    );
  }
}

class PageNavigator extends StatefulWidget {
  const PageNavigator({
    super.key,
  });

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    SavedApodsView(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          width: 230,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade900,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(IconlyLight.home, size: 26),
                  activeIcon: Icon(IconlyBold.home, size: 26),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(IconlyLight.star, size: 26),
                  activeIcon: Icon(IconlyBold.star, size: 26),
                  label: ''),
            ],
          )),
    );
  }
}
