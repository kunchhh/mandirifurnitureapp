import 'package:get/get.dart';

import '../../../../model/bag.dart';

class BagController extends GetxController {
  //TODO: Implement BagController

  RxList<Bag> _baglist = <Bag>[].obs;
  RxList<int> _selectedProductList = <int>[].obs;

  List<Bag> get bagList => _baglist.value;
  List<int> get selectedProductList => _selectedProductList.value;

  setList(List<Bag> list) {
    _baglist.value = list;
  }

  addSelectedItem(int selectedItemBagID) {
    _selectedProductList.value.add(selectedItemBagID);
    update();
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void decrement() => count.value--;
}
