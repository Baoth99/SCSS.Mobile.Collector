class RestorePasswordRequestModel {
  RestorePasswordRequestModel({
    required this.phone,
    required this.token,
    required this.newPassword,
  });

  String phone;
  String token;
  String newPassword;

  Map<String, dynamic> toJson() => {
        "Phone": phone,
        "Token": token,
        "NewPassword": newPassword,
      };
}
