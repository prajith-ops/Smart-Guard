import 'dart:convert';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Lock {
  final int id;
  final String name;
  bool lockStatus;
  String lastUpdated;

  Lock(
      {required this.id,
      required this.name,
      required this.lockStatus,
      required this.lastUpdated});

  factory Lock.fromJson(Map<String, dynamic> json) {
    return Lock(
        id: json['id'],
        name: json['name'],
        lockStatus: json['status'] == 'Locked',
        lastUpdated: json['last_updated']);
  }
}

class ControlCentre extends StatefulWidget {
  ControlCentre({super.key});

  @override
  State<ControlCentre> createState() => _ControlCentreState();
}

class _ControlCentreState extends State<ControlCentre> {
  Future<List<Lock>> fetchLocks() async {
    final response = await http.get(
      Uri.parse('https://smart-guard-webserver.onrender.com/api/Lock/'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      List<Lock> lockList =
          (jsonResponse as List).map((lock) => Lock.fromJson(lock)).toList();
      lockList.sort((a, b) {
        return a.id.compareTo(b.id);
      });
      return lockList;
    } else {
      throw Exception('Failed to fetch locks');
    }
  }

  void changeLockStatus() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            "Control Centre",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: CupertinoColors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Lock>>(
              future: fetchLocks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot);
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data != null) {
                  List<Lock> locks = snapshot.data!;
                  return ListView.builder(
                    itemCount: locks.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              locks[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              child: IconTheme.merge(
                                data: IconThemeData(color: Colors.white),
                                child: AnimatedToggleSwitch.dual(
                                  current: locks[index].lockStatus,
                                  first: false,
                                  second: true,
                                  spacing: 45,
                                  animationDuration:
                                      Duration(milliseconds: 600),
                                  style: const ToggleStyle(
                                    borderColor: Colors.transparent,
                                    indicatorColor: Colors.white,
                                    backgroundColor: Colors.black,
                                  ),
                                  customStyleBuilder: (context, local, global) {
                                    if (global.position <= 0) {
                                      return ToggleStyle(
                                        backgroundColor: Colors.red[800],
                                      );
                                    }
                                    return ToggleStyle(
                                        backgroundGradient:
                                            LinearGradient(colors: [
                                      Colors.green,
                                      Colors.red[800]!
                                    ], stops: [
                                      global.position -
                                          (1 -
                                                  2 *
                                                      max(
                                                          0,
                                                          global.position -
                                                              0.5)) *
                                              0.7,
                                      global.position +
                                          max(0, 2 * (global.position - 0.5)) *
                                              0.7
                                    ]));
                                  },
                                  borderWidth: 6,
                                  height: 60,
                                  loadingIconBuilder: (context, global) =>
                                      CupertinoActivityIndicator(
                                    color: Color.lerp(Colors.red[800],
                                        Colors.green, global.position),
                                  ),
                                  onChanged: (value) => changeLockStatus(),
                                  iconBuilder: (value) => value
                                      ? const Icon(
                                          Icons.lock,
                                          color: Colors.green,
                                          size: 32,
                                        )
                                      : Icon(
                                          Icons.lock_open_rounded,
                                          color: Colors.red[800],
                                          size: 32,
                                        ),
                                  textBuilder: (value) => value
                                      ? const Center(
                                          child: Text("Locked"),
                                        )
                                      : Center(
                                          child: Text("Open"),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No locks found"));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
