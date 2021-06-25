import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:beauty_spin/Models/coinsTransactionsModel.dart';
import 'package:beauty_spin/Screens/UserProfile/UserProfileController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class WalletScreenController extends GetxController {
  RxDouble accountBal = 0.0.obs;
  RxList<TransactionModel> transactions = RxList<TransactionModel>();
  RxBool isGettingTransactions = false.obs;
  String? docId;

  @override
  void onReady() {
    if (Get.arguments != null) {
      if (Get.arguments['docId'] != null) docId = Get.arguments['docId'];
      if (Get.arguments['accountBal'] != null)
        accountBal.value = Get.arguments['accountBal'];
      if (docId != null) getAccountTransactions();
    }
    super.onReady();
  }

  void getAccountTransactions() {
    isGettingTransactions.value = true;
    FirebaseFirestore.instance
        .collection(kWalletListKey)
        .doc(docId)
        .get()
        .then((doc) {
      if (doc.data() != null) {
        final List<dynamic> list = doc.data()![kWalletTransactions];
        final transactionsList = list.map((e) => TransactionModel.fromJson(e));
        transactions.clear();
        transactions.addAll(transactionsList);
        transactions
            .sort((e1, e2) => e2.transactionOn.compareTo(e1.transactionOn));
        isGettingTransactions.value = false;
      } else {
        isGettingTransactions.value = false;
      }
    });
  }

  void addTransactions(num amount) {
    // Updating user bal
    final UserProfileScreenController userController = Get.find();
    final currentUser = userController.user.value;
    final userRef = FirebaseFirestore.instance
        .collection(kUserCollectionKey)
        .doc(currentUser.docId);
    userRef.get().then((user) {
      if (user.data() != null) {
        final double currentBal = user.data()![kUWalletBalance];
        currentUser.accountBal!.value = currentBal + amount;
        userRef.update({kUWalletBalance: currentBal + amount});
      }
    });

    // Updating transaction history
    final docRef = FirebaseFirestore.instance
        .collection(kWalletListKey)
        .doc(currentUser.walletId);
    docRef.get().then((doc) {
      if (doc.data() != null) {
        List<dynamic> list = doc.data()![kWalletTransactions];

        list.add({
          kWalletTransactionAmount: amount,
          kWalletTransactionType: 0,
          kWalletTransactionOn: Timestamp.now()
        });
        final double currentBal = doc.data()![kWalletBalance];
        docRef.update({
          kWalletTransactions: list,
          kWalletBalance: currentBal + amount,
        });
      }
    });
  }
}
