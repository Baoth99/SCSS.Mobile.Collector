class ConfirmOTPRegisterRequestModel {
  ConfirmOTPRegisterRequestModel({
    required this.otp,
    required this.phone,
  });

  String otp;
  String phone;

  Map<String, dynamic> toJson() => {
        "otp": otp,
        "phone": phone,
      };
}
