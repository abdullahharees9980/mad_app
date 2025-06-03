import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();

  String? gender;
  String? country;
  bool agree = false;
  DateTime? dob;

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dob = picked;
      });
    }
  }

  void register() {
    if (formKey.currentState!.validate()) {
      if (pass.text != confirmPass.text) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Passwords not same")));
        return;
      }
      if (!agree) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please agree to terms")));
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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
                controller: username,
                decoration: InputDecoration(labelText: "Username"),
                validator: (v) => v!.isEmpty ? "Enter username" : null,
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: pass,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Enter password" : null,
              ),
              TextFormField(
                controller: confirmPass,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (v) => v!.isEmpty ? "Confirm password" : null,
              ),
              SizedBox(height: 10),

              // Gender radio
              Row(
                children: [
                  Text("Gender: "),
                  Radio(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (val) => setState(() => gender = val),
                  ),
                  Text("Male"),
                  Radio(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (val) => setState(() => gender = val),
                  ),
                  Text("Female"),
                ],
              ),

              // Country dropdown
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Country"),
                value: country,
                items: ["Malaysia", "Singapore", "Thailand","Sri Lanka","UAE","Qatar"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => country = val),
                validator: (val) => val == null ? "Choose country" : null,
              ),

              // Date of Birth
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dob == null
                      ? "Pick Date of Birth"
                      : "DOB: ${dob!.day}/${dob!.month}/${dob!.year}"),
                  TextButton(onPressed: pickDate, child: Text("Pick Date")),
                ],
              ),

              // Agree checkbox
              CheckboxListTile(
                title: Text("I agree to terms"),
                value: agree,
                onChanged: (val) => setState(() => agree = val!),
              ),

              SizedBox(height: 10),
              ElevatedButton(onPressed: register, child: Text("Register")),
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
