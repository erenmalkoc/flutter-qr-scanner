import 'package:flutter/material.dart';
import 'package:qr_scanner/qr_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,


        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
          onPrimary: Colors.white,
        ),
      ),
      home: const QrScanScreen(),
    );
  }
}
