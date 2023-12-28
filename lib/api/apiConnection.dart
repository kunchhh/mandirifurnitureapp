class api {

  /* Koneksi untuk setiap folder */
  static const hostConnect = "http://192.168.100.229/api_mandirifurniture/";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectFilterProduct = "$hostConnect/filterProduct";
  static const hostBag = "$hostConnect/bag";
  static const hostFavorite = "$hostConnect/favoriteProduct";



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

  }