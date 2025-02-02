import 'package:flutter/material.dart';
import 'chat_text_to_image_page.dart';

void main() {
  runApp(const ChatTextToImageApp());
}

class ChatTextToImageApp extends StatelessWidget {
  const ChatTextToImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatTextToImagePage(),
    );
  }
}