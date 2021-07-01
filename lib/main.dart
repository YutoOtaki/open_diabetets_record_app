import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'patientmodel.dart';
import 'measuredata.dart';
import 'userinputform.dart';
import 'gadgets.dart';
import 'article.dart';
import 'articlelist.dart';

// TODO
// 最新の測定値がlatestにくるようにする。
// 履歴から測定値を削除できるようにする
// リファクタリングする

void main() {
  PatientModel patient = PatientModel();
  MeasureDataList userData;

  Hive.registerAdapter(MeasureDataAdapter());
  Hive.registerAdapter(MeasureDataListAdapter());

  Hive.initFlutter().then((value) {
    Hive.openBox<MeasureDataList>(boxName).then((value) {
      userData = value.get(labelName);
      print('loading data : $userData');
      //print('loading data : ${userData.dataList.length}');

      if (userData == null) {
        print("MeasureDataList was created");
        userData = MeasureDataList();
      }

      patient.userDataList = userData;

      // delete all data
      //patient.userDataList = MeasureDataList();
      //patient.saveUserDataList();

      patient.initiate();
    });
  });

  runApp(MyApp(patient));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final PatientModel patient;
  MyApp(this.patient);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => this.patient,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Glucose App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      /*
      appBar: AppBar(
        title: Text("Recorder"),
        //elevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        actions: [
          IconButton(icon: Icon(Icons.history), onPressed: (){
            print("Button pushed");
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){

              return historyList(context);
            }));
          })
        ],
      ),


       */
      body: Container(child: MainPage()),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Expanded(
            flex: 4,
            child: Container(
              child: upperPanel(context),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          "images/steve-halama-jMlgFOiJLXc-unsplash.jpg"))),
            ),
          ),

          Expanded(flex:13, child: combinedPanel(context))
        ],
      ),
    );
  }

  Widget upperPanel(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(40, 30, 8, 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: CircularStepProgressIndicator(
                  totalSteps: 300,
                  currentStep: Provider.of<PatientModel>(context).latestBg > 0
                      ? Provider.of<PatientModel>(context).latestBg
                      : 0,
                  stepSize: 10,
                  selectedColor: bgIndicateColor(
                      context, Provider.of<PatientModel>(context).latestBg),
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 145,
                  height: 145,
                  selectedStepSize: 10,
                  roundedCap: (_, __) => true,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Latest BG",
                    style: TextStyle(color: Colors.white),
                  ),

                  Text(Provider.of<PatientModel>(context).latestBg.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      )),
                  Text(
                    "mg/dL",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(25, 30, 8, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(),
                Text("Date Time",
                style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                  '${Provider.of<PatientModel>(context).latestMeasureTime}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Divider(thickness: 1,),
                Text("Tag",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                  '${Provider.of<PatientModel>(context).latestTag}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),


              ],
            ))
      ],
    );
  }
  
  Widget combinedPanel(BuildContext context){
    
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image:
              AssetImage("images/tim-mossholder-J0sMjGu6jvQ-unsplash.jpg"))),
      
      child: Column(
        children: [
          Divider(),
          Text(
            "BG trends",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 20),
          ),
          Expanded(flex:4 ,child: middlePanel(context)),
          Expanded(flex:4, child: bottomPanel(context)),
          bottomBar(context),

        ],
      ),
    );
        
  }

  Widget middlePanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(3)),
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              aXisStrictTimeSeriesBgChart(context),
            ],
          )),
    );
  }

  Widget bottomPanel(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,

      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            "Today's article",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 20),
          ),
          Flexible(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(8), child: articleList[Provider.of<PatientModel>(context).quizIndex]),
          ),
          //Divider(),
          //bottomBar(context)
        ],
      ),
    );
  }

  Widget bottomBar(BuildContext context){

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text("enter",
              style: TextStyle(color: Colors.white),),
            IconButton(
                icon: Icon(Icons.create),
                color: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return UserInputForm();
                      });
                }),
          ],
        ),
        Column(
          children: [
            Text("history",
              style: TextStyle(color: Colors.white),),
            IconButton(
                icon: Icon(Icons.history),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return historyList(context);
                  }));
                }),
          ],
        ),

        Consumer<PatientModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                Text("add",
                  style: TextStyle(color: Colors.white),),
                IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      print("${model.quizIndex}");
                      print("${articleList.length-1}");

                      if(articleList.length-1 == model.quizIndex){

                      }else {

                        model.quizIndex++;
                        model.notify();

                      }
                    }),
              ],
            );
          }
        )
      ],
    );
  }
}

Widget historyList(BuildContext context) {
  MeasureDataList userDataList;
  userDataList = Provider.of<PatientModel>(context).userDataList;
  int _count = userDataList.dataList.length;

  return Scaffold(
    appBar: AppBar(
      title: Text("History"),
    ),
    body: Container(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return dataPanel(context, userDataList, index);
          },
          itemCount: _count),
    ),
  );
}

Widget dataPanel(
    BuildContext context, MeasureDataList userDataList, int index) {
  List<MeasureData> _dataList = userDataList.dataList;

  String measureDateTime = _dataList[index].measureTiming;
  int bgValue = _dataList[index].bg;
  String tag = _dataList[index].tag;

  Color tagColor;

  return Consumer<PatientModel>(
    builder: (context, model, child) {
      if (tag.contains("Breakfast") == true) {
        tagColor = Colors.lightBlueAccent;
      } else if (tag.contains("Lunch") == true) {
        tagColor = Colors.orange;
      } else if (tag.contains("Dinner") == true) {
        tagColor = Colors.blueAccent;
      } else {
        tagColor = Colors.grey;
      }

      return Container(
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: SizedBox(
                  height: 70,
                  width: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      color: tagColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          tag,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    model.deleteIndex(index);
                    model.notify();
                  },
                ),
                title: Text(
                  '$bgValue',
                  style: TextStyle(fontSize: 22.0),
                ),
                subtitle: Text('$measureDateTime'),
              ),
            ],
          ),
        ),
      );
    },
  );
}


