import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:botox_deals/Models/AppDataModel.dart';
import 'package:botox_deals/Models/DealsModel.dart';
import 'package:botox_deals/Screens/PageNotFond/PageNotFound.dart';
import 'package:botox_deals/Screens/UserProfile/UserProfileController.dart';
import 'package:botox_deals/Services/CurrentLocationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailsScreenController extends GetxController {
  String? dataType = '';
  String? userID = '';
  RxBool hasData = false.obs;
  AppDataModel data = AppDataModel();

  RxBool hasDeals = false.obs;
  List<DealModel> deals = [];

  final CurrentLocationController currentLocationController = Get.find();
  final UserProfileScreenController userController = Get.find();

  @override
  void onInit() {
    // ignore: unnecessary_null_comparison
    if (Get.parameters != null) {
      if (Get.parameters['user'] != null) userID = Get.parameters['user'];
      if (Get.parameters['dataType'] != null)
        dataType = Get.parameters['dataType'];
      getDetails();
    }
    super.onInit();
  }

  void getDetails() {
    FirebaseFirestore.instance
        .collection(dataType!)
        .doc(userID)
        .get()
        .then((snapshot) {
      final model = AppDataModel.fromJson(snapshot, snapshot.data()!);
      data = model;
      hasData.value = true;
      getDeals(dataType);
    }).catchError((error) {
      Get.offNamed(PageNotFound.routeName);
    });
  }

  void getDeals(String? collection) {
    FirebaseFirestore.instance
        .collection('$collection$kDealsSuffixKey')
        .where(kDId, isEqualTo: data.docRef)
        .get()
        .then((dealsSnap) {
      final newDeals =
          dealsSnap.docs.map((e) => DealModel.fromJson(e.id, e.data()));
      deals = [];
      deals.addAll(newDeals);
      hasDeals.value = true;
    });
  }
}
