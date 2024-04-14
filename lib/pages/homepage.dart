// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:login_page/compenants/MyButton.dart';
import 'package:login_page/compenants/MyTextField.dart';
import 'package:login_page/pages/loggedPage.dart';
import 'package:login_page/sqldb.dart';

class HomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool isVisible = false;
  bool loginError = false;

  // creating an instance of our class SqlDb after importing it
  SqlDb sqldb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/login.png', height: 180, width: 300),

              SizedBox(
                height: 25,
              ),

              // welcome text
              Text(
                "Connectez-vous !",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),

              SizedBox(
                height: 25,
              ),
              // username textfield
              MyTextField(
                prefixIcon: Icons.email,
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              SizedBox(
                height: 15,
              ),
              // password textField

              MyTextField(
                prefixIcon: Icons.lock,
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),

              // forgot password

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "forgot password?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),

              // signin button

              MyButton(
                TextButton: "Login",
                ButtonColor: Colors.blue[400],
                onPressed: () async {
                  Map<String, dynamic>? userData = await sqldb.loginUser(
                      emailController.text, passwordController.text);
                  if (userData != null) {
                    // If user data is not null, you can handle it as needed, such as storing it or displaying it.
                    // For example, you can set it in a state variable to update UI.
                    setState(() {
                      // Set user data here if needed
                    });
                  } else {
                    setState(() {
                      loginError = true;
                    });
                  }
                },
              ),

              SizedBox(height: 20),

              if (loginError == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 5),
                    Text(
                      'E-mail ou mot de passe incorrect!',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),

              MyButton(
                TextButton: "Create User",
                ButtonColor: Colors.orange,
                onPressed: () async {
                  // print("OK!");
                  int response = await sqldb.insertData(
                      "INSERT INTO 'Utilisateurs' (nom_utilisateur, prenom_utilisateur, email, Role, password) VALUES ('Youssra', 'Ben mokhtar', 'youssra@gmail.com', 'Etudiant', 'youssra')");
                  // ignore: avoid_print
                  print(response);
                },
              ),

              SizedBox(
                height: 10,
              ),

              MyButton(
                TextButton: "Show User",
                ButtonColor: Colors.blue,
                onPressed: () async {
                  List<Map> response =
                      await sqldb.readData("SELECT * FROM 'Utilisateurs' ");
                  // ignore: avoid_print
                  print("$response");
                },
              ),

              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
