import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:licencjat/themeprovier/themeprovider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: isDarkMode ? Colors.red : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode
                ? "assets/background2.jpg"
                : "assets/background3.jpg"),
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                : null,
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.transparent),
              margin: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  CupertinoSwitch(
                    value: isDarkMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
