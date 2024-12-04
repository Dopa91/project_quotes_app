import 'package:flutter/material.dart';
import 'package:project_quotes_app/quote_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quotes-App'),
        ),
        body: const QuoteScreen(),
      ),
    );
  }
}
