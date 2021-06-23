import 'dart:math';
import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/AppDataModel.dart';
import 'package:beauty_spin/Models/CityDataModel.dart';
import 'package:beauty_spin/Models/PromotionDataModel.dart';
import 'package:beauty_spin/Screens/NotificationsScreen/NotificationsController.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfileController.dart';
import 'package:beauty_spin/Services/CookieManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_maps/google_maps.dart';

enum HomePageType { list, map }

enum TopBarButtonType {
  fav,
  botox,
  wax,
  tan,
  nails,
  lashes,
  brow,
  blowout,
}

extension TopBarBTFunctions on TopBarButtonType {
  static String getTopBarTitleText(TopBarButtonType value) {
    switch (value) {
      case TopBarButtonType.botox:
        return sSbBotoxTitle;
      case TopBarButtonType.nails:
        return sSbNailsTitle;
      case TopBarButtonType.wax:
        return sSbWaxTitle;
      case TopBarButtonType.tan:
        return sSbTanTitle;
      case TopBarButtonType.lashes:
        return sSbLashesTitle;
      case TopBarButtonType.brow:
        return sSbBrowTitle;
      case TopBarButtonType.blowout:
        return sSbBlowoutTitle;
      default:
        return sSbBotoxTitle;
    }
  }

  static String getCollectionStringValue(TopBarButtonType value) {
    switch (value) {
      case TopBarButtonType.botox:
        return kBotoxCollectionKey;
      case TopBarButtonType.nails:
        return kNailsCollectionKey;
      case TopBarButtonType.wax:
        return kWaxCollectionKey;
      case TopBarButtonType.tan:
        return kTanCollectionKey;
      case TopBarButtonType.lashes:
        return kLashesCollectionKey;
      case TopBarButtonType.brow:
        return kBrowCollectionKey;
      case TopBarButtonType.blowout:
        return kBlowoutCollectionKey;
      default:
        return kBotoxCollectionKey;
    }
  }
}

class HomeScreenController extends GetxController {
  Rx<HomePageType> homePageType = HomePageType.list.obs;

  Rx<TopBarButtonType> previousDataViewType = TopBarButtonType.botox.obs;
  Rx<TopBarButtonType> currentDataViewType = TopBarButtonType.botox.obs;

  // Us Cities Selector
  RxString selectedCityState = 'DENVER, CO'.obs;
  RxString searchedText = ''.obs;

  RxBool hasEmptyCitiesData = false.obs;
  List<CityDataModel> emptyCitiesData = [];
  //

  RxInt currentNavigationBarIndex = 0.obs;

  RxBool isGettingData = true.obs;
  RxList<dynamic> homePageData = [].obs;
  // RxInt homePageDataLength = 0.obs;
  // ScrollController listViewController = ScrollController();

  Rx<AppDataModel> promotionQueueItem = AppDataModel().obs;

  Marker? selectedMarker;
  Rx<AppDataModel> onMarkerSelected = AppDataModel().obs;

  UserProfileScreenController userController = Get.find();
  NotificationsScreenController notificationsScreenController =
      Get.put(NotificationsScreenController());

  // RxBool isUsingUpdatedVersion = true.obs;

  //// For Maps only
  List<Marker> draggedDataMarkers = [];

  @override
  void onReady() {
    updatePromotionQueueItem();
    getHomePageData();
    super.onReady();
  }

  @override
  void onInit() {
    onMessage();
    addCitiesInList();
    // listViewController.addListener(() {
    //   if (listViewController.position.pixels ==
    //       listViewController.position.maxScrollExtent) {}
    // });
    super.onInit();
  }

  void onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification!.title;
      final body = message.notification!.body;
      print('message from FB : title : $title, body : $body');
    });
  }

  void addInWinnerList() {
    FirebaseFirestore.instance.collection(kWinnersCollectionKey).add({
      kWSessionAccessToken: CookieManager.getCookie(sKSession),
      kWWonOn: Timestamp.now(),
      kWVisitorCount: userController.currentUserCount,
      kWName: userController.hasUserName.value
          ? userController.user.value.name
          : 'NA',
      kWIsMailSent: userController.hasUser.value,
      kWEmail: userController.hasUser.value
          ? userController.user.value.email ?? 'NA'
          : 'NA',
      kWPhone: userController.hasUser.value
          ? userController.user.value.phoneNo ?? 'NA'
          : 'NA',
    });
  }

  void getFavData() {
    List<AppDataModel> favList = [];
    currentDataViewType.value = TopBarButtonType.fav;
    isGettingData.value = true;
    previousDataViewType.value = currentDataViewType.value;
    homePageData = [].obs;
    promotionQueueItem.value = AppDataModel();
    onMarkerSelected.value = AppDataModel();
    // ignore: invalid_use_of_protected_member
    if (userController.user.value.bookmarked!.value.length == 0)
      isGettingData.value = false;
    else
      for (DocumentReference? data
          in userController.user.value.bookmarked as RxList<dynamic>) {
        data!.get().then((element) {
          final dataToAdd = AppDataModel.fromJson(
              element, element.data() as Map<String, dynamic>);
          favList.add(dataToAdd);
          print(dataToAdd.name);
          // ignore: invalid_use_of_protected_member
          homePageData.value.add(dataToAdd);
          if (userController.user.value.bookmarked!.length == favList.length) {
            favList.sort((a, b) => a.name!.compareTo(b.name!));
            // ignore: invalid_use_of_protected_member
            homePageData.value = favList;
            isGettingData.value = false;
          }
        });
      }
  }

  void updateSelectedCity(String city) {
    selectedCityState.value = city;
    isGettingData.value = true;
    updatePromotionQueueItem();
    homePageData = [].obs;
    getHomePageData();
    onMarkerSelected.value = AppDataModel();
    searchedText.value = '';
    Get.back();
  }

  void changeTopBarViewType(TopBarButtonType type) {
    currentDataViewType.value = type;
    if (previousDataViewType.value != currentDataViewType.value) {
      isGettingData.value = true;
      previousDataViewType.value = currentDataViewType.value;
      updatePromotionQueueItem();
      homePageData.value = [];
      getHomePageData();
      onMarkerSelected.value = AppDataModel();
    }
  }

  void changeHomePageType() {
    (homePageType.value == HomePageType.list)
        ? homePageType.value = HomePageType.map
        : homePageType.value = HomePageType.list;
    onMarkerSelected.value = AppDataModel();
  }

  Future<bool> updatePromotionQueueItem() {
    final cityQuery = FirebaseFirestore.instance
        .collection(
            '${TopBarBTFunctions.getCollectionStringValue(currentDataViewType.value)}$kPromoQueueSuffixKey')
        .where(kpCityState, isEqualTo: selectedCityState.value);

    // GET QUEUED DATA
    return cityQuery.where(kpQueued, isEqualTo: true).get().then((snap) {
      final promotionList =
          snap.docs.map((e) => PromotionDataModel.fromJson(e, e.data()));

      if (promotionList.length < 2) {
        //Update promotion Queue Data With True Value

        cityQuery.get().then((snapshotData) {
          final list = snapshotData.docs
              .map((e) => PromotionDataModel.fromJson(e, e.data()));

          for (var promotionItem in list) {
            promotionItem.docRef!.update({kpQueued: true});
          }
        });
      }

      if (promotionList.length != 0) {
        // GET RANDOM NO
        var random = new Random();
        int no = random.nextInt(promotionList.length);

        // Updated that Random no
        promotionList.toList()[no].docRef!.update({kpQueued: false});

        // GET PROMO DATA AND ADD IN VALUE
        promotionList.toList()[no].id!.get().then((promoSnap) {
          final AppDataModel promo = AppDataModel.fromJson(
              promoSnap, promoSnap.data() as Map<String, dynamic>);
          promotionQueueItem.value = promo;
          return true;
        });
      }
      promotionQueueItem.value = AppDataModel();
      return false;
    });
  }

  void getHomePageData() {
    // getHomePageDataLength();
    FirebaseFirestore.instance
        .collection(TopBarBTFunctions.getCollectionStringValue(
            currentDataViewType.value))
        .where(kCityState, isEqualTo: selectedCityState.value)
        //.startAfter(kName : [lastDataName])
        // .limit(15)
        .get()
        .then((snapshot) {
      final data = snapshot.docs.map((e) => AppDataModel.fromJson(e, e.data()));
      if (data.length != 0)
        // ignore: invalid_use_of_protected_member
        homePageData.value.addAll(data);
      Future.delayed(Duration(milliseconds: data.length))
          .then((value) => isGettingData.value = false);
    });
  }

  // getHomePageDataLength() {
  //   homePageDataLength.value = 0;
  //   FirebaseFirestore.instance
  //       .collection(TopBarBTFunctions.getCollectionStringValue(
  //           currentDataViewType.value))
  //       .where(kCityState, isEqualTo: selectedCityState.value)
  //       .get()
  //       .then((value) {
  //     homePageDataLength.value = value.size;
  //   });
  // }

  // Search City Screen Data
  void addCitiesInList() {
    FirebaseFirestore.instance
        .collection(kUsCitiesCollectionkey)
        .orderBy(kcCity)
        .limit(100)
        .get()
        .then((value) {
      final list = value.docs.map((e) => CityDataModel.fromJson(e.data()));
      emptyCitiesData = [];
      emptyCitiesData.addAll(list);
      hasEmptyCitiesData.value = true;
    });
  }
}
