import 'package:expense_tracker/components/tabs.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(
            255, 97, 127, 229), // Set the background color to red
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/logo1.png',
                height: 150,
              ),
              const Text(
                'My Budget',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the home page when the button is pressed
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TabsController()),
                  );
                },
                child: Text('Let\'s Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
