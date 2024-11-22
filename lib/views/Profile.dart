import 'package:flutter/material.dart';

import 'package:projekakhirpam_124220134/JSON/users.dart';
import 'package:projekakhirpam_124220134/SQLite/database_helper.dart';
import 'package:projekakhirpam_124220134/componen/button.dart';
import 'package:projekakhirpam_124220134/componen/color.dart';
import 'package:projekakhirpam_124220134/views/beranda.dart';
import 'package:projekakhirpam_124220134/views/login.dart';

class Profile extends StatelessWidget {
  final Users? profile;
  Profile({super.key, this.profile});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      
        body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45.0,horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 77,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/no_user.jpg"),
                  radius: 75,
                ),
              ),

              const SizedBox(height: 10),
              Text(profile!.usrName??"",style: const TextStyle(fontSize: 28,color: primaryColor),),
              Text(profile!.email??"",style: const TextStyle(fontSize: 17,color: Colors.grey),),

              Button(label: "SIGN UP", press: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
              }),

              ListTile(
                leading: const Icon(Icons.account_circle,size: 30),
                subtitle: Text(profile!.usrName),
                title: const Text("Username"),
              ),

               ListTile(
                leading: const Icon(Icons.email,size: 30),
                subtitle: Text(profile!.email??""),
                title: const Text("Email"), 
              ),
          ],
        ),
            )),
      ),
    );
  }
}