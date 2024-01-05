// lib/widgets/pharmacy_details_dialog.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import '../models/pharmacies.dart';

class PharmacyDetailsDialog extends StatelessWidget {
  final Pharmacy pharmacy;

  PharmacyDetailsDialog({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          pharmacy.name,
          textDirection: TextDirection.rtl,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'الهاتف:',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    _copyToClipboard(context, pharmacy.phoneNumber);
                  },
                  child: Text(
                    '${pharmacy.phoneNumber}',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'اسم الصيدلي: ${pharmacy.ownerName}',
              textDirection: TextDirection.rtl,
            ),
            GestureDetector(
              onTap: () {
                goToMap();
              },
              child: Text(
                'الموقع',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'معلومات اخرى: ${pharmacy.otherInfo}',
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text colorolor
                ),
                child: Text(
                  'إغلاق',
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ الرقم'),
      ),
    );
  }

  void goToMap() async {
    try {
      var url =
          'https://www.google.com/maps?q=${pharmacy.latitude},${pharmacy.longitude}';
      final Uri _url = Uri.parse(url);
      await launchUrl(_url);
    } catch (_) {
      print("Error launching map");
    }
  }

  Future<void> launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      print('Could not launch $url');
    }
  }

  Future<bool> checkPermission() async {
    bool isEnable = await Geolocator.isLocationServiceEnabled();

    if (!isEnable) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // If permission is denied, request user to allow permission again
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // If permission is denied again
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

// Get user current location
  Future<Position?> getUserLocation() async {
    var isEnable = await checkPermission();

    if (isEnable) {
      try {
        Position location = await Geolocator.getCurrentPosition();
        return location;
      } catch (e) {
        print('Error getting user location: $e');
      }
    }

    return null;
  }
}
