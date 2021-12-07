import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/home_bloc.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/blocs/profile_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/ui/layouts/pending_request_detail_layout.dart';
import 'package:collector_app/ui/widgets/avartar_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/wait_to_collect_empty.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        waitToCollect(context),
        // waitToCollectEmpty(),

        Expanded(
          child: options(context),
        ),
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

  Widget waitToCollect(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        try {
          return Material(
            elevation: 1,
            child: Container(
              constraints: BoxConstraints(minHeight: 500.h),
              decoration: BoxDecoration(
                color: AppColors.white,
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.approvedRequests,
                      );
                    },
                    child: state.status.isSubmissionInProgress
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 30.h,
                                    left: 45.w,
                                    bottom: 20.h,
                                  ),
                                  child: CustomText(
                                    text: 'Yêu cầu chờ thu gom',
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<HomeBloc>().add(HomeInitial());
                                },
                                icon: Icon(
                                  Icons.replay,
                                  color: AppColors.greyFF9098B1,
                                ),
                              ),
                            ],
                          ),
                  ),
                  state.status.isSubmissionSuccess
                      ? showRequest(context, state)
                      : (state.status.isSubmissionInProgress ||
                              state.status.isPure)
                          ? FunctionalWidgets.getLoadingAnimation()
                          : FunctionalWidgets.getErrorIcon(),
                ],
              ),
            ),
          );
        } catch (e) {
          AppLog.error(e);
          return WaitToCollectEmpty();
        }
      },
    );
  }

  Widget showRequest(BuildContext context, HomeState state) {
    if (state.listCollectingRequestModel.isEmpty) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 80.h, bottom: 20.h),
            child: Image.asset(
              ImagesPaths.noRequestAvailable,
              width: 400.w,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.h, bottom: 80.h),
            child: CustomText(
              text: 'Bạn chưa xác nhận yêu cầu thu gom nào',
              fontSize: 40.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.greyFF939393.withOpacity(1),
            ),
          )
        ],
      );
    }

    var r = state.listCollectingRequestModel.first;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CollectingRequest(
                bookingId: r.id,
                distance: r.distanceText,
                bulky: r.isBulky,
                cusName: r.sellerName,
                time: CommonUtils.combineTimeToDateString(
                    r.dayOfWeek, r.collectingRequestDate, r.fromTime, r.toTime),
                placeTitle: r.collectingAddressName,
                placeName: r.collectingAddress,
              ),
            ),
          ],
        ),
        state.totalRequest > 1
            ? InkWell(
                onTap: _onTapGetAllNotCollectedRequest(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 30.h,
                    horizontal: 200.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 70.w,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: CustomText(
                          text: 'Xem tất cả',
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 30.w, bottom: 20.h),
                        child: Icon(
                          Icons.chevron_right,
                          color: AppColors.greyFF9098B1,
                          size: 80.sp,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  void Function() _onTapGetAllNotCollectedRequest(BuildContext context) {
    return () {
      Navigator.of(context).pushNamed(
        Routes.approvedRequests,
      );
    };
  }

  void Function() _onTapGetAccountQRCode(BuildContext context) {
    return () {
      Navigator.of(context).pushNamed(
        Routes.accountQRCode,
      );
    };
  }

  Widget options(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: 30.h,
        ),
        child: Column(
          children: [
            option(
              'Yêu cầu thu gom mới',
              'Các yêu cầu thu gom xung quanh bạn',
              () {
                Navigator.of(context).pushNamed(
                  Routes.pendingRequests,
                );
              },
              AppColors.white,
              AppColors.greenFF39AC8F,
              AppColors.greenFF61C53D,
              ImagesPaths.createNewIcon,
            ),
            option(
              'Bảng giá phế liệu',
              'Danh mục các loại phế liệu của bạn',
              () {
                Navigator.of(context).pushNamed(
                  Routes.categories,
                );
              },
              AppColors.white,
              AppColors.blueFF4F94E8,
              AppColors.blueFF35C0EA,
              ImagesPaths.categoriesIcon,
            ),
            option(
              'Vựa hoạt động',
              'Danh sách vựa xung quanh',
              () {
                Navigator.of(context).pushNamed(
                  Routes.dealerSearch,
                );
              },
              AppColors.white,
              AppColors.orangeFFE4625D,
              AppColors.orangeFFFECA23,
              ImagesPaths.dealerIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget option(String name, String description, void Function() onPressed,
      Color contentColor, Color startColor, Color endColor, String icon) {
    return Container(
      // color: Colors.white70,
      height: 270.h,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 100.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment
              .bottomRight, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            startColor.withOpacity(0.9),
            endColor.withOpacity(0.9),
          ], // red to yellow
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 2.0), // shadow direction: bottom right
          )
        ],
        borderRadius: BorderRadius.circular(30.0.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 50.w, right: 40.w),
                    child: Image.asset(icon, width: 130.w)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: name,
                            color: contentColor,
                            fontSize: 60.sp,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: description,
                            color: contentColor,
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollectingRequest extends StatelessWidget {
  const CollectingRequest({
    Key? key,
    required this.bookingId,
    required this.distance,
    required this.cusName,
    required this.time,
    required this.placeTitle,
    required this.placeName,
    required this.bulky,
  }) : super(key: key);

  final String bookingId;
  final String distance;
  final String cusName;
  final String time;
  final String placeTitle;
  final String placeName;
  final bool bulky;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35.h, horizontal: 100.w),
      constraints: BoxConstraints(
        minHeight: 130.h,
      ),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30.0.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyFFDADADA,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ]),
      child: InkWell(
        onTap: _onTapRequestWaitToCollect(context, bookingId),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                  ),
                  decoration: BoxDecoration(
                    color: bulky
                        ? AppColors.orangeFFF9CB79
                        : AppColors.greenFF66D095,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        bulky
                            ? ActivityLayoutConstants.bulkyImage
                            : ActivityLayoutConstants.notBulkyImage,
                        width: 90.w,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40.h),
                        child: CustomText(
                          text: distance,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    constraints: BoxConstraints(minHeight: 130.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getContainerColumn(
                          CustomText(
                            text: cusName,
                            color: Color(0xff4C63A9),
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: time,
                            color: Colors.green[600],
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeTitle,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeName,
                            fontSize: 38.sp,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // isCompleted != null && isCompleted!
                //     ? Container(
                //   // constraints: BoxConstraints(
                //   //   minWidth: 100.w,
                //   // ),
                //   width: 270.w,
                //   child: CustomText(
                //     text: extraInfo ?? Symbols.empty,
                //     color: isCompleted!
                //         ? Colors.green[600]
                //         : AppColors.orangeFFF5670A,
                //     fontWeight: FontWeight.w500,
                //   ),
                //   alignment: Alignment.center,
                // )
                //     : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void Function() _onTapRequestWaitToCollect(
    BuildContext context,
    String id,
  ) {
    return () {
      Navigator.of(context).pushNamed(
        Routes.pendingRequestDetail,
        arguments: PendingRequestDetailArgs(
            id, CollectingRequestDetailStatus.approved),
      );
    };
  }

  Widget _getContainerColumn(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: child,
    );
  }
}
