import 'package:expense_tracker/data/1.dart';

List<money> geter_top() {
  money upwork = money();
  upwork.time = "jan 30,2022";
  upwork.image = "food.png";
  upwork.buy = true;
  upwork.fee = "- \$ 100";
  upwork.name = "Snap food";
  money snap = money();
  snap.time = "jan 30,2022";
  snap.image = "food.png";
  snap.buy = true;
  snap.fee = "- \$ 100";
  snap.name = "Snap food";
  return [upwork, snap];
}
