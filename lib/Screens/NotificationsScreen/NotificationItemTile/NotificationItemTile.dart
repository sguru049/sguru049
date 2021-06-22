import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/NotificationsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class NotificationItemTile extends StatelessWidget {
  NotificationItemTile({
    Key? key,
    required this.notification,
    required this.isRead,
  }) : super(key: key);

  final NotificationModel notification;
  RxBool isRead;
  double height = 50;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        child: Container(
            margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
            height: height,
            color: Colors.grey[100],
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: height - 5,
                          width: 3,
                          color:
                              isRead.value ? cLightGrayColor : cAppThemeColor),
                      SizedBox(width: 10),
                      // Icon(Icons.info_outline,
                      Icon(
                          (notification.title == sNTitleValue)
                              ? Icons.card_giftcard
                              : Icons.info_outline,
                          color:
                              isRead.value ? cLightGrayColor : cAppThemeColor),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          AutoSizeText(notification.title!,
                              maxLines: 1,
                              minFontSize: 8,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isRead.value
                                      ? cMediumGrayColor
                                      : cAppThemeColor)),
                          Spacer(),
                          AutoSizeText(notification.body!,
                              maxLines: 1,
                              minFontSize: 8,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: isRead.value
                                      ? cMediumGrayColor
                                      : Colors.black)),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 2,
                  child: AutoSizeText(
                    '${notification.creationTS!.toDate().day} ${getMonthName(notification.creationTS!.toDate().month)}',
                    minFontSize: 4,
                    style: TextStyle(fontSize: 10, color: cDarkGrayColor),
                  ),
                )
              ],
            )),
        onTap: () {
          isRead.value = true;
          notification.docRef!.update({kNIsRead: true});
        },
      );
    });
  }

  String getMonthName(int month) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month + 1];
  }
}
