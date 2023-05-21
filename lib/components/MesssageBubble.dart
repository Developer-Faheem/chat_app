import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({required this.text, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.black87),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54, fontSize: 20),
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black, //New
                    blurRadius: 25.0,
                    offset: Offset(0, 10))
              ],
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))
                  : BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
