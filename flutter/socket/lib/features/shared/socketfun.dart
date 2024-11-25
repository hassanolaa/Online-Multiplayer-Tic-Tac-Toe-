import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/core/routing/router.dart';
import 'package:socket/features/createAndJoin/ui/lobby.dart';
import 'package:socket/features/game/data/gameLogic.dart';
import 'package:socket/features/shared/roomProvider.dart';
import 'package:socket/features/shared/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class socketFunction {
  final socket = SocketClient.instance.socket!;



  // create room
  void createRoom(String userName) {
    socket.emit("createRoom", userName);
  }

  // join room
  void joinRoom(String userName, String roomId) {
    socket.emit("joinRoom", {"userName": userName, "roomId": roomId});
  }

  // tap box
  void tapBox(
    int index,
    String roomId,
    List<String> boardElements,
  ) {
    if (boardElements[index] == "") {
      socket.emit("tapBox", {"index": index, "roomId": roomId});
    }
  }

  // listeners

  // create room listener
  void createRoomListener(BuildContext context) {
    socket.on("roomCreated", (data) {
      Provider.of<roomDataProvider>(context, listen: false)
          .updateDataRoom(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Room Created"), backgroundColor: Colors.green));
      context.navigateTo(lobby());
    });
  }

  // join room listener
  void joinRoomListener(BuildContext context) {
    socket.on("roomJoined", (data) {
      Provider.of<roomDataProvider>(context, listen: false)
          .updateDataRoom(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Room Joined"), backgroundColor: Colors.green));
      context.navigateTo(lobby());
    });
  }

  // error listener
  void errorListener(BuildContext context) {
    socket.on("error", (data) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data), backgroundColor: Colors.red));
    });
  }

  // update room listener
  void updateRoomListener(BuildContext context) {
    socket.on("updateRoom", (data) {
      Provider.of<roomDataProvider>(context, listen: false)
          .updateDataRoom(data);
    });
  }

  // update players listener
  void updatePlayersListener(BuildContext context) {
    socket.on("updatePlayers", (data) {
      Provider.of<roomDataProvider>(context, listen: false)
          .updatePlayer1(data[0]);
      Provider.of<roomDataProvider>(context, listen: false)
          .updatePlayer2(data[1]);
    });
  }

  // update board listener
  void updateBoardListener(BuildContext context) {
    socket.on("tapped", (data) {
      Provider.of<roomDataProvider>(context, listen: false)
          .updateDisplayElements(data["index"], data["choice"]);
      Provider.of<roomDataProvider>(context, listen: false)
          .updateDataRoom(data["room"]);
           gameLogic().checkWinner(context, socket);   
    });
  }
   
  // point increase listener
   void pointIncreaseListener(BuildContext context) {
    socket.on('pointIncrease', (playerData) {
      var roomDataPro =
          Provider.of<roomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataPro.player1.socketID) {
        roomDataPro.updatePlayer1(playerData);
      } else {
        roomDataPro.updatePlayer2(playerData);
      }
    });
  }

 // end game listener
  void endGameListener(BuildContext context) {
    socket.on('endGame', (playerData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${playerData['nickname']} won the game!'),
          backgroundColor: Colors.amber,
        ),
      );
      context.navigateTo(lobby());
    });
  }
}
