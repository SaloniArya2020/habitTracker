import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/Authentication_Screens/login_screen.dart';
import 'package:habit_tracker/Screens/dashboard_screen.dart';
import 'package:habit_tracker/UI_elements/color.dart';

import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [DashboardScreen(), AddHabitScreen()];

  int _pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// floating signOut button
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
          final snackBar = SnackBar(
            content: Text("You are sign out!"),
            backgroundColor: primaryColor,
            shape: StadiumBorder(),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Icon(Icons.logout),
        backgroundColor: primaryColor,
      ),

      body: SafeArea(child: pages[_pageIndex]),
      /// curve animation navigation bar
      bottomNavigationBar: CurvedNavigationBar(
        /// index is same as current page index
        index: _pageIndex,
        onTap: (index){
          /// change the page index
          setState(() {
            _pageIndex = index;
          });
        },
        buttonBackgroundColor: primaryAccentColor,
        animationCurve: Curves.decelerate,
        animationDuration: Duration(milliseconds: 100),
        color: primaryColor,
        backgroundColor: Colors.white,
        height:60,
        items: [
          Icon(Icons.home,),
          Icon(Icons.add),
        ],
      )
    );
  }
}
