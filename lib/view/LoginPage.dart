import 'dart:developer';

import 'package:chatterbox/utils/FCM_noti_Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/Auth_Hepler.dart';
import '../utils/FireStore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? email;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFcmToken();
    WidgetsBinding.instance.addObserver(this);
    permission();
  }

  Future<void> getFcmToken() async {
    await FcmNotificationHelper.fcmNotificationHelper.fetchFCMToken();
  }

  @override
  Future<void> permission() async {
    PermissionStatus notificationPermission =
        await Permission.notification.request();
    log('${notificationPermission}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Hey, Hello 👋',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your credentials to access your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Map<String, dynamic> res =
                              await Auth_Helper.auth_helper.signInWithGoogle();

                          if (res['user'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Signed in Successfully..."),
                                backgroundColor: Colors.green,
                              ),
                            );
                            User user = res['user'];
                            await FireStoreHelper.fireStoreHelper
                                .addAuthenticatedUser(email: user.email!);
                            Navigator.of(context).pushReplacementNamed('/',
                                arguments: res['user']);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Sign in Failed..."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text("Google"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("or", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Form(
                  key: signInFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter an email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email address",
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Forgot password logic
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (bool? value) {},
                          ),
                          const Text.rich(
                            TextSpan(
                              text: "I agree to the ",
                              children: [
                                TextSpan(
                                  text: "Terms & Privacy",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (signInFormKey.currentState!.validate()) {
                            signInFormKey.currentState!.save();
                            Map<String, dynamic> res = await Auth_Helper
                                .auth_helper
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);

                            if (res['user'] != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Sign in Successfully..."),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/',
                                (route) => false,
                                arguments: res['user'],
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Sign in Failed..."),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Log In"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('SignUp');
                        },
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
