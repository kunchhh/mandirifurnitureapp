import 'package:get/get.dart';

import '../modules/Login/bindings/login_binding.dart';
import '../modules/Login/views/login_view.dart';
import '../modules/bag/bindings/bag_binding.dart';
import '../modules/bag/views/bag_view.dart';
import '../modules/catalog/bindings/catalog_binding.dart';
import '../modules/catalog/views/catalog_view.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/myAccount/bindings/my_account_binding.dart';
import '../modules/myAccount/views/my_account_view.dart';
import '../modules/myProfile/bindings/my_profile_binding.dart';
import '../modules/myProfile/views/my_profile_view.dart';
import '../modules/productDetail/bindings/product_detail_binding.dart';
import '../modules/productDetail/views/product_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CATALOG,
      page: () => const CatalogView(),
      binding: CatalogBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: _Paths.BAG,
      page: () => const BagView(),
      binding: BagBinding(),
    ),
    GetPage(
      name: _Paths.MY_ACCOUNT,
      page: () => const MyAccountView(),
      binding: MyAccountBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => const MyProfileView(),
      binding: MyProfileBinding(),
    ),
  ];
}
