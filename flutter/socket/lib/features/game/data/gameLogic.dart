
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/core/routing/router.dart';
import 'package:socket/features/game/ui/gameBoard.dart';
import 'package:socket/features/shared/roomProvider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class gameLogic {
  void checkWinner(BuildContext context, Socket socketClent) {
    roomDataProvider roomDataPro =Provider.of<roomDataProvider>(context, listen: false);

    String winner = '';

    // Checking rows
    if (roomDataPro.boardElements[0] ==
            roomDataPro.boardElements[1] &&
        roomDataPro.boardElements[0] ==
            roomDataPro.boardElements[2] &&
        roomDataPro.boardElements[0] != '') {
      winner = roomDataPro.boardElements[0];
    }
    if (roomDataPro.boardElements[3] ==
            roomDataPro.boardElements[4] &&
        roomDataPro.boardElements[3] ==
            roomDataPro.boardElements[5] &&
        roomDataPro.boardElements[3] != '') {
      winner = roomDataPro.boardElements[3];
    }
    if (roomDataPro.boardElements[6] ==
            roomDataPro.boardElements[7] &&
        roomDataPro.boardElements[6] ==
            roomDataPro.boardElements[8] &&
        roomDataPro.boardElements[6] != '') {
      winner = roomDataPro.boardElements[6];
    }

    // Checking Column
    if (roomDataPro.boardElements[0] ==
            roomDataPro.boardElements[3] &&
        roomDataPro.boardElements[0] ==
            roomDataPro.boardElements[6] &&
        roomDataPro.boardElements[0] != '') {
      winner = roomDataPro.boardElements[0];
    }
    if (roomDataPro.boardElements[1] ==
            roomDataPro.boardElements[4] &&
        roomDataPro.boardElements[1] ==
            roomDataPro.boardElements[7] &&
        roomDataPro.boardElements[1] != '') {
      winner = roomDataPro.boardElements[1];
    }
    if (roomDataPro.boardElements[2] ==
            roomDataPro.boardElements[5] &&
        roomDataPro.boardElements[2] ==
            roomDataPro.boardElements[8] &&
        roomDataPro.boardElements[2] != '') {
      winner = roomDataPro.boardElements[2];
    }

    // Checking Diagonal
    if (roomDataPro.boardElements[0] ==
            roomDataPro.boardElements[4] &&
        roomDataPro.boardElements[0] ==
            roomDataPro.boardElements[8] &&
        roomDataPro.boardElements[0] != '') {
      winner = roomDataPro.boardElements[0];
    }
    if (roomDataPro.boardElements[2] ==
            roomDataPro.boardElements[4] &&
        roomDataPro.boardElements[2] ==
            roomDataPro.boardElements[6] &&
        roomDataPro.boardElements[2] != '') {
      winner = roomDataPro.boardElements[2];
    } else if (roomDataPro.fillBoxs == 9) {
      winner = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
           content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Draw!'),
               TextButton(
              onPressed: () {
                gameLogic().clearBoard(context);
                context.navigateTo(gameBoard());
              },
              child: const Text(
                'Play Again',
              ),
            ),
            ],
          ), backgroundColor: Colors.yellow,
        ),
      );
    }

    if (winner != '') {
      if (roomDataPro.player1.playerType == winner) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
           content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('${roomDataPro.player1.nickname} won!'),
               TextButton(
              onPressed: () {
                gameLogic().clearBoard(context);
                context.navigateTo(gameBoard());

              },
              child: const Text(
                'Play Again',
              ),
            ),
            ],
          ), backgroundColor: Colors.green,
        ),
      );
      
        socketClent.emit('winner', {
          'winnerSocketId': roomDataPro.player1.socketID,
          'roomId': roomDataPro.roomdata['_id'],
        });
      } else {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('${roomDataPro.player2.nickname} won!'),
               TextButton(
              onPressed: () {
                gameLogic().clearBoard(context);
               context.navigateTo(gameBoard());

              },
              child: const Text(
                'Play Again',
              ),
            ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
       socketClent.emit('winner', {
          'winnerSocketId': roomDataPro.player2.socketID,
          'roomId': roomDataPro.roomdata['_id'],
        });
      }
    }
  }

  void clearBoard(BuildContext context) {
    roomDataProvider roomDataPro =
        Provider.of<roomDataProvider>(context, listen: false);

    for (int i = 0; i < roomDataPro.boardElements.length; i++) {
      roomDataPro.updateDisplayElements(i, '');
    }
    roomDataPro.setFilledBoxesTo0();
  }
}