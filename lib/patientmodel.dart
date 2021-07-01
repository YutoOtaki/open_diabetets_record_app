import 'package:flutter/material.dart';
import 'measuredata.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

const String boxName = "user";
const String labelName = "measureDataList";

class PatientModel extends ChangeNotifier{

  String name;
  int usingPeriod;
  int latestBg = 0;
  int averageBg = 0;
  String latestTag = "None";
  String latestMeasureTime = "None";
  int lastTimeBg = 0;

  int bgBeforeBreakFast = 80;
  int bgAfterBreakFast = 150;
  int bgBeforeLunch = 120;
  int bgAfterLunch = 180;
  int bgBeforeDinner = 100;
  int bgAfterDinner = 180;
  int bgBeforeSleep = 170;
  int testValue = 0;

  int quizIndex = 0;

  MeasureDataList userDataList = MeasureDataList();
  DateFormat dateFormatter  = DateFormat('yyyy-MM-dd kk:mm');


  void deleteIndex(int index){

    userDataList.dataList.removeAt(index);
    update();

  }

  void update(){
    // データの順番はupdateの際に保証されるため、基本的に日付じゅんに並ぶ。
    print(this);
    userDataList.dataList.sort((a,b)
    => dateFormatter.parseStrict(b.measureTiming).compareTo(dateFormatter.parseStrict(a.measureTiming)));
    if(userDataList.dataList.length == 0){
      latestBg = 0;
      latestMeasureTime = "No data";
      latestTag = "No data";

    }
    notifyListeners();
    saveUserDataList();

  }

  void saveUserDataList(){
    Hive.box<MeasureDataList>(boxName).put(labelName, userDataList);

  }

  void initiate(){

    int dataListLength = userDataList.dataList.length;

    if(dataListLength == 0){

    }else if(dataListLength == 1){

      this.latestBg = userDataList.dataList[0].bg;
      this.latestMeasureTime = userDataList.dataList[0].measureTiming;
      this.lastTimeBg = 0;

    }else {

      this.latestBg = userDataList.dataList[0].bg;
      this.latestMeasureTime = userDataList.dataList[0].measureTiming;

    }

    notifyListeners();

  }

  void notify(){
    notifyListeners();
  }

}

