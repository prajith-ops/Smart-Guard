import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_guard/homepage.dart';
import 'package:smart_guard/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? accessToken;
  String? refreshToken;

  // Load tokens from secure storage
  final storage = FlutterSecureStorage();
  accessToken = await storage.read(key: 'access_token');
  refreshToken = await storage.read(key: 'refresh');

  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String? accessToken;
  final String? refreshToken;

  const MyApp({super.key, this.accessToken, this.refreshToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: accessToken != null && refreshToken != null
            ? Homepage(accessToken: accessToken!)
            : Loginpage(),
      ),
    );
  }
}
