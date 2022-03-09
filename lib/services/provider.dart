import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  String? _playerName;

  String get playerName => _playerName!;
  set playerName(String playerName) {
    _playerName = playerName;
    notifyListeners();
  }

  void changePlayerName(String playerName) {
    _playerName = playerName;
    notifyListeners();
  }
}
