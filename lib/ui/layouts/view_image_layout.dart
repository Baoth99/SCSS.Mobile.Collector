import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewImageArgs {
  ViewImageArgs(this.path);
  final String path;
}

class ViewImageLayout extends StatelessWidget {
  const ViewImageLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewImageArgs;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: CachedNetworkImage(
              httpHeaders: {HttpHeaders.authorizationHeader: bearerToken},
              imageUrl: args.path,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                child: Center(
                  child: FunctionalWidgets.getLoadingAnimation(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: AppColors.orangeFFE4625D,
              ),
            ),
          ),
          Positioned(
            top: 100.h,
            left: 50.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
