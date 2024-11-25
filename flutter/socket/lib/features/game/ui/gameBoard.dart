import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/core/theming/colors.dart';
import 'package:socket/features/shared/roomProvider.dart';

import '../../shared/socketfun.dart';

class gameBoard extends StatefulWidget {
  const gameBoard({super.key});

  @override
  State<gameBoard> createState() => _gameBoardState();
}

class _gameBoardState extends State<gameBoard> {
  socketFunction socketfun = socketFunction();

  @override
  void initState() {
    super.initState();
    socketFunction().updateRoomListener(context);
    socketFunction().updatePlayersListener(context);
    socketFunction().updateBoardListener(context);
  }

  Widget build(BuildContext context) {
    roomDataProvider roomDatapro = Provider.of<roomDataProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            // Players names and scores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Player 1
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        roomDatapro.player1.nickname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        roomDatapro.player1.points.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                // Player 2
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        roomDatapro.player2.nickname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        roomDatapro.player2.points.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           
           // Game board
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                maxWidth: 500,
              ),
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AbsorbPointer(
                    absorbing: roomDatapro.roomdata['turn']['socketID'] !=socketFunction().socket.id,
                    child: GestureDetector(
                      onTap: () {
                        socketFunction().tapBox(
                            index,
                            roomDatapro.roomdata['_id'],
                            roomDatapro.boardElements);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.coco,
                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),
                        child: Center(
                          child: AnimatedSize(
                            duration: Duration(milliseconds: 200),
                            child: Text(
                              roomDatapro.boardElements[index],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 138, 59, 59),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 100,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 40,
                                      color: Colors.blue,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
           // Turn indicator
            Text('${roomDatapro.roomdata['turn']['nickname']}\'s turn'),
          ],
        ),
      ),
    );
  }
}
