import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'api_handler.dart';
import 'dart:typed_data';

class ChatTextToImagePage extends StatefulWidget {
  const ChatTextToImagePage({super.key});

  @override
  _ChatTextToImagePageState createState() => _ChatTextToImagePageState();
}

class _ChatTextToImagePageState extends State<ChatTextToImagePage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  void _generateImage() async {
    final String userMessage = _textController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.add({'text': userMessage, 'isUser': true});
      _textController.clear();
    });

    try {
      final Uint8List imageBytes = await ApiHandler.generateImage(userMessage);
      setState(() {
        _isLoading = false;
        _messages.add({
          'text': "Here's your generated image:",
          'isUser': false,
          'imageBytes': imageBytes,
        });
      });
    } catch (error) {
      _handleError(error.toString());
    }
  }

  void _handleError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $errorMessage")),
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade300,
              const Color.fromARGB(255, 255, 83, 192)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Text(
                  'Text-to-Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: Colors.white70, height: 1),

              // Chat Messages
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - 1 - index];
                    final bool isUser = message['isUser'];

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blueAccent : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isUser
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isUser
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                              ),
                            ),
                            if (message['imageBytes'] != null) ...[
                              const SizedBox(height: 8),
                              Image.memory(
                                message['imageBytes'],
                                fit: BoxFit.contain,
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Loading Indicator
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),

              const Divider(color: Colors.white70, height: 1),

              // Input Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Text Input
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Enter a description...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Send Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _generateImage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}