import 'dart:convert';

import 'package:e_commerce/services/get-service-key.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
    required String deviceToken,
  }) async {
    String serverKey = await GetServerKey().getServerKey();
    print("notification server key  => ${serverKey}");
    String url =
        "https://fcm.googleapis.com/v1/projects/helloworld-ad78a/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer  $serverKey'
    };

    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": data,
        "android": {
          "priority": "HIGH",
        }
      }
    };

    //   hit api
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      print("Notification Sends Successfully");
    } else {
      print("Notification Sends Unsuccessfull");
    }
  }
}
