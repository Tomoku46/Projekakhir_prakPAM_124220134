import 'package:flutter/material.dart';
import 'package:projekakhirpam_124220134/JSON/users.dart';
import 'package:projekakhirpam_124220134/componen/button.dart';
import 'package:projekakhirpam_124220134/componen/color.dart';
import 'package:projekakhirpam_124220134/componen/textfield.dart';
import 'package:projekakhirpam_124220134/views/Profile.dart';
import 'package:projekakhirpam_124220134/views/Signup.dart';
import 'package:projekakhirpam_124220134/views/beranda.dart';


import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Our controllers
  //Controller is used to take the value from user and pass it to database
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  //Login Method
  //We will take the value of text fields using controllers in order to verify whether details are correct or not
  login()async{
    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db.authenticate(Users(usrName: usrName.text, password: password.text));
    if(res == true){
      //If result is correct then go to profile or home
      if(!mounted)return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CalendarScreen(profile: usrDetails)));
    }else{
      //Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Because we don't have account, we must create one to authenticate
                //lets go to sign up

                const Text("LOGIN",style: TextStyle(color: primaryColor,fontSize: 40),),
                Image.asset("assets/upnLogo.png"),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true),

               

                //Our login button
                Button(label: "LOGIN", press: (){
                login();

                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
                        },
                        child: const Text("SIGN UP"))
                  ],
                ),

                 // Access denied message in case when your username and password is incorrect
                //By default we must hide it
                 //When login is not true then display the message
                 isLoginTrue? Text("Username or password is incorrect",style: TextStyle(color: Colors.red.shade900),):const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}