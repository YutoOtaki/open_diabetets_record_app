import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;


// this is for graphrenderer
int graphDisplayNumber ;

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {


  CustomCircleSymbolRenderer({bool isSolid = true}) : super(isSolid: isSolid);

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
        charts.Color fillColor,
        charts.FillPatternType fillPattern,
        charts.Color strokeColor,
        double strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 30,
            bounds.height + 10),
        fill: charts.Color.white
    );
    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.black;
    textStyle.fontSize = 15;
    chartsTextElement.TextElement _textElement = chartsTextElement.TextElement(graphDisplayNumber.toString(), style: textStyle);
    canvas.drawText(
        _textElement,
        (bounds.left).round(),
        (bounds.top - 26).round()
    );

  }

}