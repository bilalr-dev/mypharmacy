// lib/widgets/pharmacy_details_dialog.dart
import 'package:flutter/material.dart';
import '../models/pharmacies.dart';

class PharmacyDetailsDialog extends StatelessWidget {
  final Pharmacy pharmacy;

  PharmacyDetailsDialog({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    // Directionality widget ensures correct text direction for RTL languages
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
            // Display pharmacy address
            Text(
              'العنوان: ${pharmacy.address}',
              textDirection: TextDirection.rtl,
            ),
            // Display phone number with label
            Row(
              children: [
                Text(
                  'الهاتف:',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(width: 8),
                Text(
                  '${pharmacy.phoneNumber}',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 4),
            // Display pharmacy location
            Text(
              'الموقع: ${pharmacy.address}',
              textDirection: TextDirection.rtl,
            ),
            // Display latitude information
            Row(
              children: [
                Text(
                  'خط العرض:',
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(width: 4),
                Text(
                  '${pharmacy.latitude}',
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            // Display longitude information
            Row(
              children: [
                Text(
                  'خط الطول:',
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(width: 4),
                Text(
                  '${pharmacy.longitude}',
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            // Display owner's name
            Text(
              'اسم الصيدلي: ${pharmacy.ownerName}',
              textDirection: TextDirection.rtl,
            ),
            // Add more details as needed
          ],
        ),
        actions: [
          // Close button to dismiss the dialog
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إغلاق',
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
