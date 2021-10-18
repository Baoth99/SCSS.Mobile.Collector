part of '../profile_bloc.dart';

class ProfileState extends Equatable {
  ProfileState({
    this.id = Symbols.empty,
    this.name = Symbols.empty,
    this.phone = Symbols.empty,
    this.email,
    this.gender = Gender.male,
    this.address,
    this.birthDate,
    this.image,
    this.idCard = Symbols.empty,
    this.totalPoint = 0,
    this.rate = 0,
    this.status = FormzStatus.pure,
    this.imageProfile,
  });
  final String id;
  final String name;
  final String phone;
  final String? email;
  final Gender gender;
  final String? address;
  final DateTime? birthDate;
  final String? image;
  final String idCard;
  final int totalPoint;
  final double rate;
  final FormzStatus status;
  final ImageProvider<Object>? imageProfile;

  ProfileState copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    Gender? gender,
    String? address,
    DateTime? birthDate,
    String? image,
    String? idCard,
    int? totalPoint,
    double? rate,
    FormzStatus? status,
    ImageProvider<Object>? imageProfile,
  }) {
    return ProfileState(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      image: image ?? this.image,
      idCard: idCard ?? this.idCard,
      totalPoint: totalPoint ?? this.totalPoint,
      rate: rate ?? this.rate,
      status: status ?? this.status,
      imageProfile: imageProfile ?? this.imageProfile,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        gender,
        address,
        birthDate,
        idCard,
        image,
        totalPoint,
        rate,
        status,
        imageProfile,
      ];
}
