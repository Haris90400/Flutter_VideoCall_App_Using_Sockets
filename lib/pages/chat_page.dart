// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatify/providers/authentication_provider.dart';
import 'package:flutter/material.dart';

import 'package:chatify/models/chat.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double height;
  late double width;
  late AuthenticationProvider _auth;

  late ScrollController _messageListViewController;
  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold();
  }
}
