import 'package:flutter/material.dart';
import 'package:licencjat/Button/MyButton.dart';
import 'package:licencjat/Components/textField.dart';
import 'package:licencjat/pages/HomePage.dart';
import 'package:licencjat/services/authenthication/autoryzacja.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool isLoading = false;

  void login() async {
    final _authorize = Authorize();

    if (emailController.text.isEmpty || passController.text.isEmpty) {
      showErrorDialog("Please fill in all fields.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authorize.signInWithEmailPass(emailController.text, passController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/background.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Efekt przyciemnienia tła
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_open_rounded, size: 100, color: Colors.white),
                  const SizedBox(height: 25),
                  const Text("Welcome Back!", style: TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 30),
                  MyTextField(controller: emailController, hintText: "Email", obscureText: false),
                  const SizedBox(height: 15),
                  MyTextField(controller: passController, hintText: "Password", obscureText: true),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(text: "Sign in", onTap: login),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Register now",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
