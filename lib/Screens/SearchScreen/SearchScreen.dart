import 'dart:html';
import 'dart:math';
import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/AppDataModel.dart';
import 'package:beauty_spin/Screens/HomeScreen/HomeScreenController.dart';
import 'package:beauty_spin/Screens/HomeScreen/HomeScreenItemTile/HomScreenItemTile.dart';
import 'package:beauty_spin/Utilities/SearchBar/SearchBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    Key? key,
    required this.currentDataType,
  }) : super(key: key);

  final TopBarButtonType currentDataType;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
          title: Text(
              '$sSearchScreenTitle ${TopBarBTFunctions.getTopBarTitleText(currentDataType)}'),
          centerTitle: true),
      body: SearchBar(
        minimumChars: 1,
        searchBarPadding: EdgeInsets.only(left: 10, right: 10),
        hintText: sSearchScreenHintText,
        loader: Center(
          child: CircularProgressIndicator(),
        ),
        onSearch: (text) async {
          return FirebaseFirestore.instance
              .collection(
                  TopBarBTFunctions.getCollectionStringValue(currentDataType))
              .where(kName, isGreaterThanOrEqualTo: text!.capitalize)
              .limit(10)
              .get()
              .then((snapshot) {
            final searchedData =
                snapshot.docs.map((e) => AppDataModel.fromJson(e, e.data()));
            return searchedData.toList();
          });
        },
        onItemFound: (dynamic value, index) =>
            HomScreenItemTile.create(value, currentDataType),
        onError: (error) => Center(
            child: Column(children: [
          Text(
            sSomethingwentWrong,
            style: TextStyle(color: cDarkGrayColor, fontSize: 18),
          ),
          Text(
            sPleaseTryAgain,
            style: TextStyle(color: cDarkGrayColor, fontSize: 16),
          )
        ])),
        emptyWidget: Container(
          padding: EdgeInsets.only(
              bottom: min((MediaQuery.of(context).size.height / 4), 150)),
          alignment: Alignment.center,
          child: Text(
            sNoResultfound,
            style: TextStyle(color: cDarkGrayColor, fontSize: 24),
          ),
        ),
      ),
    ));
  }
}
