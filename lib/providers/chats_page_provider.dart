import 'dart:async';

import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message.dart';
import 'package:chatify/models/user.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void getChats() async {
    try {
      _chatStream =
          _db.getChatsForUser(_authenticationProvider.user.uid).listen(
        (snapshot) async {
          chats = await Future.wait(
            snapshot.docs.map(
              (doc) async {
                Map<String, dynamic> _chatData =
                    doc.data() as Map<String, dynamic>;

                //Get users in Chat
                List<ChatUser> _members = [];
                for (var member in _chatData['members']) {
                  DocumentSnapshot _userSanpshot = await _db.getUser(member);

                  Map<String, dynamic> _userData =
                      _userSanpshot.data() as Map<String, dynamic>;

                  _userData["uid"] = _userSanpshot.id;

                  _members.add(
                    ChatUser.fromJSON(_userData),
                  );
                }

                //Get Last Message for Chat
                List<ChatMessage> _messages = [];
                QuerySnapshot _chatMessage = await _db.getLastMessageForChat(
                  doc.id,
                );

                if (_chatMessage.docs.isNotEmpty) {
                  Map<String, dynamic> _messageData =
                      _chatMessage.docs.first.data()! as Map<String, dynamic>;

                  ChatMessage _message = ChatMessage.fromJSON(_messageData);

                  _messages.add(_message);
                }

                //Return Chat Instance
                return Chat(
                  uid: doc.id,
                  currentUserUid: _authenticationProvider.user.uid,
                  members: _members,
                  messages: _messages,
                  activity: _chatData['activity'],
                  group: _chatData['group'],
                );
              },
            ).toList(),
          );
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting chats");
      print(e.toString());
    }
  }
}
