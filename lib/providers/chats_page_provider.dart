import 'dart:async';

import 'package:chatify/models/chat.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  AuthenticationProvider _authenticationProvider;
  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatStream;

  ChatPageProvider(this._authenticationProvider) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {}
}
