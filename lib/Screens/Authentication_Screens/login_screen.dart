import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/Authentication_Screens/signup_screen.dart';
import 'package:habit_tracker/Screens/home_screen.dart';
import 'package:habit_tracker/UI_elements/buttons.dart';
import 'package:habit_tracker/UI_elements/color.dart';
import 'package:habit_tracker/UI_elements/text_styles.dart';
User?currentUser;

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool isLoading = false;

  /// function for login with parameter email and password
  login(String email, String password) async{

    /// if form is validate
    if(_key.currentState!.validate()){

      /// setting isLoading to true
      setState(() {
        isLoading = true;
      });

      try{
        /// getting user credentials
        final UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        /// checking if email is verified
        if(user.user!.emailVerified){
          /// navigating to homeScreen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

          setState(() {
            currentUser = user.user!;
            isLoading= false;
          });

        }else{

          setState(() {
            isLoading= false;
          });

          /// custom snack bar
          final snackBar = SnackBar(
            content: Text('Please verify your email first before login!'),
            backgroundColor: primaryColor,
            shape: StadiumBorder(),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

      }on FirebaseAuthException catch(e){

        setState(() {
          isLoading= false;
        });

        final snackBar = SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: primaryColor,
          shape: StadiumBorder(),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          behavior: SnackBarBehavior.floating,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading? Center(child: CircularProgressIndicator(),): SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('Assets/images/bg.jpg'), fit: BoxFit.cover, opacity: 0.7)
            ),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(child: Text18Bold(text: 'LogIn', color: primaryColor)),

                  SizedBox(
                    height: 20,
                  ),

                  Text16Medium(text: 'Email', color: primaryTextColor),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val)=> val!.isEmpty?'Please write an email':null,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Text16Medium(text: 'Password', color: primaryTextColor),

                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    validator: (val)=> val!.isEmpty?'Please write a password':null,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  GestureDetector(
                      onTap: (){
                        FocusManager.instance.primaryFocus?.unfocus();
                       login(_emailController.text.trim(), _passwordController.text.trim());
                      },
                      child: PrimaryButton(text: 'LogIn')),

                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Text('Don\'t have an account?'),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                        },
                        child: Text(' SignUp', style: TextStyle(color: Colors.blue),),
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
