import 'package:flutter/foundation.dart';

class UserStateProvider extends ChangeNotifier {
  String _userName = 'Aarav Sharma';
  double _walletBalance = 540.0;
  
  String get userName => _userName;
  double get walletBalance => _walletBalance;

  void updateWallet(double amount) {
    _walletBalance += amount;
    notifyListeners();
  }

  void updateName(String name) {
    _userName = name;
    notifyListeners();
  }
}
