import 'package:chatify/models/chat_message.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/cloud_storage_service.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_services.dart';
import 'package:chatify/services/navigation_service.dart';
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

  String? _message;

  String get message {
    return _message!;
  }

  ChatPageProvider(this._chatId, this._auth, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigationService = GetIt.instance.get<NavigationService>();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    _navigationService.goBack();
  }
}
