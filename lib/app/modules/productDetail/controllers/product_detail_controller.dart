import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  //TODO: Implement ProductDetailController
  RxInt _quantityProduct = 1.obs;
  RxInt _colorProduct = 0.obs;
  RxBool _isFavorite = false.obs;

  int get quantity => _quantityProduct.value;
  int get color => _colorProduct.value;
  bool get isFavorite => _isFavorite.value;
  
  

   setQuantityProduct(int quantityOfProduct)
  {
    _quantityProduct.value = quantityOfProduct;
  }

  setColorProduct(int colorOfProduct) {
    _colorProduct.value = colorOfProduct;
  }

    setIsFavorite(bool isFavorite)
  {
    _isFavorite.value = isFavorite;
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
