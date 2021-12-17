import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/avartar_widget.dart';
import 'package:flutter/material.dart';

class CachedAvatarWidget extends StatelessWidget {
  const CachedAvatarWidget({
    required this.path,
    required this.isMale,
    this.width = 450,
    Key? key,
  }) : super(key: key);
  final String path;
  final bool isMale;
  final double width;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      httpHeaders: {HttpHeaders.authorizationHeader: bearerToken},
      imageUrl: path,
      imageBuilder: (context, imageProvider) => getAvatar(imageProvider),
      placeholder: (context, url) => getAvatar(),
      errorWidget: (context, url, error) => getAvatar(),
    );
  }

  Widget getAvatar([ImageProvider? imageProvider]) {
    return AvatarWidget(
      isMale: isMale,
      image: imageProvider,
      width: width,
    );
  }
}
