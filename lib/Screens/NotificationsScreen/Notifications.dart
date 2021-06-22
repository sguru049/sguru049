import 'package:auto_size_text/auto_size_text.dart';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Screens/NotificationsScreen/NotificationItemTile/NotificationItemTile.dart';
import 'package:beauty_spin/Screens/NotificationsScreen/NotificationsController.dart';
import 'package:beauty_spin/Screens/OfflineScreen/OfflineScreen.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({Key? key}) : super(key: key);
  NotificationsScreenController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConnectivityBuilder(builder: (context, isConnected, status) {
        return (!isConnected!)
            ? OfflineScreen()
            : Obx(() {
                return (controller.hasNotifications.value)
                    ? _buildMain(context)
                    : Center(child: CircularProgressIndicator());
              });
      }),
    );
  }

  Widget _buildMain(BuildContext context) {
    return RefreshIndicator(
      child: (controller.notifications.length == 0)
          ? SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Spacer(),
                      AutoSizeText(
                        'No Notifications Found',
                        style: TextStyle(color: cDarkGrayColor),
                      ),
                      Spacer(),
                      Spacer(),
                    ],
                  )))
          : ListView.builder(
              itemCount: controller.notifications.length,
              itemBuilder: (buildContext, index) => NotificationItemTile(
                notification: controller.notifications[index],
                isRead: controller.notifications[index].isRead!,
              ),
            ),
      onRefresh: () {
        controller.notifications = [];
        controller.hasNotifications.value = false;
        controller.getNotificationsList();
        return Future.delayed(Duration(milliseconds: 300));
      },
    );
  }
}
