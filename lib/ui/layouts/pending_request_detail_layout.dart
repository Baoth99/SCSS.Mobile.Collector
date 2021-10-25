import 'dart:typed_data';

import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/view_image_layout.dart';
import 'package:collector_app/ui/widgets/cached_avatar_widget.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_button.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:formz/formz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PendingRequestDetailArgs {
  final String id;
  final CollectingRequestDetailStatus collectingRequestDetailStatus;
  PendingRequestDetailArgs(
    this.id,
    this.collectingRequestDetailStatus,
  );
}

class PendingRequestDetailLayout extends StatelessWidget {
  const PendingRequestDetailLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PendingRequestDetailArgs;

    return BlocProvider(
      create: (context) => CollectingRequestDetailBloc(
        collectingRequestDetailStatus: args.collectingRequestDetailStatus,
      )..add(CollectingRequestDetailInitial(args.id)),
      child: Scaffold(
        body: BlocListener<CollectingRequestDetailBloc,
            CollectingRequestDetailState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              if (state.approveEventStatus == ApproveEventStatus.success) {
                FunctionalWidgets.showDialogCloseButton(
                  context,
                  'Nhận yêu cầu thành công',
                  alertType: AlertType.success,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  onWillPopActive: true,
                ).then((value) {
                  if (value != null && value) {
                    context
                        .read<CollectingRequestDetailBloc>()
                        .add(ConvertPendingIntoApproved());
                  } else {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(Routes.pendingRequests));
                  }
                });
              } else if (state.approveEventStatus ==
                  ApproveEventStatus.approvedByOther) {
                FunctionalWidgets.showDialogCloseRouteButton(
                  context,
                  'Không thể nhận yêu cầu',
                  desc:
                      'Yêu cầu thu gom đã được xác nhận bởi một người thu gom khác',
                  alertType: AlertType.warning,
                  onWillPopActive: true,
                  route: Routes.pendingRequests,
                );
              }
            } else if (state.status.isSubmissionFailure) {
              FunctionalWidgets.showErrorSystemRouteButton(
                context,
                route: Routes.pendingRequests,
                onWillPopActive: true,
              );
            }
          },
          child: BlocBuilder<CollectingRequestDetailBloc,
              CollectingRequestDetailState>(
            builder: (context, state) {
              return buildBody(state.status);
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody(FormzStatus status) {
    switch (status) {
      case FormzStatus.submissionSuccess:
        return PendingRequestDetailBody();
      case FormzStatus.pure:
      case FormzStatus.submissionInProgress:
        return FunctionalWidgets.getLoadingAnimation();
      default:
        return SizedBox.shrink();
    }
  }
}

class PendingRequestDetailBody extends StatelessWidget {
  const PendingRequestDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: map()),
            info(),
          ],
        ),
        Positioned.fill(
          right: 50.w,
          top: 100.h,
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                size: 70.sp,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget info() {
    return BlocBuilder<CollectingRequestDetailBloc,
        CollectingRequestDetailState>(
      builder: (context, state) {
        return Container(
          height: 1300.h,
          width: double.infinity,
          child: CommonMarginContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTitleRow(),
                RequestDetailElementPattern(
                  icon: Icons.place,
                  title: 'Địa chỉ thu gom',
                  child: state.collectingRequestDetailStatus ==
                          CollectingRequestDetailStatus.pending
                      ? CustomText(
                          text: state.area,
                          fontSize: 47.sp,
                          fontWeight: FontWeight.w500,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              fontSize: 47.sp,
                              text: state.collectingAddressName,
                              fontWeight: FontWeight.w500,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 12.h,
                              ),
                              child: CustomText(
                                text: state.collectingAddress,
                                fontSize: 39.sp,
                              ),
                            ),
                          ],
                        ),
                ),
                RequestDetailElementPattern(
                  icon: AppIcons.event,
                  title: 'Thời gian hẹn thu gom',
                  child: CustomText(
                    text: state.time,
                    fontSize: 47.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RequestDetailElementPattern(
                  icon: Icons.kitchen,
                  title: 'Có đồ cồng kềnh',
                  child: CustomText(
                    text: state.isBulky ? 'Có' : 'Không',
                    fontSize: 47.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                state.collectingRequestDetailStatus ==
                        CollectingRequestDetailStatus.approved
                    ? RequestDetailElementPattern(
                        icon: Icons.notes,
                        title: 'Ghi chú',
                        child: CustomText(
                          text: state.note,
                          fontSize: 40.sp,
                        ),
                      )
                    : SizedBox.shrink(),
                state.collectingRequestDetailStatus ==
                        CollectingRequestDetailStatus.pending
                    ? getApproveButton(context)
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getApproveButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        FunctionalWidgets.showDialogTwoButton(
          context,
          'Bạn chắc chắn nhận đơn hàng này?',
          'Đồng ý',
          'Không',
        ).then((value) {
          if (value != null && value) {
            context
                .read<CollectingRequestDetailBloc>()
                .add(ApproveRequestEvent());
          }
        });
      },
      title: 'Nhận đơn',
    );
  }

  Widget getTitleRow() {
    Color commonColor = Colors.grey[400]!;
    return BlocBuilder<CollectingRequestDetailBloc,
        CollectingRequestDetailState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: CustomText(
                text: 'Thông tin đặt hẹn',
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            getWidgetNearTitle(
              'Thông tin',
              Icons.person,
              commonColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SellerInforatmionDialog(
                      collectingRequestDetailStatus:
                          state.collectingRequestDetailStatus,
                      name: state.sellerName,
                      gender: state.gender,
                      urlProfile: state.sellerAvatarUrl,
                      sellerPhoneNumber: state.sellerPhone,
                    );
                  },
                );
              },
            ),
            state.scrapImageUrl.isNotEmpty
                ? getWidgetNearTitle(
                    'Hình ảnh',
                    Icons.image,
                    commonColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        Routes.viewImage,
                        arguments: ViewImageArgs(
                          state.scrapImageUrl,
                        ),
                      );
                    },
                  )
                : SizedBox.shrink(),
            state.collectingRequestDetailStatus ==
                    CollectingRequestDetailStatus.approved
                ? getWidgetNearTitle(
                    'Gọi',
                    Icons.call,
                    commonColor,
                    onPressed: () {
                      CommonUtils.launchTelephone(state.sellerPhone);
                    },
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget getWidgetNearTitle(String title, IconData icon, Color color,
      {required void Function() onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color,
              minRadius: 40.r,
              child: Icon(
                icon,
                color: Colors.white,
                size: 60.sp,
              ),
            ),
            CustomText(
              text: title,
              fontWeight: FontWeight.w300,
              fontSize: 28.sp,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget map() {
    return RequestMap();
  }
}

class RequestMap extends StatefulWidget {
  const RequestMap({Key? key}) : super(key: key);

  @override
  _RequestMapState createState() => _RequestMapState();
}

class _RequestMapState extends State<RequestMap> {
  MapboxMapController? controller;

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void Function() _onStyleLoaded(double lat, double lag) {
    return () {
      addImageFromAsset(ImagesPaths.sellerLogoName, ImagesPaths.sellerLogo);
      _add(lat, lag);
    };
  }

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
  }

  Future<void> _add(double lat, double lag) async {
    controller!.addSymbols([]..add(getSymbolOption(lat, lag)));
  }

  SymbolOptions getSymbolOption(double lat, double log) {
    LatLng geometry = LatLng(lat, log);
    return SymbolOptions(
      geometry: geometry,
      iconImage: ImagesPaths.sellerLogoName,
      iconSize: 0.7,
    );
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectingRequestDetailBloc,
        CollectingRequestDetailState>(
      builder: (context, state) {
        return MapboxMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              state.status.isSubmissionSuccess
                  ? state.latitude
                  : currentLatitude,
              state.status.isSubmissionSuccess
                  ? state.longtitude
                  : currentLongitude,
            ),
            zoom: 15.0,
          ),
          accessToken: EnvMapSettingValue.accessToken,
          onMapCreated: _onMapCreated,
          trackCameraPosition: true,
          styleString: EnvMapSettingValue.mapStype,
          onStyleLoadedCallback:
              _onStyleLoaded(state.latitude, state.longtitude),
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.None,
          myLocationRenderMode: MyLocationRenderMode.COMPASS,
          // onCameraIdle: _onCameraIdle(context),
        );
      },
    );
  }

  void _animateCrurentLocation() async {
    LatLng latLng = LatLng(currentLatitude, currentLongitude);
    await _animateLocation(latLng);
  }

  Future<void> _animateLocation(LatLng? latlng) async {
    if (latlng != null) {
      await controller?.animateCamera(
        CameraUpdate.newLatLng(
          latlng,
        ),
      );
      await controller?.animateCamera(
        CameraUpdate.zoomTo(15),
      );
    }
  }
}

// ignore: must_be_immutable
class RequestDetailElementPattern extends StatelessWidget {
  RequestDetailElementPattern({
    Key? key,
    required this.icon,
    required this.title,
    required this.child,
    double? contentLeftMargin,
  }) : super(key: key) {
    this.contentLeftMargin = contentLeftMargin ?? 80.w;
  }

  final IconData icon;
  final String title;
  final Widget child;
  late double contentLeftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppColors.greenFF61C53D,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20.w,
                  ),
                  child: CustomText(
                    text: title,
                    fontSize: 36.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              left: contentLeftMargin,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class SellerInforatmionDialog extends StatelessWidget {
  const SellerInforatmionDialog({
    Key? key,
    required this.collectingRequestDetailStatus,
    required this.name,
    required this.urlProfile,
    required this.gender,
    required this.sellerPhoneNumber,
  }) : super(key: key);
  final CollectingRequestDetailStatus collectingRequestDetailStatus;
  final String name;
  final String urlProfile;
  final Gender gender;
  final String sellerPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 50.h,
      ),
      title: title(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          avatar(),
          getName(),
          collectingRequestDetailStatus ==
                  CollectingRequestDetailStatus.approved
              ? phone()
              : SizedBox.shrink(),
        ],
      ),
      actions: [
        closeButton(context),
      ],
    );
  }

  Widget getName() {
    return Container(
      child: CustomText(
        text: name,
        textAlign: TextAlign.center,
      ),
      width: double.infinity,
    );
  }

  Widget avatar() {
    return CachedAvatarWidget(
      isMale: gender == Gender.male,
      width: 500.w,
      path: urlProfile,
    );
  }

  Widget phone() {
    return InkWell(
      onTap: () {
        CommonUtils.launchTelephone(sellerPhoneNumber);
      },
      child: Container(
        width: double.infinity,
        color: Colors.grey.withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(
                20.r,
              ),
              padding: EdgeInsets.all(
                20.r,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.phone,
              ),
            ),
            CustomText(text: sellerPhoneNumber),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      child: CustomText(
        text: 'Thông tin khách hàng',
        textAlign: TextAlign.center,
      ),
      width: double.infinity,
    );
  }

  Widget closeButton(BuildContext context) {
    return TextButton(
      child: CustomText(
        text: 'Đóng',
        color: AppColors.orangeFFE4625D,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
