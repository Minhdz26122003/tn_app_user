import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class Servicecontroller extends GetxController {
  RxBool isDescriptionExpanded = true.obs;
  String formatCurrency(String? amount) {
    if (amount == null) return 'N/A';
    final price = double.tryParse(amount);
    if (price == null) return 'N/A';
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
