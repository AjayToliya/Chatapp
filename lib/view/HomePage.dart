import 'package:chatterbox/utils/Auth_Hepler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/FireStore.dart';
import 'Componet/dra.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: (user == null)
          ? const Drawer()
          : Drawers(
              user: user,
            ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.fetchAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "ERROR: ${snapshot.error}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  (data == null) ? [] : data.docs;

              if (allDocs.isEmpty) {
                return const Center(
                  child: Text(
                    "No users found.",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, i) {
                  return const SizedBox(
                    height: 6,
                  );
                },
                itemCount: allDocs.length,
                itemBuilder: (context, i) {
                  String email = allDocs[i].data()['email'] ?? 'Unknown User';

                  return (Auth_Helper.firebaseAuth.currentUser!.email == email)
                      ? Container()
                      : Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                email[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            title: Text(
                              email.toString().split('@')[0],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: StreamBuilder<String>(
                              stream: FireStoreHelper.fireStoreHelper
                                  .getLastMessageTimeStream(email),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading...");
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else if (snapshot.hasData) {
                                  return Text("Last message: ${snapshot.data}");
                                } else {
                                  return Text("No messages yet");
                                }
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await FireStoreHelper.fireStoreHelper
                                    .deleteUser(docId: allDocs[i].id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "User $email deleted successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed("ChatApp",
                                  arguments: allDocs[i].data());
                            },
                          ),
                        );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
