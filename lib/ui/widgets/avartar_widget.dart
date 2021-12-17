import 'package:collector_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    this.image,
    required this.isMale,
    this.width = 450,
    Key? key,
  }) : super(key: key);
  final ImageProvider<Object>? image;
  final bool isMale;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      child: CircleAvatar(
        radius: (width / 2.2).r,
        foregroundImage: image,
        backgroundImage: getFalloutImage(),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
    );
  }

  AssetImage getFalloutImage() {
    return AssetImage(
      isMale ? ImagesPaths.maleProfile : ImagesPaths.femaleProfile,
    );
  }
}
