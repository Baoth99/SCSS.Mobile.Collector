import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/avartar_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountQRLayout extends StatelessWidget {
  const AccountQRLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            AppColors.greenFF61C53D.withOpacity(1),
            AppColors.greenFF39AC8F.withOpacity(1),
          ], // red to yellow
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.3),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
                Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text('Mã QR'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: AccountQRBody(),
      ),
    );
  }
}

class AccountQRBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 800.w,
          height: 1400.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(40.0.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: Offset(1.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          margin: EdgeInsets.only(bottom: 150.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20.h),
                child: AvatarWidget(
                  imagePath:
                  'https://cdn2.iconfinder.com/data/icons/flatfaces-everyday-people-square/128/beard_male_man_face_avatar-512.png',
                  isMale: false,
                  width: 500.w,
                ),
              ),
              CustomText(
                text: 'Vũ Xuân Thiên',
                color: AppColors.black,
                fontSize: 50.sp,
                fontWeight: FontWeight.w400,
              ),
              Container(
                margin: EdgeInsets.only(top: 100.h),
                child: CustomText(
                  text: 'Sử dụng mã QR để tạo giao dịch với vựa',
                  color: AppColors.black,
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              _getQrCode('vechaixanh.hotro@gmail.com')
            ],
          ),
      ),
    );
  }

  Widget _getQrCode(String id) {
    return Container(
      margin: EdgeInsets.only(
        top: 40.h,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImage(
              data: id,
              version: QrVersions.auto,
              size: 650.r,
            ),
          ],
        ),
      ),
    );
  }
}