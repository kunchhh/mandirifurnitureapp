class api {

  /* Koneksi untuk setiap folder */
  static const hostConnect = "http://192.168.1.11/api_mandirifurniture/";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectFilterProduct = "$hostConnect/filterProduct";
  static const hostBag = "$hostConnect/bag";


   /* User */
  static const userLogin = "$hostConnectUser/userLogin.php";
  static const userSignUp = "$hostConnectUser/userSignUp.php";
  static const userEmailValidated = "$hostConnectUser/userEmailValidated.php";
  static const userUpdateData = "$hostConnectUser/userUpdateData.php";

  /* Bag */
  static const addToBag = "$hostBag/addToBag.php";
  static const readBagFromUser = "$hostBag/readBagFromUser.php";

  /* filter product */
  static const newestProduct = "$hostConnectFilterProduct/newestProduct.php"; 

  }