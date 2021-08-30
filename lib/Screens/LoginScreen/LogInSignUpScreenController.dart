import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Constants/StringConstants.dart';
import 'package:beauty_spin/Models/UserModel.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfileController.dart';
import 'package:beauty_spin/Services/CookieManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LogInSignUpScreenController extends GetxController {
  UserProfileScreenController userController = Get.find();

  //
  RxBool showLoader = false.obs;

  // RxBool isNoEntered = false.obs;
  // TextEditingController phoneNumberController = TextEditingController();
  // FocusNode phoneNumberFocusNode = FocusNode();
  // TextEditingController otpController = TextEditingController();
  // FocusNode otpFocusNode = FocusNode();

  final auth = FirebaseAuth.instance;
  ConfirmationResult? confirmationResult;

  String sortedPNo = '';

  @override
  void onInit() {
    userController.phoneNumberController.text = sCountryCode;
    userController.phoneNumberFocusNode.requestFocus();
    super.onInit();
  }

  void emptyControllers() {
    userController.phoneNumberController.text = sCountryCode;
    userController.otpController.text = '';
    userController.isNoEntered.value = false;
  }

  void onPhoneNoTextChanged(String value) {
    if (value.length < 2) {
      userController.phoneNumberFocusNode.unfocus();
      userController.phoneNumberController.text = sCountryCode;
      Future.delayed(1.milliseconds).then((value) {
        userController.phoneNumberFocusNode.requestFocus();
      });
    }
  }

  void resendOtp() async {
    final result = await auth.signInWithPhoneNumber(
        sortedPNo,
        RecaptchaVerifier(
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.dark,
          onSuccess: () {
            RecaptchaVerifier().clear();
          },
          onError: (FirebaseAuthException error) => print(error),
          onExpired: () => print('reCAPTCHA Expired!'),
        ));
    confirmationResult = result;
    userController.otpFocusNode.requestFocus();
  }

  void nextButtonTapped() async {
    String sortedPhoneNo =
        userController.phoneNumberController.text.replaceAll('(', '');
    sortedPhoneNo = sortedPhoneNo.replaceAll(')', '');
    sortedPhoneNo = sortedPhoneNo.replaceAll('-', '');
    sortedPhoneNo = sortedPhoneNo.replaceAll(' ', '');
    print(sortedPhoneNo);
    sortedPNo = sortedPhoneNo;
    if (sortedPhoneNo.length >= 10) {
      showLoader.value = true;
      final result = await auth.signInWithPhoneNumber(
          sortedPhoneNo,
          RecaptchaVerifier(
            // size: RecaptchaVerifierSize.compact,
            theme: RecaptchaVerifierTheme.dark,
            onSuccess: () {
              RecaptchaVerifier().clear();
            },
            onError: (FirebaseAuthException error) => print(error),
            onExpired: () => print('reCAPTCHA Expired!'),
          ));
      confirmationResult = result;
      userController.isNoEntered.value = true;
      showLoader.value = false;
      userController.otpFocusNode.requestFocus();
    }
  }

  void verifyPhoneAndGetUser() {
    final result = confirmationResult;
    if (userController.isNoEntered.value &&
        userController.otpController.text.length == 6 &&
        result != null) {
      showLoader.value = true;
      final credentials = PhoneAuthProvider.credential(
          verificationId: result.verificationId,
          smsCode: userController.otpController.text);
      auth.signInWithCredential(credentials).then((value) {
        CookieManager.addToCookie(skUserAccessToken, value.user!.uid);
        FirebaseFirestore.instance
            .collection(kUserCollectionKey)
            .where(kUPhoneNo, isEqualTo: value.user!.phoneNumber)
            .get()
            .then((snap) {
          final users = snap.docs.map((e) => UserModel.fromJson(e.data()));
          print('UserLength');
          print(users.length);
          if (users.isNotEmpty) {
            // Checking last recorded spin and adding in firebase
            String lastSpinTimeString = '';

            if (users.first.lastSpinDateTimeString != '') {
              DateTime lastSpinDateTime =
                  DateTime.parse(users.first.lastSpinDateTimeString!);

              if (lastSpinDateTime.year == DateTime.now().year &&
                  lastSpinDateTime.month == DateTime.now().month &&
                  (lastSpinDateTime.day == DateTime.now().day ||
                      lastSpinDateTime.add(4.hours).day ==
                          DateTime.now().day)) {
                lastSpinTimeString = users.first.lastSpinDateTimeString!;
              } else {
                lastSpinTimeString = CookieManager.getCookie(kLastSpinTimekey);
              }
            } else {
              lastSpinTimeString = CookieManager.getCookie(kLastSpinTimekey);
            }

            FirebaseFirestore.instance
                .collection(kUserCollectionKey)
                .doc(users.first.docId)
                .update({
              kUFirebaseUserId: value.user!.uid,
              kLastSpinTimekey: lastSpinTimeString,
            });
            userController.user.value = users.first;
            userController.user.value.lastSpinDateTimeString =
                lastSpinTimeString;
            CookieManager.addToCookie(kLastSpinTimekey, lastSpinTimeString);
            userController.hasUser.value = true;

            if (userController.user.value.name!.length > 2)
              userController.hasUserName.value = true;
            userController
                .updateSessionToPhone(userController.user.value.docId);
            userController.checkIsWinnerListHasUser();

            // Checking and updating user streak

            final userDateTime =
                userController.user.value.lastStreakAddedOn!.toDate();
            if (userDateTime.day == DateTime.now().day &&
                userDateTime.month == DateTime.now().month &&
                userDateTime.year == DateTime.now().year) {
              print('Today\'s streak already done');
            } else {
              if ((DateTime.now().day - userDateTime.day) > 1 ||
                  (DateTime.now().month - userDateTime.month) >= 1 ||
                  (DateTime.now().year - userDateTime.year) >= 1) {
                FirebaseFirestore.instance
                    .collection(kUserCollectionKey)
                    .doc(users.first.docId)
                    .update({
                  kUStreakValue: 0,
                  kULastStreakAddedOn: DateTime.now(),
                }).then((value) {
                  userController.user.value.streakValue = 0;
                  userController.user.value.lastStreakAddedOn = Timestamp.now();
                  userController.addStreak();
                  userController.addTransaction();
                });
              } else {
                userController.addStreak();
                userController.addTransaction();
              }
              //

            }
          } else {
            userController.phoneSignInNo = value.user!.phoneNumber;
            userController.firebaseUserId = value.user!.uid;
            userController.createUser(UserType.PhoneNo);
          }
          userController.isUserSignedIn.value = true;
          emptyControllers();
          showLoader.value = false;
        });
      });
    }
  }

  googleLoginHandler() async {
    try {
      await userController.googleSignIn.signIn();
      CookieManager.addToCookie(
          skUserAccessToken, userController.googleSignIn.currentUser!.id);
      FirebaseFirestore.instance
          .collection(kUserCollectionKey)
          .where(kUFirebaseUserId,
              isEqualTo: userController.googleSignIn.currentUser!.id)
          .get()
          .then((snap) {
        final users = snap.docs.map((e) => UserModel.fromJson(e.data()));
        print('UserLength');
        print(users.length);
        if (users.isNotEmpty) {
          userController.user.value = users.first;
          userController.hasUser.value = true;
          userController.updateSessionToGoogle(userController.user.value.docId);
          userController.checkIsWinnerListHasUser();
        } else {
          userController.createUser(UserType.Google);
        }
        userController.isUserSignedIn.value = true;
        userController.hasUserName.value = true;
      });
    } catch (error) {
      print(error);
      userController.isUserSignedIn.value = false;
    }
  }
}
