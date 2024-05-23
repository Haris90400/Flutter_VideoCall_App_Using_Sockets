import 'dart:async';

import 'package:chatify/models/chat_message.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloud_storage_service.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_services.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _cloudStorageService;
  late MediaService _mediaService;
  late NavigationService _navigationService;

  AuthenticationProvider _auth;
  ScrollController _messageListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;

  String? _message;

  void set message(String _value) {
    _message = _value;
  }

  String get message {
    return message;
  }

  ChatPageProvider(this._chatId, this._auth, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    listenToMessages();
  }
  @override
  void dispose() {
    super.dispose();
    _messagesStream.cancel();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatId).listen(
        (snapshot) {
          List<ChatMessage> _messages = snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting messages");
      print(e.toString());
    }
  }

  void deleteChata() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );

      _db.addMessageToChat(
        _chatId,
        _messageToSend,
      );
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _mediaService.pickImageFromLibrary();

      if (_file != null) {
        String? _downloadUrl = await _cloudStorageService.saveChatImage(
          _chatId,
          _auth.user.uid,
          _file,
        );
        ChatMessage _messageToSend = ChatMessage(
          content: _downloadUrl!,
          type: MessageType.IMAGE,
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(
          _chatId,
          _messageToSend,
        );
      }
    } catch (e) {
      print("Error sending message image");
      print(e.toString());
    }
  }

  void goBack() {
    _navigationService.goBack();
  }
}
