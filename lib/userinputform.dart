import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:group_button/group_button.dart';
import 'package:open_diabetets_record/patientmodel.dart';
import 'package:provider/provider.dart';

import 'measuredata.dart';

class UserInputForm extends StatefulWidget {

  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {

  final TextEditingController bgValueController = TextEditingController();
  final TextEditingController bgTagController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  List<String> tagButton = ["Before Breakfast", "After Breakfast", "Before Lunch",
    "After Lunch", "Before Dinner", "After Dinner", "Before Sleep", "Other"];

  bool bgValidatedFlag = false;
  bool dateValidatedFlag = false;
  Color bgTextColor = Colors.black;
  int inputBGValue;
  String timingTag;

  DateTime measurementTime = DateTime.now();
  DateFormat dateFormatter  = DateFormat('yyyy-MM-dd kk:mm');



  void bgChanged(String text){
    setState(() {

      if(int.tryParse(text) != null){
        print(text);
        bgTextColor = Colors.blue;
        bgValidatedFlag = true;
        inputBGValue = int.parse(text);

      }
      else{
        bgTextColor = Colors.red;
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    timingTag = tagButton[0];

    return Consumer<PatientModel>(
      builder: (context, model, child){

        return AlertDialog(
            title: Text("USER INPUT"),

            content: Container(
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "BG Value",
                        hintText: "Put the value in Number",
                      ),
                      maxLines: 1,
                      maxLength: 3,
                      style: TextStyle(
                          fontSize: 20,
                          color: bgTextColor),
                      controller: bgValueController,
                      onChanged: bgChanged,

                    ),
                    Divider(color: Colors.transparent,thickness: 5),
                    Text("Choose measurement Time"),
                    RaisedButton(
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              onChanged: (date) {
                                print('change $date');
                                setState(() {
                                  measurementTime = date;
                                });
                              },
                              onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  measurementTime = date;
                                });

                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.jp);
                        },
                        child: Text(
                          dateFormatter.format(measurementTime),
                          style: TextStyle(color: Colors.white),
                        )
                    ),
                    Divider(color: Colors.transparent,thickness: 5,),

                    Text("Tag of Timing of your measure"),
                    GroupButton(
                      isRadio: true,
                      selectedColor: Theme.of(context).accentColor,
                      spacing: 1,

                      onSelected: (index, isSelected){
                        print('$index button is selected');
                        timingTag = tagButton[index];
                        print(timingTag);

                      },
                      buttons: tagButton,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // ボタン領域
              RaisedButton(
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(0),
              ),
              RaisedButton(
                child: Text("Submit"),
                onPressed: ! bgValidatedFlag ? null : (){
                  model.lastTimeBg = model.latestBg;
                  model.latestBg = inputBGValue;
                  model.latestMeasureTime = dateFormatter.format(measurementTime);
                  model.latestTag = timingTag;
                  model.userDataList.dataList.add(MeasureData(dateFormatter.format(measurementTime),inputBGValue, timingTag));
                  model.update();
                  Navigator.of(context).pop(1);
                  print("Here");

                },
              ),
            ]
        );
      },
    );
  }
}

