import 'package:flutter/material.dart';
import 'package:licencjat/pages/loginpage.dart';
import 'package:licencjat/pages/registerPage.dart';


class LoginorSignUp extends StatefulWidget {
  const LoginorSignUp({super.key});

  @override
  State<LoginorSignUp> createState() => _LoginorSignUpState();
}

class _LoginorSignUpState extends State<LoginorSignUp> {
  bool showLoginPage = true;


  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }



  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages);

    } else{
      return RegisterPage(onTap: togglePages);
    }
  }

}

