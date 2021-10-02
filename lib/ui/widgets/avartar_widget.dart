import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collector_app/constants/constants.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    required this.imagePath,
    required this.isMale,
    this.width = 450,
    Key? key,
  }) : super(key: key);
  final String imagePath;
  final bool isMale;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      child: CircleAvatar(
        onForegroundImageError: (exception, stackTrace) {},
        radius: (width / 2.2).r,
        foregroundImage: imagePath.isNotEmpty
            ? NetworkImage(
                imagePath,
              )
            : getFalloutImage() as ImageProvider,
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
