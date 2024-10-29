import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_guard/controlcentre.dart';
import 'package:smart_guard/doorstatus.dart';
import 'package:smart_guard/livevideo.dart';

class Homepage extends StatelessWidget {
  final String? accessToken;
  final String? refreshToken;

  const Homepage({super.key, this.accessToken, this.refreshToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            "Smart Guard",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: CupertinoColors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            )
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ControlCentre()),
              );
            },
            icon: Icon(Icons.menu),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 40),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(300, 100),
                      side: BorderSide(width: 2, color: Colors.lightBlueAccent),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoorStatus()),
                      );
                    },
                    child: Text(
                      "Door Status",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(300, 100),
                      side: BorderSide(width: 2, color: Colors.lightBlueAccent),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ControlCentre(),
                        ),
                      );
                    },
                    child: Text(
                      "Control Centre",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(300, 100),
                          side: BorderSide(
                              width: 2, color: Colors.lightBlueAccent)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LiveVideo()),
                        );
                      },
                      child: Text(
                        "Live Video Feed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey[600]),
                      )),
                ),
                SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(300, 100),
                      side: BorderSide(width: 2, color: Colors.lightBlueAccent),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Alert Notification",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
