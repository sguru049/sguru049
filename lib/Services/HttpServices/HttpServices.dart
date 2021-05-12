import 'dart:convert';
import 'package:get/get_connect/connect.dart';
import 'package:botox_deals/Constants/StringConstants.dart';

class HttpServices extends GetConnect {
  // Send Notifications in app using firebase rest api
  Future<Response> sendNotification({
    required String? messagingToken,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    final response = await post(
      sNSendNotificationUrl,
      json.encode({
        sNTo: messagingToken,
        sN: {
          sNTitle: notificationTitle,
          sNBody: notificationBody,
        },
        sNWebPush: {
          sNHeaders: {sNTTL: sNTTLValue}
        }
      }),
      headers: {
        sContentType: sContentValue,
        sAuthorization: sNAuth,
      },
    );

    if (response.isOk) {
      print('Response ${response.body}');
    } else {
      print('Error $response');
    }

    return response;
  }

  // Send sms on mobile using
  Future<Response> sendSms({
    required String? to,
    required String message,
  }) async {
    final response = await post(
      sSendSmsUrl,
      {
        sSmsMessageKey: [
          {
            sSmsBodyKey: message,
            sSmsToKey: to,
          }
        ]
      },
      headers: {
        sContentType: sContentValue,
        sAuthorization: sSmsAuth,
      },
    );

    if (response.isOk) {
      print('Response ${response.body}');
    } else {
      print('Error $response');
    }

    return response;
  }
}

  // json.encode({
      //   sSmsUserNameKey: ENV.sendSmsUserName,
      //   sSmsKey: ENV.sendSmsKey,
      //   sSmsMethod: sSmsMethodValue,
      //   sSmsTo: to,
      //   sSmsMessage: message,
      //   sSmsSenderId: sSmsSenderIdValue
      // }),


// Demo SMS For testing
// HttpServices().sendSms(
//       to: '+918171757329',
//       message: 'Hey I am Gurpreet Singh sending you message from Beautideals',
//     );