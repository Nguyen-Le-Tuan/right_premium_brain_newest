//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_test/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import '../game.dart';
import '../settings_page.dart';
import '../adddeck.dart';
import '../edit_deck_page.dart';
import '../edit_pass.dart';
import '../overview.dart';
import '../stats_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: ElevatedButton(
  //         child: Text("Logout"),
  //         onPressed: () {
  //           FirebaseAuth.instance.signOut().then((value) {
  //             print("Sign Out");
  //             Navigator.push(
  //                 context, MaterialPageRoute(builder: (context) => SigninScreen()));
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }
  int _currentIndex = 0;
  int _selectedIndex = 0;
  late List<Widget> _children;

  late Settings settings;
  late EditUser editUser;
  late AddCard addCard;
  late Overview overview;
  late EditDeck editDeck;
  late GamePage gamePage;
  late StatsPage profile;

  List<int> pages = [];

  @override
  void initState() {
    super.initState();
    settings = Settings(setIndex);
    //editUser = EditUser(setIndex);
    profile = StatsPage(setIndex);
    addCard = AddCard(setIndex); // dang loi
    overview = Overview(setIndex);
    editDeck = EditDeck(setIndex);

    _children = [
      overview,
      addCard,
      settings,
      //editUser,
      profile,
      editDeck,
    ];
  }

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;

      // _selectedIndex changes which navbar option is bubbled/selected
      // highlight HOME ICON for overview, gamepage, editDeck
      if (index == 0 || index == 6 || index == 4) {
        _selectedIndex = 0;
      } else if (index == 2 || index == 5)
        _selectedIndex = 2;
      // else highlight the icon corresponding to the index
      else
        _selectedIndex = index;

      pages.add(index);
    });
  }

  void backPressed() {
    if (pages.isEmpty) {
      SystemNavigator.pop();
    } else {
      int index = pages.removeLast();
      index = pages.removeLast();
      setIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (shouldPop, result) {
        SystemNavigator.pop();
        return; // Return whether the pop should proceed.
      },
      child: Scaffold(
        body: _children[_currentIndex],
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          backgroundColor: Colors.transparent,
          height: 50,
          animationDuration: const Duration(milliseconds: 300),
          items: <Widget>[
            Icon(EvaIcons.homeOutline,
                color: Theme.of(context).colorScheme.surface, size: 30),
            Icon(EvaIcons.plusCircleOutline,
                color: Theme.of(context).colorScheme.surface, size: 30),
            Icon(EvaIcons.options2Outline,
                color: Theme.of(context).colorScheme.surface, size: 30),
            Icon(EvaIcons.barChart2Outline,
                color: Theme.of(context).colorScheme.surface, size: 30),
          ],
          onTap: (int index) {
            debugPrint(index.toString());
            setIndex(index);
          },
          index: _selectedIndex,
        ),
      ),
    );

  }


}
