import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageNotFound extends StatelessWidget {
  static const routeName = '/not_found';
  static GetPage getPage() => GetPage(
      name: routeName,
      page: () => PageNotFound(),
      title: 'not_found',
      transition: Transition.cupertino);
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s404, style: TextStyle(color: cRedColor, fontSize: 20)),
            SizedBox(height: 20),
            Text(sPageNotFound,
                style: TextStyle(color: cDarkGrayColor, fontSize: 18))
          ],
        )));
  }
}
