

import 'dart:io';

import 'package:http/http.dart'as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async{

  print("hello world");

   IO.Socket socket = IO.io('http://localhost:8080',{"transports":["websocket"],"autoConnect":false});
    socket.connect();
    socket.onConnect((data) {
      print("connected");
      
      
      socket.emit("message", "hello");
      socket.on("message", (data) {
        print(data["id"]);
      });
  
  
  //      while(socket.active){
  //   print("Enter message");
  //   String message = stdin.readLineSync()!;
  //   if(message == "0"){
  //     socket.disconnect();
  //     break;
  //   }
  //   socket.emit("message", message);
  //   socket.on("message", (data) {
  //     print(data);
  //   });
  // }


    });

    socket.onDisconnect((data) => print("disconnected"));

    // socket.emit("message","hello server");0
    
    // socket.on("message", (data) {
    //   print(data);
    // });
  
 



}