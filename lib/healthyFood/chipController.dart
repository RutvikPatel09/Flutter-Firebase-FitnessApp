import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//getx controller class for state management of chips

class ChipController extends GetxController {
  var _selectedChip = 0.obs;
  get selectedChip => this._selectedChip.value;
  set selectedChip(index) => this._selectedChip.value = index;
}