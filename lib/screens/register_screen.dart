import 'package:flutter/material.dart';
import 'package:mad_app/auth_service.dart';  
import 'home_screen.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(); 
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  Future<void> _register() async {
    if (formKey.currentState!.validate()) {
      if (passController.text != confirmPassController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      try {
        final token = await AuthService().register(
          nameController.text,
          emailController.text,
          passController.text,
          // role: 'user',  
        );
        if (token != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Enter password" : null,
              ),
              TextFormField(
                controller: confirmPassController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Confirm password" : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _register, child: Text("Register")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Already have an account? Login here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
