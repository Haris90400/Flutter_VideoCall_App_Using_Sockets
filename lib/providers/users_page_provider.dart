import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_user.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;
  late NavigationService _navigationService;
  List<ChatUser>? chatUser;
  late List<ChatUser> _selectedUsrs;

  List<ChatUser> get selectedUsers {
    return _selectedUsrs;
  }

  UsersPageProvider(this._auth) {
    _selectedUsrs = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsrs = [];
    try {
      _db.getUsers(name: name).then(
        (snapshot) {
          chatUser = snapshot.docs.map((_doc) {
            Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
            _data["uid"] = _doc.id;
            return ChatUser.fromJSON(_data);
          }).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("error getting users");
      print(e.toString());
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_selectedUsrs.contains(_user)) {
      _selectedUsrs.remove(_user);
    } else {
      _selectedUsrs.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersIds =
          _selectedUsrs.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user.uid);
      bool _isGroup = _selectedUsrs.length > 1;
      DocumentReference? _doc = await _db.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _membersIds,
      });

      List<ChatUser> _members = [];
      for (var _uid in _membersIds) {
        DocumentSnapshot _userSnashot = await _db.getUser(_uid);
        Map<String, dynamic> _userData =
            _userSnashot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnashot.id;
        _members.add(
          ChatUser.fromJSON(_userData),
        );
      }

      ChatPage _chatPage = ChatPage(
        chat: Chat(
            uid: _doc!.id,
            currentUserUid: _auth.user.uid,
            members: _members,
            messages: [],
            activity: false,
            group: _isGroup),
      );
      _selectedUsrs = [];
      notifyListeners();
      _navigationService.navigateToPage(_chatPage);
    } catch (e) {
      print("error creating chats");
      print(e.toString());
    }
  }
}
