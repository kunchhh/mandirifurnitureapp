class User {
  String user_fullName;
  String user_email;
  String user_password;
  String user_id_phoneNumber;
  String user_dateOfBirth;

  User(
    this.user_fullName,
    this.user_email,
    this.user_password,
    this.user_id_phoneNumber,
    this.user_dateOfBirth,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
    json['user_fullName'],
    json['user_email'],
    json['user_password'],
    json['user_id_phoneNumber'],
    json['user_dateOfBirth']
  );

  Map<String, dynamic>toJson() => {
    'user_fullName': user_fullName,
    'user_email' : user_email,
    'user_password' : user_password,
    'user_id_phoneNumber' : user_id_phoneNumber,
    'user_dateOfBirth' : user_dateOfBirth.toString()
  };

}