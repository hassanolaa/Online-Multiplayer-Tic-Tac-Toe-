

import 'package:flutter/material.dart';
import 'package:socket/core/theming/size.dart';
import 'package:socket/core/theming/colors.dart';

import '../../shared/socketfun.dart';

class joinroom extends StatefulWidget {
  const joinroom({super.key});

  @override
  State<joinroom> createState() => _joinroomState();
}

class _joinroomState extends State<joinroom> {

  TextEditingController roomid = TextEditingController();
  TextEditingController userName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketFunction().errorListener(context);
    socketFunction().joinRoomListener(context);
    socketFunction().updateRoomListener(context);
    socketFunction().updatePlayersListener(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          context.height_box(0.1),
          Text("Join Room",style: TextStyle(fontSize: 30),),
            context.height_box(0.1),
            // roomid
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: roomid,
              decoration: InputDecoration(
                hintText: "Enter Room Id",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          context.height_box(0.1),
          // username
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: userName,
              decoration: InputDecoration(
                hintText: "Enter user name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          context.height_box(0.1),
          ElevatedButton(
            onPressed: (){
              if (userName.text.isNotEmpty|| roomid.text.isNotEmpty) {
                socketFunction().joinRoom(userName.text, roomid.text);  
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter user name and room id"),backgroundColor: colors.liveText,));
              }
            },
            child: Text("Join Room"),
          ),
        ],
      ),
    );
  }
}