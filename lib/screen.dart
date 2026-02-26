import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'datalistview.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final databasereference = FirebaseDatabase.instanceFor(
    databaseURL: "https://appfirebase2-96e60-default-rtdb.firebaseio.com/",
    app: Firebase.app(),
  ).ref();

  final _formKey = GlobalKey<FormState>();

  void saveData() {
    final email = emailController.text;
    final name = nameController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      databasereference
          .child('items')
          .push()
          .set({'name': name, 'email': email})
          .then((_) {
            emailController.clear();
            nameController.clear();
          });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF2EC),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: _inputDecoration("Enter your email"),
                            validator: (value) =>
                                value!.isEmpty ? 'Email is required' : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: nameController,
                            decoration: _inputDecoration("Enter your name"),
                            validator: (value) =>
                                value!.isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CA6A8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  saveData();
                                }
                              },
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),

                  SizedBox(height: 400, child: const Datalistview()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
    );
  }
}
