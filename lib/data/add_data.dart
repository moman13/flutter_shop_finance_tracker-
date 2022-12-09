import 'package:hive/hive.dart';
part 'add_data.g.dart';

@HiveType(typeId: 1)
class Add_date extends HiveObject {
  @HiveField(0)
  String note;
  @HiveField(1)
  String explain;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String paymentType;
  @HiveField(4)
  DateTime datetime;
  Add_date(
    this.paymentType,
    this.explain,
    this.amount,
    this.note,
    this.datetime,
  );
}
