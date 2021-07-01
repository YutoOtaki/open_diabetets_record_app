import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ArticleAndQuiz extends StatefulWidget {
  Text textArticle;
  Text textQuiz;
  String answer = "YES";

  ArticleAndQuiz(this.textArticle, this.textQuiz, this.answer);

  @override
  _ArticleAndQuizState createState() => _ArticleAndQuizState();
}

class _ArticleAndQuizState extends State<ArticleAndQuiz> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
      child: Column(
        children: [
          widget.textArticle,
          RaisedButton(
            child: const Text('クイズに挑戦', style: TextStyle(color: Colors.white),),
            color: Colors.green,
            //shape: const StadiumBorder(),
            onPressed: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text("クイズ"),

                    ),

                    body: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: SingleChildScrollView(
                                    child: widget.textQuiz
                                  ),
                                )
                            ),
                          ),
                          Container(
                              child: Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RaisedButton(
                                        child: const Text('YES', style: TextStyle(color: Colors.white)),
                                        color: Colors.green,
                                        shape: const StadiumBorder(),
                                        onPressed: () {
                                          checkAnswer("YES");


                                        },
                                      ),

                                      RaisedButton(
                                        child: const Text('NO', style: TextStyle(color: Colors.white)),
                                        color: Colors.orange,
                                        shape: const StadiumBorder(),
                                        onPressed: () {
                                          checkAnswer("NO");

                                        },
                                      )
                                    ],
                                  )))
                        ],
                      ),
                    ));
              }));
            },
          ),
        ],
      ),
    );
  }

  void checkAnswer(String choice){

    if(widget.answer == choice){

      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        body: Center(child: Text(
          "You are right!! Good job!!",
        ),),
        title: "Correct!",
        btnOkOnPress: () {},
      )..show();

    }else{

      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          "Oops! That's not a correct answer",
        ),),
        title: "Miss",
        btnOkColor: Colors.redAccent,
        btnOkOnPress: () {},
      )..show();

    }


  }
}
