import 'package:chatify/models/chat_user.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
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
}
