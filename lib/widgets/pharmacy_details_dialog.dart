import 'dart:math';

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
            buildInfoRow('الهاتف:', pharmacy.phoneNumber, onTap: () {
              _copyToClipboard(context, pharmacy.phoneNumber);
            }),
            buildInfoRow('اسم الصيدلي:', pharmacy.ownerName),
            buildInfoRow('معلومات اخرى:', pharmacy.otherInfo),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildActionButton('إغلاق', Colors.blue, () {
                Navigator.of(context).pop();
              }, icon: Icons.close),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            label,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(width: 4),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildActionButton(String text, Color color, VoidCallback onPressed,
      {IconData? icon}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 18, color: Colors.white),
          SizedBox(width: icon != null ? 4 : 0),
          Text(
            text,
            textDirection: TextDirection.rtl,
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

  Future<void> launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      print('Could not launch $url');
    }
  }
}
