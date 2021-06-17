import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:botox_deals/Constants/StringConstants.dart';
import 'package:botox_deals/Models/CityDataModel.dart';
import 'package:botox_deals/Utilities/AppTheme.dart';
import 'package:botox_deals/Utilities/SearchBar/SearchBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../HomeScreenController.dart';

class CitySelector extends StatelessWidget {
  final HomeScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  controller.searchedText.value = '';
                  Get.back();
                }),
            centerTitle: true,
            title: Text(sCitySelectorTitle)),
        body: SearchBar(
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: sCityName,
            minimumChars: 0,
            onError: (error) {
              print(error);
              return Center(child: Text(sPleaseTryAgain));
            },
            onCancelled: () {
              controller.searchedText.value = '';
            },
            onSearch: (text) async {
              controller.searchedText.value = text ?? '';
              return FirebaseFirestore.instance
                  .collection(kUsCitiesCollectionkey)
                  .where(kCityState, isGreaterThan: text!.toUpperCase())
                  .limit(20)
                  .get()
                  .then((value) {
                final searchedData = value.docs
                    .map((e) => CityDataModel.fromJson(e.data()).cityState);
                List<String?> data = [];
                data.addAll(searchedData);
                return data.toList();
              });
            },
            onItemFound: (dynamic value, index) {
              return GestureDetector(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(value,
                          style: kBlueTextTheme.copyWith(fontSize: 16))),
                  onTap: () => controller.updateSelectedCity(value));
            },
            emptyWidget: Obx(() {
              return (controller.searchedText.value.length == 0)
                  ? (controller.hasEmptyCitiesData.value)
                      ? ListView.builder(
                          itemCount: controller.emptyCitiesData.length,
                          itemBuilder: (buildContext, index) {
                            return GestureDetector(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Text(
                                        controller
                                            .emptyCitiesData[index].cityState!,
                                        style: kBlueTextTheme.copyWith(
                                            fontSize: 16))),
                                onTap: () => controller.updateSelectedCity(
                                    controller
                                        .emptyCitiesData[index].cityState!));
                          },
                        )
                      : Center(child: CircularProgressIndicator())
                  : Center(child: Text(sNoCityFound));
            })));
  }
}
