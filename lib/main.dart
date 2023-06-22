import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/Authentication_Screens/login_screen.dart';
import 'package:habit_tracker/UI_elements/color.dart';
import 'Screens/home_screen.dart';
import 'Services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Notifications().set();
  Notifications().periodicShow();
  tz.initializeTimeZones();
  await Firebase.initializeApp().whenComplete(() {
    print("Initialize on Android!");
  });


  FirebaseAuth.instance.authStateChanges().listen((user) {

    // print(FirebaseAuth.instance.currentUser);
    if(user==null){
      print('userSignOut!');
    }else{
      print("user signIn");
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        fontFamily: 'Quicksand',
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: FirebaseAuth.instance.currentUser !=null? HomeScreen(): LogInScreen()
    );
  }
}

