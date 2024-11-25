import 'package:flutter/material.dart';
import 'package:socket/core/routing/router.dart';
import 'package:socket/core/theming/colors.dart';
import 'package:socket/core/theming/size.dart';
import 'package:socket/features/createAndJoin/ui/createroom.dart';
import 'package:socket/features/createAndJoin/ui/joinroom.dart';

class menuScreen extends StatefulWidget {
  const menuScreen({super.key});

  @override
  State<menuScreen> createState() => _menuScreenState();
}

class _menuScreenState extends State<menuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
          context.height_box(0.3),
         // create room
            GestureDetector(
              onTap: () {
                context.navigateTo(createRoom());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors.coco,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: context.width(0.5),
                height: context.height(0.1),
                child: Center(child: Text("Create room")),
              ),
            ),
            context.height_box(0.1),
            // join room
            GestureDetector(
              onTap: () {
                context.navigateTo(joinroom());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors.coco,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: context.width(0.5),
                height: context.height(0.1),
                child: Center(child: Text("Join room")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
