import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:licencjat/pages/HomePage.dart';
import 'package:licencjat/services/authenthication/LoginOrRegister.dart';

class LogOrNot extends StatelessWidget {
  const LogOrNot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return const HomePage();
            }

            else {
              return const LoginorSignUp();
            }

          }

      ),
    );
  }
}
