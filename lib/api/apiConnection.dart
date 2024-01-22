class api {

  /* Koneksi untuk setiap folder */
  static const hostConnect = "http://192.168.100.229/api_mandirifurniture/";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectFilterProduct = "$hostConnect/filterProduct";
  static const hostBag = "$hostConnect/bag";
  static const hostFavorite = "$hostConnect/favoriteProduct";
  static const hostOrder = "$hostConnect/order";
  static const hostSearch = "$hostConnect/searchProduct";
  static const hostCategories = "$hostConnect/categories";

   /* User */
  static const userLogin = "$hostConnectUser/userLogin.php";
  static const userSignUp = "$hostConnectUser/userSignUp.php";
  static const userEmailValidated = "$hostConnectUser/userEmailValidated.php";
  static const userUpdateData = "$hostConnectUser/userUpdateData.php";

  /* Bag */
  static const addToBag = "$hostBag/addToBag.php";
  static const readBagFromUser = "$hostBag/readBagFromUser.php";
  static const deleteProductInTheBag = "$hostBag/deleteProductInTheBag.php";
  static const updateProductInTheBag = "$hostBag/updateProductInTheBag.php";

  /* filter product */
  static const newestProduct = "$hostConnectFilterProduct/newestProduct.php"; 

  /* Favorite product */
  static const addFavoriteProduct = "$hostFavorite/addFavoriteProduct.php"; 
  static const deleteFavoriteProduct = "$hostFavorite/deleteFavoriteProduct.php"; 
  static const validateFavoriteProduct = "$hostFavorite/validateFavoriteProduct.php"; 
  static const readFavoriteProduct = "$hostFavorite/readFavoriteProduct.php"; 

  /* Order */
  static const addNewOrder = "$hostOrder/addOrder.php"; 
  static const readOrder = "$hostOrder/readOrder.php"; 
  static const readInDeliveryOrder = "$hostOrder/readInDeliveryOrder.php";
  static const readHistoryOrder = "$hostOrder/readHistoryOrder.php"; 
  static const updateStatusOrder = "$hostOrder/updateStatusOrder.php"; 

  /* Search product */
  static const searchAllProduct = "$hostSearch/searchAllProduct.php"; 

  /* Categories product */
  static const sofa = "$hostCategories/sofa.php";
  static const lamp = "$hostCategories/lamp.php";
  static const desk = "$hostCategories/desk.php";
  static const bed = "$hostCategories/bed.php";
  static const chair = "$hostCategories/chair.php";
  static const kitchen = "$hostCategories/kitchen.php";
  static const backdrop = "$hostCategories/backdrop.php";
  static const cupboard = "$hostCategories/cupboard.php";

  }
