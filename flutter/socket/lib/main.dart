import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:socket/features/createAndJoin/ui/menuscreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'features/createAndJoin/ui/createroom.dart';
import 'features/shared/roomProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => roomDataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
      //  home: ChatScreen(),
        home: menuScreen(),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Controller for the text input
  final TextEditingController _controller = TextEditingController();
  // List to store messages
  final List<Map<String, dynamic>> _messages = [];

  String id = "";
  String username = "";

  IO.Socket socket = IO.io("http://localhost:8080", {"transports": ["websocket"],"autoConnect": false});


  socketfun() {
    socket.connect();
    socket.onConnect((data) => {print("connected")});

    socket.on("userdata",(data) => {
              setState(() {
                id = data["id"];
                username = data["username"];
              })
            });

    socket.on("res",(data) => {
              setState(() {
                _messages.add(data);
              })
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketfun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // ListView to display messages
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: _messages[index]["id"] == id
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Card(
                      color: _messages[index]["id"] == id
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Text(
                          _messages[index]["msg"]+"from "+_messages[index]["username"],
                          style: TextStyle(
                            color: _messages[index]["id"] == id
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field for new message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                   // socket.emit("message", _controller.text);
                    socket.emit("message", {"msg": _controller.text,"username":username});
                    
                    _controller.clear();
                  },
                  //  onPressed: _sendMessage,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
