import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smart_guard/homepage.dart';
import 'package:smart_guard/signup_page.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});

  Future<void> login(BuildContext context, id, String password) async {
    final response = http.post(
      Uri.parse("https://smart-guard-webserver.onrender.com/api/login/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "username": id,
        "password": password,
      }),
    );

    return response.then((response) async {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        const storage = FlutterSecureStorage();
        await storage.write(key: 'refresh', value: data['refresh']);
        await storage.write(key: 'access_token', value: data['access']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
                accessToken: data['access'], refreshToken: data['refresh']),
          ),
        );
        return;
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login, check ID and password')),
        );
        throw Exception('Failed to login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in Login')),
        );
        throw Exception('Error in login');
      }
    }).catchError((e) {
      throw Exception('Error in login ${e}');
    });
  }

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 150),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smart Guard",
                    style: GoogleFonts.protestStrike(fontSize: 50),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 90),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextField(
                          controller: idController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "ID",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey[300]),
                          )),
                      SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 40),
                            backgroundColor: Colors.blue[300],
                          ),
                          onPressed: () {
                            String id = idController.text;
                            String password = passwordController.text;

                            login(context, id, password);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(150, 40),
                            side: BorderSide(
                              width: 2,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
