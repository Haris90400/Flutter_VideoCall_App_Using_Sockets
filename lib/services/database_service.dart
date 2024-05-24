import 'package:chatify/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<void> updateLatsActiveTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        "lastActive": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser(
      String _uid, String _name, String _email, String _imageUrl) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          "email": _email,
          "imageUrl": _imageUrl,
          "name": _name,
          "lastActive": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getChatsForUser(String _userUID) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _userUID)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sentTime', descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sentTime", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatId, ChatMessage message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGES_COLLECTION)
          .add(
            message.toJson(),
          );
      print(message.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateChatData(String _chatId, Map<String, dynamic> data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatId).update(
            data,
          );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteChat(String _chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
