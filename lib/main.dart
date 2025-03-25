import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:licencjat/services/authenthication/LoggedinOrNot.dart';
import 'package:licencjat/firebase_options.dart';
import 'package:licencjat/pages/registerPage.dart';
import 'package:licencjat/test.dart';
import 'package:licencjat/themeprovier/themeprovider.dart';
import 'package:provider/provider.dart';
import 'package:licencjat/pages/loginpage.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Używamy context.watch do nasłuchiwania na zmiany w ThemeProvider
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LogOrNot(),
      theme: context.watch<ThemeProvider>().themeData, // Dynamiczne przypisanie motywu
    );
  }
}
