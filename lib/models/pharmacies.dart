// lib/models/pharmacies.dart
class Pharmacy {
  // Properties of a Pharmacy
  final String name;
  final String address;
  final String ownerName;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String otherInfo;
  final double distance;

  // Constructor to initialize a Pharmacy object
  Pharmacy({
    required this.name,
    required this.address,
    required this.ownerName,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.otherInfo,
    required this.distance,
  });

  // Factory constructor to create a Pharmacy object from JSON data
  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      // Extracting values from the JSON map and initializing properties
      name: json['name'],
      address: json['address'],
      ownerName: json['owner_name'],
      phoneNumber: json['phone_number'],
      latitude: json['lat']?.toDouble() ?? 0.0,  // Convert latitude to double, default to 0.0 if not present
      longitude: json['lon']?.toDouble() ?? 0.0, // Convert longitude to double, default to 0.0 if not present
      otherInfo: json['other_info'],
      distance: json['distance']?.toDouble() ?? 0.0, // Convert distance to double, default to 0.0 if not present
    );
  }
}
