// lib/widgets/pharmacies_body.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pharmacy_details_dialog.dart'; // Import the custom dialog for pharmacy details
import '../models/pharmacies.dart';

class PharmaciesBody extends StatelessWidget {
  final List<Pharmacy> pharmacies;
  final Key? key;

  const PharmaciesBody({
    required this.pharmacies,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    // Build a ListView to display the list of pharmacies
    return ListView.separated(
      key: key,
      itemCount: pharmacies.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: 8), // Add spacing between pharmacy items
      itemBuilder: (context, index) {
        return buildPharmacyListItem(
            context, pharmacies[index]); // Build each pharmacy item
      },
    );
  }

  // Method to build the UI for each pharmacy item
  Widget buildPharmacyListItem(BuildContext context, Pharmacy pharmacy) {
    return Card(
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.asset(
          'assets/pharmacy.png', // Placeholder image for each pharmacy
          width: 40,
          height: 40,
        ),
        title: SelectableText(
          pharmacy.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              pharmacy.address,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                SelectableText(
                  'الهاتف:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                    width:
                        1), // Adjust the spacing between the label and the phone number
                SelectableText(
                  '${pharmacy.phoneNumber}',
                  textDirection:
                      TextDirection.ltr, // Set text direction to left-to-right
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showPharmacyDetails(context, pharmacy),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    'مزيد من المعلومات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onLongPress: () {
          _showContextMenu(context, pharmacy);
        },
      ),
    );
  }

  // Method to show a dialog with additional pharmacy details
  void _showPharmacyDetails(BuildContext context, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PharmacyDetailsDialog(pharmacy: pharmacy);
      },
    );
  }

  // Method to show a context menu with options related to the selected pharmacy
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

  // Method to copy text to the clipboard and show a Snackbar
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ المعلومات'),
      ),
    );
  }
}
