// lib/widgets/pharmacies_body.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pharmacy_details_dialog.dart';
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
    return ListView.separated(
      key: key,
      itemCount: pharmacies.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        return buildPharmacyListItem(context, pharmacies[index]);
      },
    );
  }

  Widget buildPharmacyListItem(BuildContext context, Pharmacy pharmacy) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(
          pharmacy.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pharmacy.address,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'الهاتف:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  width: 1,
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
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _launchPhone(pharmacy.phoneNumber);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                  ),
                  child: Text(
                    'اتصال',
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ],
        ),
        onLongPress: () {
          _showContextMenu(context, pharmacy);
        },
      ),
    );
  }

  void _showPharmacyDetails(BuildContext context, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PharmacyDetailsDialog(pharmacy: pharmacy);
      },
    );
  }

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

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ المعلومات'),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    String uri = 'tel:$phoneNumber';
    try {
      await launch(uri);
    } catch (e) {
      print('Could not launch $uri: $e');
    }
  }
}
