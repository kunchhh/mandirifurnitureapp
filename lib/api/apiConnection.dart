class api {

  /* Koneksi untuk setiap folder */
  static const hostConnect = "http://192.168.100.229/api_mandirifurniture/";
  static const hostConnectUser = "$hostConnect/user";

   /* User */
  static const userLogin = "$hostConnectUser/userLogin.php";
  static const userSignUp = "$hostConnectUser/userSignUp.php";
  static const userEmailValidated = "$hostConnectUser/userEmailValidated.php";

}