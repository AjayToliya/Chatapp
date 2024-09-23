import 'package:chatterbox/utils/Auth_Hepler.dart';
import 'package:chatterbox/utils/FCM_noti_Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addAuthenticatedUser({required String email}) async {
    bool isUserExists = false;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        querySnapshot.docs;

    allDocs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> docData = doc.data();

      if (docData['email'] == email) {
        isUserExists = true;
      }
    });
    if (isUserExists == false) {
      DocumentSnapshot<Map<String, dynamic>> qs =
          await db.collection("records").doc("users").get();

      Map<String, dynamic>? data = qs.data();

      int id = data!['id'];
      int counter = data['counter'];

      id++;
      String? token =
          await FcmNotificationHelper.fcmNotificationHelper.fetchFCMToken();

      await db.collection("users").doc("$id").set({
        "email": email,
        "token": token,
      });
      counter++;

      await db.collection("records").doc("users").update({
        "id": id,
        "counter": counter,
      });
    }
  }

  deleteChat({required String recieverEmail, required String messageId}) async {
    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        chatRoomId = chatrooms.id;
        break;
      }
    }
    await db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  updateChats(
      {required String recieverEmail,
      required String messageId,
      required String mag}) async {
    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        chatRoomId = chatrooms.id;
        break;
      }
    }
    await db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .update({
      "mag": mag,
      'updatetimestmap': FieldValue.serverTimestamp(),
    });
  }

  //fetch all users
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection("users").snapshots();
  }
//delete user

  Future<void> deleteUser({required String docId}) async {
    await db.collection("users").doc(docId).delete();

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await db.collection("records").doc("users").get();

    int counter = userDoc.data()!['counter'];

    counter--;

    await db.collection('records').doc("users").update(
      {
        "counter": counter,
      },
    );
  }

  sendMessage({required String receiverEmail, required String msg}) async {
    String senderEmail = Auth_Helper.firebaseAuth.currentUser!.email!;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection('chatrooms').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;
    String? chatroomId;
    bool ischatroomExists = false;
    allChatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      List users = chatroom.data()['users'];
      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        ischatroomExists = true;
        chatroomId = chatroom.id;
      }
    });
    if (ischatroomExists == false) {
      DocumentReference<Map<String, dynamic>> docRef =
          await db.collection('chatrooms').add({
        "users": [senderEmail, receiverEmail]
      });
      chatroomId = docRef.id;
    }
    await db
        .collection('chatrooms')
        .doc(chatroomId)
        .collection("messages")
        .add({
      "mag": msg,
      "senderEmail": senderEmail,
      "receiverEmail": receiverEmail,
      "timestamp": FieldValue.serverTimestamp()
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchMassage(
      {required String receiverEmail}) async {
    String senderEmail = Auth_Helper.firebaseAuth.currentUser!.email!;
    String? chatroomId;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection('chatrooms').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    allChatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> chatroom) {
      List users = chatroom.data()['users'];
      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomId = chatroom.id;
      }
    });
    return db
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<String> getLastMessageTimeStream(String receiverEmail) async* {
    String senderEmail = Auth_Helper.firebaseAuth.currentUser!.email!;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    String? chatroomId;

    for (var chatroom in allChatrooms) {
      List users = chatroom.data()['users'];
      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomId = chatroom.id;
        break;
      }
    }

    if (chatroomId == null) yield "No messages";
    yield* db
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return "No messages";
      }
      var lastMessage = snapshot.docs.first.data();
      Timestamp timestamp = lastMessage['timestamp'];
      DateTime date = timestamp.toDate();
      return " ${date.hour} : ${date.minute}";
    });
  }
}
