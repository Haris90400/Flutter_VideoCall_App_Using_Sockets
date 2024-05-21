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
}
