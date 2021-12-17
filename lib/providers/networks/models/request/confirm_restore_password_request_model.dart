class ConfirmRestorePasswordRequestModel {
  ConfirmRestorePasswordRequestModel({
    required this.phone,
    required this.otp,
  });

  String phone;
  String otp;

  Map<String, dynamic> toJson() => {
        "Phone": phone,
        "OTP": otp,
      };
}
