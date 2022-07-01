import 'package:flutter/material.dart';
import './color.dart';
import 'game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastvalue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];

  Game game = Game();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastvalue} turn".toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 58),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
                crossAxisCount: Game.boardlength ~/ 3,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.boardlength, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "")
                              setState(() {
                                game.board![index] = lastvalue;

                                turn++;
                                gameOver = game.winnerCheck(
                                    lastvalue, index, scoreboard, 3);
                                if (gameOver) {
                                  result = "$lastvalue is the Winner";
                                }else if(!gameOver && turn ==9){
                                  result="It's a Draw!";
                                  gameOver =true;
                                }

                                if (lastvalue == "X")
                                  lastvalue = "O";
                                else
                                  lastvalue = "X";
                              });
                          },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 64.0),
                        ),
                      ),
                    ),
                  );
                })),
          ),
          SizedBox(height: 25),

          Text(result,style: TextStyle(color: Colors.white,fontSize: 54),),

          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                game.board = Game.initGameBoard();
                lastvalue = "X";
                gameOver = false;
                turn=0;
                result="";
                scoreboard=[0,0,0,0,0,0,0,0];
              });
            },
            icon: Icon(Icons.replay),
            label: Text(
              "Repeat the Game",
            ),

          ),
        ],
      ),
    );
  }
}
