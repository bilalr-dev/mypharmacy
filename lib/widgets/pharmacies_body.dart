// Importing necessary libraries
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

// Importing custom models and widgets
import '../models/pharmacies.dart';
import 'pharmacy_details_dialog.dart';

// Main widget for displaying a list of pharmacies
class PharmaciesBody extends StatefulWidget {
  final List<Pharmacy> pharmacies;
  final Key? key;

  const PharmaciesBody({
    required this.pharmacies,
    this.key,
  });

  @override
  _PharmaciesBodyState createState() => _PharmaciesBodyState();
}

class _PharmaciesBodyState extends State<PharmaciesBody> {
  @override
  Widget build(BuildContext context) {
    // Displaying a scrollable list of pharmacies
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var pharmacy in widget.pharmacies)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PharmacyListItem(pharmacy: pharmacy),
            ),
        ],
      ),
    );
  }
}

// Widget for displaying details of a pharmacy
class PharmacyListItem extends StatefulWidget {
  final Pharmacy pharmacy;

  const PharmacyListItem({
    required this.pharmacy,
  });

  @override
  _PharmacyListItemState createState() => _PharmacyListItemState();
}

class _PharmacyListItemState extends State<PharmacyListItem> {
  double distance = 0.0;

  @override
  void initState() {
    super.initState();
    // Calculate and set the distance when the widget is initialized
    _calculateDistance();
  }

  // Asynchronous function to calculate the distance to the pharmacy
  Future<void> _calculateDistance() async {
    try {
      double newDistance = await LocationUtils.calculateDistance(
        widget.pharmacy.latitude,
        widget.pharmacy.longitude,
      );

      // Update the distance and trigger a rebuild
      setState(() {
        distance = newDistance;
      });
    } catch (e) {
      // Log an error if distance calculation fails
      print('Error calculating distance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Displaying a pharmacy as a card
    return Card(
      elevation: 3,
      child: _buildPharmacyListTile(context),
    );
  }

  // Building the ListTile for displaying pharmacy details
  ListTile _buildPharmacyListTile(BuildContext context) {
    return ListTile(
      title: Text(
        widget.pharmacy.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: _buildPharmacySubtitle(),
      onLongPress: () {
        // Show a context menu on long-press
        _showContextMenu(context, widget.pharmacy);
      },
    );
  }

  // Building the subtitle of the pharmacy, including address, phone, distance, and actions
  Column _buildPharmacySubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.pharmacy.address,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 4),
        // Displaying phone number with copy-to-clipboard functionality
        PharmacyInfoRow(
          label: 'الهاتف:',
          value: widget.pharmacy.phoneNumber,
          textDirectionValue: TextDirection.ltr,
          onCopyTap: () {
            _copyToClipboard(context, widget.pharmacy.phoneNumber);
          },
        ),
        const SizedBox(height: 4),
        // Displaying distance with right-to-left text direction
        PharmacyInfoRow(
          label: 'المسافة الفاصلة: ',
          value: '${distance.toStringAsFixed(2)} م',
          textDirectionValue: TextDirection.rtl,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            // Show detailed information on tap
            _showPharmacyDetails(context, widget.pharmacy);
          },
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                'مزيد من المعلومات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Row of action buttons for map location and phone call
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionButton(
              onPressed: () {
                // Open the map to the pharmacy's location
                LocationUtils.goToMap(
                  widget.pharmacy.latitude,
                  widget.pharmacy.longitude,
                );
              },
              icon: Icons.location_on,
              label: 'الموقع على الخريطة',
            ),
            ActionButton(
              onPressed: () {
                // Initiate a phone call
                _launchPhone(widget.pharmacy.phoneNumber);
              },
              icon: Icons.phone,
              label: 'اتصال',
            ),
          ],
        ),
      ],
    );
  }

  // Show a context menu with options for copying information
  void _showContextMenu(BuildContext context, Pharmacy pharmacy) {
    final String fullInfo = '''
      ${pharmacy.name}
      العنوان: ${pharmacy.address}
      الهاتف: ${pharmacy.phoneNumber}
      مزيد من المعلومات: ${pharmacy.otherInfo}
      ''';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('نسخ المعلومات'),
                onTap: () {
                  // Copy the information to the clipboard
                  Navigator.pop(context);
                  _copyToClipboard(context, fullInfo);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Copy the given text to the clipboard and show a snackbar
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ الرقم'),
      ),
    );
  }

  // Show a dialog with detailed information about the pharmacy
  void _showPharmacyDetails(BuildContext context, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PharmacyDetailsDialog(pharmacy: pharmacy);
      },
    );
  }

  // Initiate a phone call with the given phone number
  void _launchPhone(String phoneNumber) async {
    String uri = 'tel:$phoneNumber';
    try {
      await launch(uri);
    } catch (e) {
      print('Could not launch $uri: $e');
    }
  }
}

// Widget for displaying a row of information with label and value
class PharmacyInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onCopyTap;
  final TextDirection? textDirectionValue;

  const PharmacyInfoRow({
    required this.label,
    required this.value,
    this.onCopyTap,
    this.textDirectionValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(width: 1),
        Directionality(
          textDirection: textDirectionValue ?? TextDirection.rtl,
          child: GestureDetector(
            onTap: onCopyTap,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget for displaying an action button with icon and label
class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonPadding = 8.0;
    const double iconSize = 16.0;

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        padding: EdgeInsets.all(buttonPadding),
      ),
      icon: Icon(icon, size: iconSize),
      label: Text(
        label,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}

// Utility class for location-related functions
class LocationUtils {
  // Calculate the distance between two coordinates on Earth
  static Future<double> calculateDistance(
      double pharmacyLatitude, double pharmacyLongitude) async {
    try {
      Position? userLocation = await getUserLocation();

      if (userLocation != null) {
        const double earthRadius = 6371.0; // Earth's radius in kilometers

        double dLat = radians(userLocation.latitude - pharmacyLatitude);
        double dLon = radians(userLocation.longitude - pharmacyLongitude);

        double a = sin(dLat / 2) * sin(dLat / 2) +
            cos(radians(pharmacyLatitude)) *
                cos(radians(userLocation.latitude)) *
                sin(dLon / 2) *
                sin(dLon / 2);

        double c = 2 * atan2(sqrt(a), sqrt(1 - a));

        double distance = earthRadius * c * 1000; // Convert to meters

        return distance;
      } else {
        return 0.0;
      }
    } catch (e) {
      // Log an error if distance calculation fails
      print('Error calculating distance: $e');
      return 0.0;
    }
  }

  // Open the map application to show the given coordinates
  static void goToMap(double latitude, double longitude) async {
    try {
      var url = 'https://www.google.com/maps?q=$latitude,$longitude';
      final Uri _url = Uri.parse(url);
      launchUrl(_url);
    } catch (_) {
      // Log an error if launching map fails
      print("Error launching map");
    }
  }

  // Launch a URL and handle errors
  static void launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      // Log an error if launching URL fails
      print('Could not launch $url');
    }
  }

  // Get the user's current location
  static Future<Position?> getUserLocation() async {
    var isEnable = await checkPermission();

    if (isEnable) {
      try {
        Position location = await Geolocator.getCurrentPosition();
        return location;
      } catch (e) {
        // Log an error if getting user location fails
        print('Error getting user location: $e');
      }
    }

    return null;
  }

  // Check and request location permission
  static Future<bool> checkPermission() async {
    bool isEnable = await Geolocator.isLocationServiceEnabled();

    if (!isEnable) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Convert degrees to radians
  static double radians(double degrees) {
    return degrees * pi / 180.0;
  }
}
