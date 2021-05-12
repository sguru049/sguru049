import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:botox_deals/Models/NotificationsModel.dart';
import 'package:botox_deals/Screens/UserProfile/UserProfileController.dart';
import 'package:botox_deals/Services/CookieManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationsScreenController extends GetxController {
  UserProfileScreenController userController = Get.find();
  RxBool hasNotifications = false.obs;
  List<NotificationModel> notifications = [];

  @override
  void onReady() {
    notifications = [];
    hasNotifications.value = false;
    getNotificationsList();
    super.onReady();
  }

  void getNotificationsList() {
    final notificationsCollection =
        FirebaseFirestore.instance.collection(kNotificationsCollectionKey);
    if (userController.user.value.name != null) {
      notificationsCollection
          .where(kNUserId, isEqualTo: userController.user.value.docId)
          .get()
          .then((value) {
        final list = value.docs
            .map((e) => NotificationModel.fromJson(e.reference, e.data()));
        notifications.addAll(list);
        hasNotifications.value = true;
      });
    } else {
      notificationsCollection
          .where(kNSessionAccessToken,
              isEqualTo: CookieManager.getCookie(sKSession))
          .get()
          .then((value) {
        final list = value.docs
            .map((e) => NotificationModel.fromJson(e.reference, e.data()));
        notifications.addAll(list);
        hasNotifications.value = true;
      });
    }
  }
}
