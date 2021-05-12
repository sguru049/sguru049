import 'dart:html';
import 'dart:math';
import 'package:botox_deals/Assets/DataConstants.dart';
import 'package:botox_deals/Constants/KeysConstants.dart';
import 'package:botox_deals/Models/AppDataModel.dart';
import 'package:botox_deals/Screens/HomeScreen/HomeScreenItemTile/HomScreenItemTile.dart';
import 'package:botox_deals/Services/HtmlEmbed.dart';
import 'package:botox_deals/Utilities/GeoPointsHash/point.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps/google_maps.dart';
import '../HomeScreenController.dart';

class HomeScreenMap extends StatelessWidget {
  final HomeScreenController? controller;
  const HomeScreenMap({Key? key, @required this.controller}) : super(key: key);

  static create() => HomeScreenMap(controller: Get.find());

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: _getMap(),
          // child: Center(child: Text('MAPS')),
        ),
        Positioned(
          bottom: 10,
          child: Obx(() {
            return (controller!.onMarkerSelected.value.name != null)
                ? Container(
                    width: (_screenWidth > 500) ? 400 : (_screenWidth * 0.8),
                    height: max(110, (MediaQuery.of(context).size.height / 6)),
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.5),
                            spreadRadius: 1.0,
                            blurRadius: 7,
                          )
                        ]),
                    child: HomScreenItemTile.create(
                      controller!.onMarkerSelected.value,
                      controller!.currentDataViewType.value,
                    ))
                : SizedBox.shrink();
          }),
        ),
      ],
    );
  }

  Widget _getMap() {
    String htmlId = UniqueKey().toString();

    // // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    return HtmlEmbed().getHtmlPage(htmlId, (int id) {
      final mapOptions = MapOptions()
        ..draggable = true
        ..zoom = 10
        ..center = (controller!.homePageData.isNotEmpty)
            ? LatLng(
                // ignore: invalid_use_of_protected_member
                controller!.homePageData.value[0].latitude,
                // ignore: invalid_use_of_protected_member
                controller!.homePageData.value[0].longitude)
            : LatLng(39.719546, -104.949824);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      // MARKERS
      Marker promoMarker = Marker();

      // ignore: invalid_use_of_protected_member
      for (var d in controller!.homePageData.value) {
        if (controller!.promotionQueueItem.value.name != null &&
            (d.latitude == controller!.promotionQueueItem.value.latitude &&
                d.longitude ==
                    controller!.promotionQueueItem.value.longitude)) {
          // For Promoted Marker
          promoMarker = Marker(MarkerOptions()
            ..icon = icUnselectedPromoMarker
            ..position = LatLng(controller!.promotionQueueItem.value.latitude,
                controller!.promotionQueueItem.value.longitude)
            ..clickable = true
            ..map = map
            ..zIndex = 100000
            ..title = controller!.promotionQueueItem.value.name);

          promoMarker.onClick.listen((event) {
            if (controller!.selectedMarker != null &&
                controller!.selectedMarker?.title != promoMarker.title) {
              controller!.selectedMarker?.icon = icUnselectedMarker;
            }
            promoMarker.icon = icSelectedPromoMarker;
            controller!.selectedMarker = promoMarker;

            Future.delayed(Duration(milliseconds: 400), () {
              controller!.onMarkerSelected.value =
                  controller!.promotionQueueItem.value;
            });
          });
        } else {
          // For Other Marker
          final marker = Marker(
            MarkerOptions()
              ..icon = icUnselectedMarker
              ..position = LatLng(d.latitude, d.longitude)
              ..clickable = true
              ..map = map
              ..title = d.name,
          );

          marker.onClick.listen((event) {
            if (controller!.selectedMarker != null) {
              controller!.selectedMarker?.icon = icUnselectedMarker;

              if (controller!.promotionQueueItem.value.name != null)
                promoMarker.icon = icUnselectedPromoMarker;
            }
            if (controller!.promotionQueueItem.value.name != null)
              promoMarker.icon = icUnselectedPromoMarker;

            marker.icon = icSelectedMarker;

            controller!.selectedMarker = marker;

            // ignore: invalid_use_of_protected_member
            for (var data in controller!.homePageData.value) {
              if ((data.latitude == event.latLng?.lat) &&
                  (data.longitude == event.latLng?.lng)) {
                Future.delayed(Duration(milliseconds: 400), () {
                  controller!.onMarkerSelected.value = data;
                });
              }
            }
          });
        }
      }

      map.onDragend.listen((event) {
        if (map.bounds != null) {
          final starting = map.bounds!.southWest;
          final ending = map.bounds!.northEast;

          FirebaseFirestore.instance
              .collection(TopBarBTFunctions.getCollectionStringValue(
                  controller!.currentDataViewType.value))
              .orderBy(kGeoHash)
              .startAt([
                GeoFirePoint(starting.lat as double, starting.lng as double)
                    .hash
              ])
              .endAt([
                GeoFirePoint(ending.lat as double, ending.lng as double).hash
              ])
              .get()
              .then((value) {
                final data =
                    value.docs.map((e) => AppDataModel.fromJson(e, e.data()));

                controller!.draggedDataMarkers
                    .forEach((marker) => marker.map = null);
                controller!.draggedDataMarkers = [];

                for (var d in data.toList()) {
                  final mark = Marker(
                    MarkerOptions()
                      ..icon = icUnselectedMarker
                      ..position = LatLng(d.latitude, d.longitude)
                      ..clickable = true
                      ..map = map
                      ..title = d.name,
                  );

                  controller!.draggedDataMarkers.add(mark);

                  mark.onClick.listen((event) {
                    if (controller!.selectedMarker != null) {
                      controller!.selectedMarker?.icon = icUnselectedMarker;
                      if (controller!.promotionQueueItem.value.name != null)
                        promoMarker.icon = icUnselectedPromoMarker;
                    }
                    if (controller!.promotionQueueItem.value.name != null)
                      promoMarker.icon = icUnselectedPromoMarker;
                    mark.icon = icSelectedMarker;
                    controller!.selectedMarker = mark;

                    // ignore: invalid_use_of_protected_member
                    for (var d in data.toList()) {
                      if ((d.latitude == event.latLng?.lat) &&
                          (d.longitude == event.latLng?.lng)) {
                        Future.delayed(Duration(milliseconds: 400), () {
                          controller!.onMarkerSelected.value = d;
                        });
                      }
                    }
                  });
                }
              });
        }
      });

      elem.onClick.listen((event) {
        controller!.onMarkerSelected.value = AppDataModel();
      });
      elem.onDoubleClick.listen((event) {
        map.zoom = 10;
      });

      return elem;
    });

    // return HtmlElementView(key: UniqueKey(), viewType: htmlId);
  }
}
