import 'package:flutter/material.dart';
import 'package:licencjat/Button/MyButton.dart';
import 'package:licencjat/Components/textField.dart';
import 'package:licencjat/services/authenthication/autoryzacja.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void register() async {
    final _authService = Authorize();

    if (emailController.text.isEmpty ||
        passController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorDialog("Please fill in all fields.");
      return;
    }

    if (passController.text != confirmPasswordController.text) {
      showErrorDialog("Passwords do not match.");
      return;
    }

    if (passController.text.length < 6) {
      showErrorDialog("Password must be at least 6 characters long.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authService.registerWithEmailPass(emailController.text, passController.text);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Account created successfully! Please log in."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
      widget.onTap?.call();
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
        title: const Text("Error"),
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
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_person_rounded, size: 100, color: Colors.white),
                  const SizedBox(height: 25),
                  const Text("Create an account", style: TextStyle(fontSize: 18, color: Colors.white)),
                  const SizedBox(height: 30),
                  MyTextField(controller: emailController, hintText: "Email", obscureText: false),
                  const SizedBox(height: 15),
                  MyTextField(controller: passController, hintText: "Password", obscureText: true),
                  const SizedBox(height: 15),
                  MyTextField(controller: confirmPasswordController, hintText: "Confirm Password", obscureText: true),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(text: "Sign up", onTap: register),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Sign in",
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