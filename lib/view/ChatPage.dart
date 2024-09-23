import 'package:chatterbox/utils/FCM_noti_Helper.dart';
import 'package:chatterbox/utils/FireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/Auth_Hepler.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> receiverEmail =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final TextEditingController messagescontroller = TextEditingController();
    final TextEditingController editController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: (receiverEmail == Auth_Helper.firebaseAuth.currentUser!.email)
            ? Text("Chat Page\nYourself")
            : Text(
                "Chat Page\n $receiverEmail",
                textAlign: TextAlign.center,
              ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 14,
            child: Container(
              alignment: Alignment.center,
              child: FutureBuilder(
                future: FireStoreHelper.fireStoreHelper
                    .fetchMassage(receiverEmail: receiverEmail['email']),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("ERROR: ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    Stream? data = snapshot.data;
                    return StreamBuilder(
                      stream: data,
                      builder: (context, ss) {
                        if (ss.hasError) {
                          return Center(
                            child: Text("ERROR: ${ss.error}"),
                          );
                        } else if (ss.hasData) {
                          QuerySnapshot<Map<String, dynamic>>? chats = ss.data;

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              allMessages = (chats == null) ? [] : chats.docs;

                          return (allMessages.isEmpty)
                              ? Center(
                                  child: Text("No Messages Yet"),
                                )
                              : ListView.builder(
                                  itemCount: allMessages.length,
                                  reverse: true,
                                  itemBuilder: (context, ind) {
                                    return Row(
                                      mainAxisAlignment:
                                          (receiverEmail['email'] !=
                                                  allMessages[ind]
                                                      .data()['receiverEmail'])
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                      children: [
                                        (receiverEmail['email'] !=
                                                allMessages[ind]
                                                    .data()['receiverEmail'])
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Text(
                                                  allMessages[ind]
                                                      .data()['mag'],
                                                ),
                                              )
                                            : PopupMenuButton<String>(
                                                onSelected: (val) async {
                                                  if (val == 'delete') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          title: Text(
                                                            "Are you sure?",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              "This action will permanently delete the message.",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                FireStoreHelper
                                                                    .fireStoreHelper
                                                                    .deleteChat(
                                                                  recieverEmail:
                                                                      receiverEmail[
                                                                          'email'],
                                                                  messageId:
                                                                      allMessages[
                                                                              ind]
                                                                          .id,
                                                                );
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                "Delete",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if (val == 'edit') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          title: Text(
                                                            "Edit Message",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "Edit Message...",
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  controller:
                                                                      editController,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                editController
                                                                    .clear();
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                FireStoreHelper
                                                                    .fireStoreHelper
                                                                    .updateChats(
                                                                  mag:
                                                                      editController
                                                                          .text,
                                                                  recieverEmail:
                                                                      receiverEmail[
                                                                          'email'],
                                                                  messageId:
                                                                      allMessages[
                                                                              ind]
                                                                          .id,
                                                                );
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                editController
                                                                    .clear();
                                                              },
                                                              child: Text(
                                                                "Edit",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text('Edit'),
                                                  ),
                                                ],
                                                position:
                                                    PopupMenuPosition.under,
                                                child: Chip(
                                                  label: Text(
                                                    "${allMessages[ind].data()['mag']}",
                                                  ),
                                                ),
                                              ),
                                      ],
                                    );
                                  },
                                );
                        }
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messagescontroller,
                      validator: (val) {
                        if (val!.isEmpty) return "Please enter your email";
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send, color: Colors.grey),
                          onPressed: () async {
                            String msg = messagescontroller.text;
                            await FireStoreHelper.fireStoreHelper.sendMessage(
                                receiverEmail: receiverEmail['email'],
                                msg: msg);
                            messagescontroller.clear();
                            await FcmNotificationHelper.fcmNotificationHelper
                                .sendFCM(
                              title: msg,
                              body:
                                  Auth_Helper.firebaseAuth.currentUser!.email!,
                              token: receiverEmail['token'],
                            );
                          },
                        ),
                        hintText: "Message__",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
