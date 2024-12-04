import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote =
      'The only way to do great Flutter-Apps is to love what you code.';
  String author = "Andreas D.";

  @override
  void initState() {
    super.initState();
    getSavedQuote();
  }

  Future<void> getSavedQuote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      quote = prefs.getString('quote') ?? quote;
      author = prefs.getString('author') ?? author;
    });
  }

  Future<void> saveQuote(String quote, String author) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote', quote);
    await prefs.setString('author', author);
  }

  Future<void> deleteQuote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quote');
    await prefs.remove('author');
    setState(() {
      quote = 'The only way to do great Flutter-Apps is to love what you code.';
      author = "Andreas D.";
    });
  }

  Future<void> fetchQuote() async {
    const String apiUrl = 'https://api.api-ninjas.com/v1/quotes';
    const String apiKey = 'TytJONjNGfrSCo1kEFtEYQ==NXDFd1ZODlxkxTV3';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          setState(() {
            quote = data[0]['quote'] as String;
            author = data[0]['author'] as String;
          });
          await saveQuote(quote, author);
        }
      } else {
        setState(() {
          quote = "Error at loading new Quote";
          author = "";
        });
      }
    } catch (e) {
      setState(() {
        quote = "ERROR TRY AGAIN";
        author = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '"$quote"',
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            author.isNotEmpty ? ' $author' : '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: fetchQuote,
            child: const Text('More Quotes'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: deleteQuote,
            child: const Text('Delete Saved Quote'),
          ),
        ],
      ),
    );
  }
}
