import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pac_man/path.dart';
import 'package:pac_man/pixel.dart';
import 'package:pac_man/pixel.dart';
import 'package:pac_man/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  // State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;
  int player = numberInRow * 10 + 1;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    88,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
    158,
    160,
  ];

  List<int> food = [];


  String direction = "right";
  bool preGame = true;
  bool mouthClosed = false;

  void startGame(){
    preGame = false;
    getFood();
    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });

      if(food.contains(player)){
        food.remove(player);
      }

      switch(direction){
        case"left":
          moveLeft();
          break;
        case"right":
          moveRight();
          break;
        case"up":
          moveUp();
          break;
        case"down":
          moveDown();
          break;
      }


    });
  }
  void getFood() {
    for(int i =0;i< numberOfSquares;i++){
      if(!barriers.contains(i)){
        food.add(i);
      }
    }
  }

  void moveLeft(){
    if(!barriers.contains(player-1)){
      setState(() {
        player--;
      });

    }
  }
  void moveRight(){
    if(!barriers.contains(player+1)){
      setState(() {
        player++;
      });
    }
  }
  void moveUp(){
    if(!barriers.contains(player - numberInRow)){
      setState(() {
        player-=numberInRow;
      });
    }
  }
  void moveDown(){
    if(!barriers.contains(player+numberInRow)){
      setState(() {
        player+=numberInRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details){
                if(details.delta.dy >0){
                  direction = "down";
                } else if (details.delta.dy<0){
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details){
            if(details.delta.dx >0){
            direction = "right";
            } else if (details.delta.dx<0){
            direction = "left";
            }
            print(direction);
            },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInRow),
                    itemBuilder: (BuildContext context, int index) {
                      if(mouthClosed && player == index){
                        return Padding(padding: EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle
                          ),
                        ),);
                      }
                      else if (player == index) {
                        switch(direction){
                          case "left":
                            return Transform.rotate(angle: pi,child: MyPlayer(),);
                            break;

                          case "right":
                            MyPlayer();
                            break;

                          case "up":
                            return Transform.rotate(angle: 3*pi/2,child: MyPlayer(),);
                            break;

                          case "down":
                            return Transform.rotate(angle: pi/2,child: MyPlayer(),);
                            break;
                        }

                      } else if (barriers.contains(index)) {
                        return MyPixel(
                          innerColor: Colors.blue[800],
                          outerColor: Colors.blue[900],
                          // child: Text(index.toString()),
                        );
                      } else {
                        return MyPath(
                          innerColor: Colors.yellow,
                          outerColor: Colors.black,
                          // child: Center(child: Text(index.toString())
                        );
                      }
                    }),
              ),
            ),
          ),
           Expanded(
            child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Score : ", style: TextStyle(color: Colors.white, fontSize: 40),),
                GestureDetector(
                  onTap: startGame, child: Text("P L A Y", style: TextStyle(color: Colors.white, fontSize: 40),),),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}
