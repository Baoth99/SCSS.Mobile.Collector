import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/cached_avatar_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileArgs {
  String name;
  String imagePath;
  String phoneNumber;
  String address;
  String email;
  Gender gender;
  DateTime birthdate;
  String idCard;

  ProfileArgs({
    required this.name,
    required this.imagePath,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.gender,
    required this.birthdate,
    required this.idCard,
  });
}

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProfileArgs;
    String imageUrl = Symbols.empty;
    if (args.imagePath.isNotEmpty) {
      imageUrl = NetworkUtils.getUrlWithQueryString(
          APIServiceURI.imageGet, {'imageUrl': args.imagePath});
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        title: CustomText(
          text: 'Thông tin tài khoản',
          fontSize: 50.sp,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedAvatarWidget(
              isMale: args.gender == Gender.male,
              width: 700.w,
              path: imageUrl,
            ),
            InputContainer(
              lable: 'Tên',
              text: args.name,
            ),
            InputContainer(
              lable: 'Số điện thoại',
              text: args.phoneNumber,
            ),
            InputContainer(
              lable: 'Giới tính',
              text: args.gender == Gender.male ? 'Nam' : 'Nữ',
            ),
            InputContainer(
              lable: 'Ngày sinh',
              text: CommonUtils.toStringDDMMYYY(args.birthdate),
            ),
            InputContainer(
              lable: 'Địa chỉ',
              text: args.address,
            ),
            InputContainer(
              lable: 'Chứng minh thư',
              text: args.idCard,
            ),
            InputContainer(
              lable: 'Email',
              text: args.email,
            ),
          ],
        ),
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  const InputContainer({
    Key? key,
    required this.lable,
    required this.text,
  }) : super(key: key);
  final String lable;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40.w,
        vertical: 30.h,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(
                30.0.r,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 900.w,
                  margin: EdgeInsets.symmetric(
                    horizontal: 35.w,
                  ),
                  constraints: BoxConstraints(minHeight: 150.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 50.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -15.h,
            left: 24.w,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.w,
              ),
              child: CustomText(
                text: lable,
                fontSize: 37.0.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
