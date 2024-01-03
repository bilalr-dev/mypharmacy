// lib/screens/pharmacies_screen.dart
import 'package:flutter/material.dart';
import '../widgets/pharmacies_body.dart';
import '../data/pharmacies_data.dart';
import '../models/pharmacies.dart';

class PharmaciesScreen extends StatefulWidget {
  @override
  _PharmaciesScreenState createState() => _PharmaciesScreenState();
}

class _PharmaciesScreenState extends State<PharmaciesScreen> {
  late Future<List<Pharmacy>> pharmacies;

  @override
  void initState() {
    super.initState();
    // Initializing 'pharmacies' Future with the result of loading pharmacies data
    pharmacies = PharmaciesData.loadPharmacies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar customization
        title: Text(
          'صيدليات الحراسة', // App bar title in Arabic
          style: TextStyle(
            color: Colors.teal, // Use teal color for app bar title
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white, // White app bar background
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Pharmacy>>(
          future: pharmacies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Display an error message if data loading fails
              return Center(
                child: Text(
                  'Error loading pharmacies',
                  style: TextStyle(
                    color: Colors.red, // Use red color for error text
                    fontSize: 18.0,
                  ),
                ),
              );
            } else {
              // Display the pharmacies using the PharmaciesBody widget
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: PharmaciesBody(pharmacies: snapshot.data!),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
