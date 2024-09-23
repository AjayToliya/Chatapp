import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FcmNotificationHelper {
  FcmNotificationHelper._();

  static final FcmNotificationHelper fcmNotificationHelper =
      FcmNotificationHelper._();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  //fetch FCM regristraction token
  Future<String?> fetchFCMToken() async {
    String? token = await firebaseMessaging.getToken();

    log("===============");
    log("FCM Token: $token");
    return token;
  }

  Future<String> getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await rootBundle.loadString(
          'assets/chatterbox-d1d06-firebase-adminsdk-gest3-7247a90f3a.json'),
    );
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    return authClient.credentials.accessToken.data;
  }

  Future<void> sendFCM(
      {required String title,
      required String body,
      required String token}) async {
    // String? token = await fetchFMCToken();
    final String accessToken = await getAccessToken();
    final String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/chatterbox-d1d06/messages:send';
    final Map<String, dynamic> myBody = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(myBody),
    );
    if (response.statusCode == 200) {
      print('-------------------');
      print('Notification sent successfully');
      print('-------------------');
    } else {
      print('-------------------');
      print('Failed to send notification: ${response.body}');
      print('-------------------');
    }
  }
}
