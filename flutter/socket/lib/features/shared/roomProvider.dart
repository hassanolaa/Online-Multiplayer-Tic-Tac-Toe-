import 'package:flutter/material.dart';
import 'package:socket/features/createAndJoin/models/player.dart';

class roomDataProvider extends ChangeNotifier {
  Map<String, dynamic> roomdata = {};

  List<String> boardElements = ["", "", "", "", "", "", "", "", ""];
  int fillBoxs = 0;

  Player player1 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 'X',
  );

  Player player2 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 'O',
  );

  Player get getPlayer1 => player1;
  Player get getPlayer2 => player2;
  Map<String, dynamic> get getRoomData => roomdata;
  int get getFillBoxs => fillBoxs;

  // update the room
  void updateDataRoom(Map<String, dynamic> data) {
    roomdata = data;
    notifyListeners();
  }

  // update player 1
  void updatePlayer1(Map<String, dynamic> data) {
    player1 = Player.fromMap(data);

    notifyListeners();
  }

  // update player 2
  void updatePlayer2(Map<String, dynamic> data) {
    player2 = Player.fromMap(data);

    notifyListeners();
  }

  // update the board
  void updateDisplayElements(int index, String choice) {
    boardElements[index] = choice;
    fillBoxs += 1;
    notifyListeners();
  }

  void setFilledBoxesTo0() {
    fillBoxs = 0;
    notifyListeners();
  }
}
