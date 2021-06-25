import 'package:beauty_spin/Constants/KeysConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  int type; // 0 for added , 1 for withdrawal
  double amount;
  Timestamp transactionOn;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.transactionOn,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        type: json[kWalletTransactionType],
        amount: json[kWalletTransactionAmount],
        transactionOn: json[kWalletTransactionOn],
      );

  Map<String, dynamic> toJson() => {
        kWalletTransactionType: type,
        kWalletTransactionAmount: amount,
        kWalletTransactionOn: transactionOn,
      };
}
