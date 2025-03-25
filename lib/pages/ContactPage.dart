import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  String? getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      String? userEmail = getCurrentUserEmail();
      if (userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is logged in')),
        );
        return;
      }

      try {
        final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

        await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': 'service_tfvgxcc',
            'template_id': 'template_vwjespn',
            'user_id': 'rM9OYyiyLfF4bpUbO',
            'template_params': {
              'from_name': 'Car Rental Support',
              'from_email': 'wsparcie.test.carrental@gmail.com',
              'message': _messageController.text,
              'to_email': userEmail,
              'reply_to': 'wsparcie.test.carrental@gmail.com',
              'subject': 'We received your message',
            },
          }),
        );

        // Wysyłanie tej samej wiadomości na Twój e-mail
        await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'service_id': 'service_tfvgxcc',
            'template_id': 'template_vwjespn',
            'user_id': 'rM9OYyiyLfF4bpUbO',
            'template_params': {
              'from_name': 'Car Rental Support',
              'from_email': 'wsparcie.test.carrental@gmail.com',
              'message': _messageController.text,
              'to_email': 'wsparcie.test.carrental@gmail.com',
              'reply_to': userEmail,  // Możesz też przekazać użytkownika jako odpowiadający adres
              'subject': 'New message from user',
            },
          }),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent successfully! We will answer to your case as soon as possible via e-mail')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: isDarkMode ? Colors.red : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode ? "assets/background2.jpg" : "assets/background3.jpg",
            ),
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                : null,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have a question or need support?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Send us a message and we will get back to you as soon as possible.',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelText: 'Your Message',
                            labelStyle: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.message, color: isDarkMode ? Colors.white70 : Colors.black87),
                          ),
                          maxLines: 5,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          validator: (value) => value!.isEmpty ? 'Please enter your message' : null,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.red : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _sendMessage,
                          child: Text(
                            'Send Message',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}