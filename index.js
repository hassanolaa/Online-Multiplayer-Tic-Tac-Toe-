



const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const socketIo = require('socket.io');
const http= require('http'); 
const user = require('./app');
const { randomInt } = require('crypto');
const Room = require('./models/room'); 

// connect to mongodb

mongoose.connect("your MongoDB url", { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.log('Error connecting to MongoDB:', err));


const app = express();

const server = http.createServer(app);

const io = socketIo(server);

// middleware
app.use(bodyParser.json());

// create a Socket
io.on('connection',(client)=>{
    console.log('User connected');

    // create a room
    client.on("createRoom",async (username)=>{
    let room = new Room();
    let player = {
        socketID:client.id,
        nickname:username,
        playerType: "X",
    }
    room.players.push(player);
    room.turn = player;
    room = await room.save();
    console.log("Room created");

    roomid= room._id.toString();
    
    client.join(roomid);
     
    // send a message to confirm the creation
    client.emit("roomCreated",room);
    })
    
    // join a room
    client.on("joinRoom",async ({userName,roomId})=>{
    
        console.log("User joined room000");
       if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
            client.emit("error","Invalid room id");
            return;
        
       }else{
        let room = await Room.findById(roomId);
    
        if(room.isJoin){
          let player ={
            socketID:client.id,
            nickname:userName,
            playerType: "O",
          } 

            client.join(roomId);
            room.players.push(player);
            room.isJoin = false;
            room = await room.save();

            
            client.emit("roomJoined",room);
            io.to(roomId).emit("updatePlayers", room.players);
            io.to(roomId).emit("updateRoom", room);


         
        }else{
            client.emit("error","The room is full");
        }
        
        
       }

       console.log("User joined room");        
    
    })
    

    // tap box
    client.on("tapBox",async({index,roomId})=>{
    try{
        let room = await Room.findById(roomId);    
        let  choice = room.turn.playerType;
        if(room.turnIndex==0){
            room.turnIndex=1;
            room.turn = room.players[1];
        }else{
            room.turnIndex=0;
            room.turn = room.players[0];
        }
        room = await room.save();

        io.to(roomId).emit("tapped", {
            index, 
            choice,
            room, 
        });
     
    }catch(err){
        console.log(err);
    }  
    });

    // check winner
    client.on("winner", async ({ winnerSocketId, roomId }) => {
        try {
          let room = await Room.findById(roomId);
          let player = room.players.find(
            (playerr) => playerr.socketID == winnerSocketId
          );
          player.points += 1;
          room = await room.save();
    
          if (player.points >= room.maxRounds) {
            io.to(roomId).emit("endGame", player);
          } else {
            io.to(roomId).emit("pointIncrease", player);
          }
        } catch (e) {
          console.log(e);
        }
      });

   //client.broadcast.emit('message',{"id": client.id, "msg": "Welcome to the chat"}); // send message to all clients except the sender
   // io.to(client.id).emit('message',{"id": client.id, "msg": "Welcome to the chat"}); // send message to specific client    
})



server.listen(8080,()=>{
    console.log('Server is running on port 8080');
})










