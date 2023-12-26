import 'package:get/get.dart';

import '../../../../model/bag.dart';

class BagController extends GetxController {
  //TODO: Implement BagController

  RxList<Bag> _baglist = <Bag>[].obs;
  RxList<int> _selectedProductList = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Bag> get bagList => _baglist.value;
  List<int> get selectedProductList => _selectedProductList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Bag> list) {
    _baglist.value = list;
  }

  addSelectedProduct(int selectedProductBagID) {
    _selectedProductList.value.add(selectedProductBagID);
    update();
  }

  deleteSelectedProduct(int selectedProductBagID)
  {
    _selectedProductList.value.remove(selectedProductBagID);
    update();
  }

  setIsSelectedAllProducts()
  {
     
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedProducts()
  {
    _selectedProductList.value.clear();
    update();
  }

  setTotal(double overallTotal)
  {
    _total.value = overallTotal;
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
