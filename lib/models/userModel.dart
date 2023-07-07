class UserModel {
  String? userSurname;
  String userEmail;
  String? userPhone;
  String? userName;
  String userRole;
  String? userImage;

  UserModel(
      {required this.userEmail,
      this.userImage,
      this.userName,
      this.userPhone,
      this.userSurname,
      //required this.userUid,
      required this.userRole});
}
