import 'package:flutter/material.dart';
import 'package:mad_app/screens/register_screen.dart';
import 'home_screen.dart';  

class LoginScreen extends StatelessWidget {

  final String correctUsername = 'abdullah';
  final String correctPassword = '123';

  @override
  Widget build(BuildContext context) {
    // Controllers to capture the input from TextFields
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blue, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,  
          children: [
          
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.blue), 
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),  
                ),
              ),
            ),
            SizedBox(height: 16), 

            // Password TextField
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.blue), 
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),  
                ),
              ),
              obscureText: true, 
            ),
            SizedBox(height: 32), 

            // Login Button
            ElevatedButton(
              onPressed: () {
                // Get user input
                String enteredUsername = emailController.text;
                String enteredPassword = passwordController.text;

                // Check credentials
                if (enteredUsername == correctUsername && enteredPassword == correctPassword) {
                  // If credentials are correct, navigate to Home Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  // If credentials are incorrect, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid email or password')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, 
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16), 

            // Link to the Registration Screen
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()), 
    );
                },
                child: Text(
                  'Don\'t have an account? Register here',
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
