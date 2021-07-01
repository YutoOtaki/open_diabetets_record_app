import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;


import 'measuredata.dart';
import 'patientmodel.dart';
import 'customcirculesymbolrenderer.dart';


Color bgIndicateColor(BuildContext context, int bg){

  if (bg <= 70){
    return Colors.red;
  }
  else if (70 < bg && bg< 180){
    return Colors.green[200];
  }
  else{
    return Colors.red;
  }

}

Widget bgPanel(BuildContext context,String text, int bgValue){

  int indicatorNum;

  if (bgValue <= 70){
    indicatorNum = 1;
  }
  else if (70 < bgValue && bgValue< 180){
    indicatorNum = 2;
  }
  else{
    indicatorNum = 3;
  }

  return Container(
    decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor
    ),
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        Text(text,
        ),
        Text("Before"),
        StepProgressIndicator(
          totalSteps: 3,
          currentStep: indicatorNum,
          selectedColor: bgIndicateColor(context, bgValue),
          unselectedColor: Colors.grey,
        ),
        Text(bgValue.toString()),

        Text("Before"),
        StepProgressIndicator(
          totalSteps: 3,
          currentStep: indicatorNum,
          selectedColor: bgIndicateColor(context, bgValue),
          unselectedColor: Colors.grey,
        ),
        Text(bgValue.toString()),
      ],
    ),
  );

}

/*
Widget beforeAfterChart(BuildContext context){

  var data = [MeasureData("Before", 100), MeasureData("After", 185)];
  var _data = [charts.Series<MeasureData, String>(
    id: 'BG',
    domainFn: (MeasureData measure, _) => measure.measureTiming,
    measureFn: (MeasureData measure, _) => measure.bg,
    labelAccessorFn: (MeasureData measure, _) => measure.bg.toString(),
    data: data,
  )];

  List<charts.TickSpec<num>> axisSetting = [charts.TickSpec<num>(0),
    charts.TickSpec<num>(70), charts.TickSpec<num>(180),charts.TickSpec<num>(250),];

  return Column(

    children: [
      Align(
          child: Text("BreakFast before/after (Average)",
            style: Theme.of(context).textTheme.caption,
          ),
          alignment: Alignment.centerLeft),
      Expanded(
        child: charts.BarChart(
          _data,
          animate: false,
          vertical: false,
          barRendererDecorator: new charts.BarLabelDecorator<String>(),
          primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec: new charts.StaticNumericTickProviderSpec(
                axisSetting
            ),
          ),
        ),
      ),
    ],
  );
}


 */

Widget timeSeriesBgChart(BuildContext context){

  DateFormat dateFormatter  = DateFormat('yyyy-MM-dd kk:mm');
  print("Widget making");


  List<MeasureData> data = Provider.of<PatientModel>(context).userDataList.dataList;
  List<charts.Series<MeasureData, DateTime>> tsdata = [
    charts.Series<MeasureData, DateTime>(
      id: "Time Series BG",
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (MeasureData tsBg, _) => dateFormatter.parseStrict(tsBg.measureTiming),
      measureFn: (MeasureData tsBg, _) => tsBg.bg,
      data: data,)
  ];

  if(data.length == 0){
    return Expanded(child: Text("Your data will be displayed here", textAlign: TextAlign.center,));
  }

  return Expanded(
    child: charts.TimeSeriesChart(
      tsdata,
      animate: true,

      behaviors: [

        charts.LinePointHighlighter(
            symbolRenderer: CustomCircleSymbolRenderer()),

        charts.ChartTitle('Average BG trends',

            titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
            innerPadding: 15),

        /*
        charts.ChartTitle('Time',
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 15
            ),
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea),


         */

        /*
        charts.ChartTitle('BG Value',
            titleStyleSpec: charts.TextStyleSpec(
                fontSize: 15
            ),
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
            charts.OutsideJustification.middleDrawArea),

         */

        charts.PanAndZoomBehavior(),

        charts.RangeAnnotation([
          charts.LineAnnotationSegment(180, charts.RangeAnnotationAxisType.measure,
              color: charts.MaterialPalette.gray.shade800,
              strokeWidthPx: 5),
          charts.LineAnnotationSegment(70, charts.RangeAnnotationAxisType.measure,
              color: charts.MaterialPalette.gray.shade800,
              strokeWidthPx: 5),

        ])

      ],

      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
              if(model.hasDatumSelection){
                print("if graph will click the value will be shown");
                graphDisplayNumber = model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
                print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));

              }
            }
        )],
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    ),
  );
}

Widget aXisStrictTimeSeriesBgChart(BuildContext context){

  DateFormat dateFormatter  = DateFormat('yyyy-MM-dd kk:mm');
  print("Widget making");

  /*
    if(Provider.of<PatientModel>(context).userDataList.dataList.length == 0){
      print("Here");

      return Container(
        child: Column(
          children: [
            Text("Graph will be shown after input your data"),
            CircularProgressIndicator()
          ],
        ),
      );
    }

     */

  /*
    List<TimeSeriesBg> data = [TimeSeriesBg(DateTime(2020, 12, 26), 100), TimeSeriesBg(DateTime(2020, 12, 27), 110), TimeSeriesBg(DateTime(2020, 12, 28), 110),
    TimeSeriesBg(DateTime(2020, 12, 29), 150), TimeSeriesBg(DateTime(2020, 12, 30), 250),TimeSeriesBg(DateTime(2020, 12, 31), 135)];
     */
  List<MeasureData> data = Provider.of<PatientModel>(context).userDataList.dataList;

  // this is for setting y axis
  List<charts.TickSpec<num>> axisSetting = List.generate(14, (i)=>charts.TickSpec<num>(i*20));

  List<charts.Series<MeasureData, DateTime>> tsdata = [
    charts.Series<MeasureData, DateTime>(
      id: "Time Series BG",
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (MeasureData tsBg, _) => dateFormatter.parseStrict(tsBg.measureTiming),
      measureFn: (MeasureData tsBg, _) => tsBg.bg,
      data: data,)
  ];

  if(data.length == 0){

    return Expanded(child: Text("Your data will be displayed here", textAlign: TextAlign.center,));
  }


  return Expanded(
    child: charts.TimeSeriesChart(
      tsdata,
      animate: true,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            axisSetting
        ),
      ),
      behaviors: [
        /*
        charts.ChartTitle('BG trends',

            titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
            innerPadding: 15),

         */

        charts.LinePointHighlighter(
            symbolRenderer: CustomCircleSymbolRenderer()),

        charts.PanAndZoomBehavior(),

        charts.RangeAnnotation([
          charts.LineAnnotationSegment(170, charts.RangeAnnotationAxisType.measure,
              color: charts.MaterialPalette.gray.shade400,
              strokeWidthPx: 5),
          charts.LineAnnotationSegment(70, charts.RangeAnnotationAxisType.measure,
              color: charts.MaterialPalette.gray.shade400,
              strokeWidthPx: 5),

        ])



      ],

      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
              if(model.hasDatumSelection){
                print("if graph will click the value will be shown");
                graphDisplayNumber = model.selectedSeries[0].measureFn(model.selectedDatum[0].index);
                print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));

              }
            }
        )],
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    ),
  );
}

