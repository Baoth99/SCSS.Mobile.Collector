import 'package:collector_app/blocs/account_bloc.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/blocs/profile_bloc.dart';
import 'package:collector_app/ui/layouts/profile_layout.dart';
import 'package:collector_app/ui/layouts/profile_password_edit_layout.dart';
import 'package:collector_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/avartar_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:formz/formz.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc(),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            FunctionalWidgets.showCustomDialog(context);
          }
          if (state.status.isSubmissionFailure) {
            // Navigator.of(context).popUntil(
            //   ModalRoute.withName(Routes.main),
            // );

            //in case of fail
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login, (Route<dynamic> route) => false);
          }

          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login, (Route<dynamic> route) => false);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0XFFF8F8F8),
          body: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0XFFF8F8F8),
            body: AccountBody(),
          ),
        ),
      ),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        avatar(context),
        options(context),
      ],
    );
  }

  Widget avatar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            AppColors.greenFF61C53D.withOpacity(0.7),
            AppColors.greenFF39AC8F.withOpacity(0.7),
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Row(
            children: [
              Container(
                child: AvatarWidget(
                  image: state.imageProfile,
                  isMale: state.gender == Gender.male,
                  width: 250,
                ),
                margin: EdgeInsets.only(
                    left: 70.w, top: 170.h, right: 40.w, bottom: 40.h),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: CustomText(
                        text: state.name,
                        color: AppColors.white,
                        fontSize: 60.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      margin: EdgeInsets.only(
                          top: 170.h, right: 80.w, bottom: 20.h),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10.w),
                          child: Icon(
                            Icons.control_point_duplicate_outlined,
                            color: Colors.amber,
                            size: 50.sp,
                          ),
                        ),
                        CustomText(
                          text: '${state.totalPoint}',
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        Container(
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 50.sp,
                          ),
                          margin: EdgeInsets.only(left: 40.w, right: 10.w),
                        ),
                        CustomText(
                          text: '${state.rate.toStringAsFixed(1)}',
                          color: AppColors.white,
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: _onTapGetAccountQRCode(context),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 170.h,
                    right: 70.w,
                  ),
                  child: Image.asset(
                    ImagesPaths.qrcode,
                    width: 100.w,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void Function() _onTapGetAccountQRCode(BuildContext context) {
    return () {
      Navigator.of(context).pushNamed(
        Routes.accountQRCode,
      );
    };
  }

  Widget options(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return option(
                'Thông tin tài khoản',
                () {
                  Navigator.of(context).pushNamed(
                    Routes.profileEdit,
                    arguments: ProfileArgs(
                      name: state.name,
                      imagePath: state.image ?? Symbols.empty,
                      phoneNumber: state.phone,
                      address: state.address ?? Symbols.empty,
                      email: state.email ?? Symbols.empty,
                      gender: state.gender,
                      birthdate: state.birthDate ?? DateTime.now(),
                      idCard: state.idCard,
                    ),
                  );
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
          ),
          option(
            'Phí dịch vụ',
            () {
              Navigator.of(context).pushNamed(
                Routes.payableAmount,
              );
            },
            Colors.black,
            Icons.arrow_forward_ios,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return option(
                'Đổi mật khẩu',
                () {
                  Navigator.of(context).pushNamed(Routes.profilePasswordEdit,
                      arguments: ProfilePasswordEditArgs(state.id));
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
          ),
          // option(
          //   'Liên hệ và góp ý',
          //   () {
          //     Navigator.of(context).pushNamed(
          //       Routes.contact,
          //     );
          //   },
          //   Colors.black,
          //   Icons.arrow_forward_ios,
          // ),
          option(
            'Đăng xuất',
            () {
              context.read<AccountBloc>().add(LogoutEvent());
            },
            Colors.red,
            Icons.logout_outlined,
          ),
        ],
      ),
    );
  }

  Widget option(String name, void Function() onPressed, Color color,
      [IconData? iconData]) {
    return Container(
      color: Colors.white70,
      height: 180.h,
      margin: EdgeInsets.symmetric(
        vertical: 3.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.only(
              right: 40.w,
              left: 80.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: name,
                    color: color,
                    fontSize: 45.sp,
                  ),
                ),
                Icon(
                  iconData,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
