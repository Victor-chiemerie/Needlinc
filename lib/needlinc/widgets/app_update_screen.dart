import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:needlinc/needlinc/backend/functions/launch_url.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UpdateScreen(),
    );
  }
}

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/Logo.png',
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Update Available',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            // Description
            Text(
              'A new version of the app is available with exciting new features and improvements. Please update to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // Update Button
            ElevatedButton(
              onPressed: () {
                // Implement update action
                launch_Url(Uri.parse('https://play.google.com/store/apps/details?id=com.needlinc.needlinc'), false);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Update Now',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Dismiss Option
            TextButton(
              onPressed: () {
                // Implement dismiss action
                SystemNavigator.pop();
              },
              child: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

