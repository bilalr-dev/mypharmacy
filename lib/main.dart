import 'package:flutter/material.dart';
import 'screens/pharmacies_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Almarai',
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.teal,
          ),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: PharmaciesScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
