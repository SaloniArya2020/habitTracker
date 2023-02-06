import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/UI_elements/buttons.dart';
import 'package:habit_tracker/UI_elements/color.dart';
import 'package:habit_tracker/UI_elements/custom_snack_bar.dart';
import 'package:habit_tracker/UI_elements/text_styles.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  String id = FirebaseFirestore.instance.collection("users").doc().id;
  bool isLoading = false;

  clearFields() {
    _passwordController.clear();
    _emailController.clear();
    _usernameController.clear();
  }

  signUp(String email, String password) async {
    if (_key.currentState!.validate()) {
       setState(() {
         isLoading = true;
       });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await userCredential.user!.sendEmailVerification().whenComplete(() async{
            await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
              "id": userCredential.user!.uid,
              "username": _usernameController.text.trim(),
              "email": email,
              "timestamp": DateTime.now()
            });

            clearFields();

          final snackBar = SnackBar(
            content: Text('Please check your email for verification link!'),
            backgroundColor: primaryColor,
            shape: StadiumBorder(),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            behavior: SnackBarBehavior.floating,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));

        });
      } on FirebaseAuthException catch (e) {
        final snackBar = SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: primaryColor,
          shape: StadiumBorder(),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          behavior: SnackBarBehavior.floating,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:isLoading? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Assets/images/bg.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.6)),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text18Bold(text: 'SignUp', color: primaryColor)),
                  SizedBox(
                    height: 20,
                  ),
                  Text16Medium(text: 'Username', color: primaryTextColor),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? 'Please write username' : null,
                    controller: _usernameController,
                    decoration: InputDecoration(
                        hintText: 'Enter your Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text16Medium(text: 'Email', color: primaryTextColor),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? 'Please write email' : null,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text16Medium(text: 'Password', color: primaryTextColor),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? 'Please fill password' : null,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        ///signup function
                        signUp(_emailController.text.trim(),
                            _passwordController.text.trim());

                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: PrimaryButton(text: 'SignUp')),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('Already have an account?'),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen()));
                        },
                        child: Text(
                          ' LogIn',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
