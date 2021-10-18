class ConnectRevocationRequestModel {
  final String token;
  final String tokenTypeHint;

  const ConnectRevocationRequestModel({
    required this.token,
    required this.tokenTypeHint,
  });
}
