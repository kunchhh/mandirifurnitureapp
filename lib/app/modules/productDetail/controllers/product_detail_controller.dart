import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  //TODO: Implement ProductDetailController
  RxInt _quantityProduct = 1.obs;
  RxInt _colorProduct = 0.obs;
  int get quantity => _quantityProduct.value;
  int get color => _colorProduct.value;
  var isSelected = false.obs;

   setQuantityProduct(int quantityOfProduct)
  {
    _quantityProduct.value = quantityOfProduct;
  }

  toggleSelected() {
    isSelected.value = !isSelected.value;
  }

  setColorProduct(int colorOfProduct) {
    _colorProduct.value = colorOfProduct;
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
}
