import 'package:botox_deals/Screens/LoginScreen/PhoneLoginScreen/PhoneLoginAndSignupScreen.dart';
import 'package:botox_deals/Screens/ReferralsScreen/Referrals.dart';
import 'package:botox_deals/Screens/UserProfile/UserProfileController.dart';
import 'package:botox_deals/Screens/DetailsScreen/DetailsScreen.dart';
import 'package:botox_deals/Screens/HomeScreen/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Constants/ColorConstants.dart';
import 'Screens/PageNotFond/PageNotFound.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserProfileScreenController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyMaterialApp();
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(color: cAppThemeColor)),
      title: 'BeautiDeals',
      enableLog: false,
      popGesture: true,
      initialRoute: HomeScreen.routeName,
      getPages: [
        HomeScreen.getPage(),
        DetailsScreen.getPage(),
        Referrals.getPage(),
        PageNotFound.getPage(),
        PhoneLoginAndSignupScreen.getPage(),
      ],
      unknownRoute: PageNotFound.getPage(),
    );
  }
}
