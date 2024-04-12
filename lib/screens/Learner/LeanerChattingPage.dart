import 'package:mae_part2_studytogether/widgets/chat_messages.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomID;
  const ChatScreen({super.key, required this.chatRoomID});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
          color: Color(0xFFE0F4F5),
          child: Column(
            children: [
              Expanded(
                child: ChatMessages(chatRoomID: widget.chatRoomID),
              ),
              NewMessage(chatRoomID: widget.chatRoomID),
            ],
          )),
    );
  }
}
