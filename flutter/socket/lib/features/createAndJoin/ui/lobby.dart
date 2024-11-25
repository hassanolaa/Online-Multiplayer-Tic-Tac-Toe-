import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket/features/game/ui/gameBoard.dart';
import 'package:socket/features/shared/socketfun.dart';

import '../../shared/roomProvider.dart';

class lobby extends StatefulWidget {
  const lobby({super.key});

  @override
  State<lobby> createState() => _lobbyState();
}

class _lobbyState extends State<lobby> {
  late TextEditingController roomIdController;

  @override
  void initState() {
    super.initState();
    roomIdController = TextEditingController(text:  Provider.of<roomDataProvider>(context, listen: false).roomdata['_id'],);
    socketFunction().updateRoomListener(context);
    socketFunction().updatePlayersListener(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // check if the room is joined or not
        child: Provider.of<roomDataProvider>(context).roomdata["isJoin"] == true
            ? Column(
                children: [
                  // room id 
                  TextField(
                    controller: roomIdController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                  // button to copy the id
                ],
              )
              // if the room is joined then show the game board
            :gameBoard(),
      ),
    );
  }
}
