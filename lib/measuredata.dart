import 'package:hive/hive.dart';
part 'measuredata.g.dart';

@HiveType(typeId: 1)
class MeasureData {

  @HiveField(0)
  String measureTiming;
  @HiveField(1)
  int bg;
  @HiveField(2)
  String tag;
  MeasureData(this.measureTiming, this.bg, this.tag);

}

@HiveType(typeId: 2)
class MeasureDataList{

  @HiveField(0)
  List<MeasureData> dataList = List<MeasureData>();

}
