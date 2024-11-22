import 'package:flutter/material.dart';
import 'package:projekakhirpam_124220134/JSON/users.dart';
import 'package:projekakhirpam_124220134/componen/button.dart';
import 'package:projekakhirpam_124220134/componen/color.dart';
import 'package:projekakhirpam_124220134/componen/textfield.dart';
import 'package:projekakhirpam_124220134/views/login.dart';

import '../SQLite/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  //Controllers
  final fullname = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper();
  signUp()async{
    var res = await db.createUser(Users(fullname: fullname.text,email: email.text,usrName: usrName.text, password: password.text));
    if(res>0){
      if(!mounted)return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
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
               const Padding(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                 child: Text("Register New Account",style: TextStyle(color: primaryColor,fontSize: 55,fontWeight: FontWeight.bold),),
               ),

                const SizedBox(height: 20),
                InputField(hint: "Full name", icon: Icons.person, controller: fullname),
                InputField(hint: "Email", icon: Icons.email, controller: email),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password,passwordInvisible: true),
                InputField(hint: "Re-enter password", icon: Icons.lock, controller: confirmPassword,passwordInvisible: true),

                const SizedBox(height: 10),
                Button(label: "SIGN UP", press: (){
                  signUp();
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                        },
                        child: Text("LOGIN"))
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}