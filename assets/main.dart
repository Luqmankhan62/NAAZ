import 'package:flutter/material.dart';
import 'api_bridge.dart';
import 'jarvis_theme.dart';
import 'voice_handler.dart';

void main() {
  runApp(const NaazApp());
}

class NaazApp extends StatelessWidget {
  const NaazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: jarvisTheme,
      home: const NaazChat(),
    );
  }
}

class NaazChat extends StatefulWidget {
  const NaazChat({super.key});

  @override
  State<NaazChat> createState() => _NaazChatState();
}

class _NaazChatState extends State<NaazChat> {
  final TextEditingController _inputCtrl = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;

  void _sendMessage() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _inputCtrl.clear();
      _loading = true;
    });

    try {
      final reply = await ApiBridge.sendMessage(text);
      setState(() {
        _messages.add({'sender': 'naaz', 'text': reply});
        _loading = false;
      });
      VoiceHandler.speak(reply);
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'naaz',
          'text': '⚠️ Connection error — please check Naaz API link.'
        });
        _loading = false;
      });
    }
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blueAccent.withOpacity(0.3)
              : Colors.cyanAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? Colors.blueAccent.withOpacity(0.6)
                  : Colors.cyanAccent.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: Text(
          msg['text'] ?? '',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, height: 1.4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text("NAAZ Interface Chat",
                style: TextStyle(
                    color: Colors.cyanAccent.shade100,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    _buildMessage(_messages[index]),
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.cyanAccent,
                      child: Icon(Icons.send, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
