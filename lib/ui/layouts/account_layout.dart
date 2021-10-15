import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/avartar_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0XFFF8F8F8),
      body: AccountBody(),
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
      child: Row(
        children: [
          Container(
            child: AvatarWidget(
              imagePath:
              'https://cdn2.iconfinder.com/data/icons/flatfaces-everyday-people-square/128/beard_male_man_face_avatar-512.png',
              isMale: false,
              width: 250,
            ),
            margin: EdgeInsets.only(
                left: 70.w, top: 170.h, right: 40.w, bottom: 40.h),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CustomText(
                  text: 'Vũ Xuân Thiên',
                  color: AppColors.white,
                  fontSize: 70.sp,
                  fontWeight: FontWeight.w500,
                ),
                margin: EdgeInsets.only(top: 170.h, right: 80.w, bottom: 20.h),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    text: '56',
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
                    text: '4.9',
                    color: AppColors.white,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              )
            ],
          ),
          InkWell(
            onTap: _onTapGetAccountQRCode(context),
            child: Container(
                margin: EdgeInsets.only(top: 170.h),
                child: Image.asset(
                  ImagesPaths.qrcode,
                  width: 100.w,
                )
            ),
          )
        ],
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
          option(
            'Thông tin tài khoản',
                () {
              Navigator.of(context).pushNamed(
                Routes.profileEdit,
              );
            },
            Colors.black,
            Icons.arrow_forward_ios,
          ),
          option(
            'Đổi mật khẩu',
                () {
              Navigator.of(context).pushNamed(
                Routes.profilePasswordEdit,
              );
            },
            Colors.black,
            Icons.arrow_forward_ios,
          ),
          option(
            'Liên hệ và góp ý',
                () {
              Navigator.of(context).pushNamed(
                Routes.contact,
              );
            },
            Colors.black,
            Icons.arrow_forward_ios,
          ),
          option(
            'Đăng xuất',
                () {
              // context.read<AccountBloc>().add(LogoutEvent());
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
