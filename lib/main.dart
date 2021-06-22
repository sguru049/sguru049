import 'package:beauty_spin/Screens/LoginScreen/PhoneLoginScreen/PhoneLoginAndSignupScreen.dart';
import 'package:beauty_spin/Screens/ReferralsScreen/Referrals.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfileController.dart';
import 'package:beauty_spin/Screens/DetailsScreen/DetailsScreen.dart';
import 'package:beauty_spin/Screens/HomeScreen/HomeScreen.dart';
import 'package:beauty_spin/Services/CurrentLocationController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Constants/ColorConstants.dart';
import 'Screens/PageNotFond/PageNotFound.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserProfileScreenController());
  Get.put(CurrentLocationController());
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
      title: 'Beauty Spin',
      enableLog: false,
      popGesture: true,
      initialRoute: HomeScreen.routeName,
      // initialRoute: '/', // FOR TESTING FORTUNE WHEEL
      getPages: [
        // GetPage(name: '/', page: () => FortuneWheelScreen()), // FOR TESTING FORTUNE WHEEL
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
