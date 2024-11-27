import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBulbOn = false; // Local state for bulb
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('bulbState'); // Firebase reference to 'bulbState'

  @override
  void initState() {
    super.initState();

    // Listen to changes from the Firebase Realtime Database
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        isBulbOn = data == 'on'; // Update the bulb state based on Firebase value
      });
    });
  }

  // Function to toggle the bulb state and update Firebase
  void _toggleBulb() {
    setState(() {
      isBulbOn = !isBulbOn; // Toggle the bulb locally
    });

    // Update the Firebase Realtime Database
    _dbRef.set(isBulbOn ? 'on' : 'off');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Bulb Switcher'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bulb representation
            Icon(
              Icons.lightbulb,
              size: 150,
              color: isBulbOn ? Colors.yellow[700] : Colors.grey[700],
            ),
            const SizedBox(height: 50),
            // Toggle Button
            ElevatedButton(
              onPressed: _toggleBulb, // Call the function to toggle the bulb
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: isBulbOn ? Colors.redAccent : Colors.green,
              ),
              child: Text(
                isBulbOn ? 'Turn OFF' : 'Turn ON',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
