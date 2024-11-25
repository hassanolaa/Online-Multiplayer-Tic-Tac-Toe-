

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket/core/theming/colors.dart';
import 'package:socket/core/theming/size.dart';
import 'package:socket/features/shared/socketfun.dart';

import '../../shared/socketfun.dart';

class createRoom extends StatefulWidget {
  const createRoom({super.key});

  @override
  State<createRoom> createState() => _createRoomState();
}

class _createRoomState extends State<createRoom> {

  TextEditingController userName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketFunction().createRoomListener(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          context.height_box(0.1),
          Text("Create Room",style: TextStyle(fontSize: 30),),
          context.height_box(0.1),
          // userName
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: userName,
              decoration: InputDecoration(
                hintText: "Enter User Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          context.height_box(0.1),
          ElevatedButton(
            onPressed: (){
              if (userName.text.isNotEmpty) {
                socketFunction().createRoom(userName.text);  
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter user Name"),backgroundColor: colors.liveText,));
              }
            },
            child: Text("Create Room"),
          ),
        ],
      ),
    );
  }
}