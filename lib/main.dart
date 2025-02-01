import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelegramClient extends StatefulWidget {
  @override
  _TelegramClientState createState() => _TelegramClientState();
}

class _TelegramClientState extends State<TelegramClient> {
  TextEditingController _botTokenController = TextEditingController();
  TextEditingController _chatIdController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  List<String> sentMessages = []; // To store sent messages

  // Function to send message using the provided bot token
  Future<void> sendMessage(String botToken, String chatId, String text) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');

    final response = await http.post(
      url,
      body: {
        'chat_id': chatId,
        'text': text,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        sentMessages.add('Sent to $chatId: $text'); // Store sent messages
      });
      print('Message sent successfully!');
    } else {
      print('Failed to send message');
    }
  }

  // This will keep the form in a loop-like behavior for new input
  void sendMessageAndKeepInput() {
    String botToken = _botTokenController.text;
    String chatId = _chatIdController.text;
    String message = _messageController.text;

    if (botToken.isNotEmpty && chatId.isNotEmpty && message.isNotEmpty) {
      sendMessage(botToken, chatId, message);

      // Do not clear Chat ID and Message fields, keep them ready for new input
    } else {
      print('Please enter Bot Token, Chat ID, and Message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Telegram Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Input field for Bot Token
            TextField(
              controller: _botTokenController,
              decoration: InputDecoration(
                labelText: 'Enter Bot Token',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Input field for Chat ID (numeric values accepted)
            TextField(
              controller: _chatIdController,
              keyboardType:
                  TextInputType.number, // This will only allow numeric input
              decoration: InputDecoration(
                labelText: 'Enter Numeric Chat ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Input field for message text
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendMessageAndKeepInput(); // Do not clear Chat ID and Message fields
              },
              child: Text('Send Message'),
            ),
            SizedBox(height: 20),
            Text('Messages Sent:'),
            // Display sent messages
            Expanded(
              child: ListView.builder(
                itemCount: sentMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(sentMessages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TelegramClient(),
  ));
}
