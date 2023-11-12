import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
 
class GlobalValues {
  static ValueNotifier<bool> flagTheme = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagTask = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagCarrer = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagTeacher = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagFavMov = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagLoction = ValueNotifier<bool>(true);
  static ValueNotifier<bool> flagFavLoc = ValueNotifier<bool>(true);
  static ValueNotifier<int> optMap = ValueNotifier<int>(0);

}
