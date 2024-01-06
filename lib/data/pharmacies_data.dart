// lib/data/pharmacies_data.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pharmacies.dart';

class PharmaciesData {
  // Method to load pharmacies data from a JSON file
  static Future<List<Pharmacy>> loadPharmacies() async {
    try {
      // Step 1: Loading JSON data from the assets
      print('Loading pharmacies data...');
      String jsonString =
          await rootBundle.loadString('assets/data/pharmacies.json');
      print('JSON loaded successfully: $jsonString');

      // Step 2: Decoding JSON string into a list of dynamic objects
      List<dynamic> jsonList = json.decode(jsonString);
      print('JSON decoded successfully: $jsonList');

      // Step 3: Mapping JSON objects to Pharmacy objects
      List<Pharmacy> pharmacies = jsonList.map((json) {
        return Pharmacy(
          name: json['name'],
          address: json['address'],
          ownerName: json['owner_name'],
          phoneNumber: json['phone_number'],
          latitude: json['lat'],
          longitude: json['lon'],
          otherInfo: json['other_info'],
          distance: json['distance'],
        );
      }).toList();
      print('Pharmacies created successfully: $pharmacies');

      // Step 4: Returning the list of Pharmacy objects
      return pharmacies;
    } catch (error) {
      // Error handling: Print error message and rethrow the error
      print('Error loading pharmacies: $error');
      rethrow;
    }
  }
}
