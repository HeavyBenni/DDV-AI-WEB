import 'package:flutter/material.dart';
import 'package:ddv_gpt/backend/chat.dart'; // Import the backend

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ChatBackend chatBackend = ChatBackend(); // Instantiate backend class

  void clearChat() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25, right: 25, left: 25),
      color: Color.fromARGB(255, 247, 247, 247),
      child: Container(
        padding: EdgeInsets.only(top: 100, right: 100, left: 100, bottom: 30),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    Colors.grey.withOpacity(0.5), // Shadow color with opacity
                offset: Offset(0, 2), // Offset of the shadow
                blurRadius: 4, // Spread radius
                spreadRadius: 1, // Blur radius
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 232, 241, 250), // Starting color (bottom)
                Colors.white, // Ending color (top)
              ],
              stops: [0.0, 0.5], // Optional stops for the gradient
            ),
            borderRadius: (BorderRadius.circular(10))),
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final String content = message['content'];
                  final bool isUserMessage = message['role'] == 'user';

                  return Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Row(
                      mainAxisAlignment: isUserMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.5), // Shadow color with opacity
                                offset: Offset(0, 2), // Offset of the shadow
                                blurRadius: 4, // Spread radius
                                spreadRadius: 1, // Blur radius
                              ),
                            ],
                            color: isUserMessage
                                ? Color(0xFFA9D3F2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            content,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: 45,
          child: Container(
              margin: EdgeInsets.only(right: 20),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF7FD5D5), // Left color
                      Color(0xFF0061B9), // Right color
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                onPressed: () {
                  clearChat();
                },
                icon: Icon(
                  Icons.cleaning_services_outlined,
                  color: Colors.white,
                ),
              )),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 320,
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _handleSubmitted,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Send a message',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          _sendMessage(_textController.text);
                          _textController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF7FD5D5), // Left color
                      Color(0xFF0061B9), // Right color
                    ],
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 0),
                height: 6,
              )
            ],
          ),
        ),
      ],
    );
  }

  void _handleSubmitted(String text) {
    _sendMessage(text);
    _textController.clear();
  }

  Future<void> _sendMessage(String userMessage) async {
    try {
      // Add user message to the list
      setState(() {
        _messages.insert(0, {'content': userMessage, 'role': 'user'});
      });

      // Send user message to backend and get AI completion
      final Map<String, dynamic> response =
          await chatBackend.sendMessage(userMessage);
      final completion = response['choices'][0]['message']['content'];

      // Add AI completion to the list
      setState(() {
        _messages.insert(0, {'content': completion, 'role': 'ai'});
      });
    } catch (e) {
      print('Error sending message: $e');
      // Handle error
    }
  }
}
