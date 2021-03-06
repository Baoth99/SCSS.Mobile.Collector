import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/cancel_request_bloc.dart';
import 'package:collector_app/blocs/check_approved_request_bloc.dart';
import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/feedback_admin_bloc.dart';
import 'package:collector_app/blocs/models/gender_model.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/seller_transaction_detail_layout.dart';
import 'package:collector_app/ui/layouts/view_image_layout.dart';
import 'package:collector_app/ui/widgets/cached_avatar_widget.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/complaint_done_widget.dart';
import 'package:collector_app/ui/widgets/custom_button.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:formz/formz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.SUCCES,
                  title: 'Nh???n y??u c???u th??nh c??ng',
                  btnOkOnpress: () {
                    context
                        .read<CollectingRequestDetailBloc>()
                        .add(ConvertPendingIntoApproved());
                    Navigator.of(context).popUntil(
                        ModalRoute.withName(Routes.pendingRequestDetail));
                  },
                  desc: 'B???n ???? nh???n y??u c???u th??nh c??ng',
                  btnOkText: '????ng',
                );
              } else if (state.approveEventStatus ==
                  ApproveEventStatus.approvedByOther) {
                FunctionalWidgets.showAwesomeDialog(
                  context,
                  dialogType: DialogType.WARNING,
                  title: 'Kh??ng th??? nh???n y??u c???u',
                  desc:
                      'Y??u c???u thu gom ???? ???????c x??c nh???n b???i m???t ng?????i thu gom kh??c',
                  btnOkText: '????ng',
                  isOkBorder: true,
                  btnOkColor: AppColors.errorButtonBorder,
                  textOkColor: AppColors.errorButtonText,
                  okRoutePress: Routes.pendingRequests,
                );
              }
            } else if (state.status.isSubmissionFailure) {
              FunctionalWidgets.showErrorSystemRouteButton(
                context,
                route: Routes.main,
              );
            }
          },
          child: BlocBuilder<CollectingRequestDetailBloc,
              CollectingRequestDetailState>(
            builder: (context, state) {
              return BlocListener<CheckApprovedRequestBloc,
                  CheckApprovedRequestState>(
                listener: (checkApproveContext, checkApproveState) {
                  if (checkApproveState.pendingRequestStatus ==
                          PendingRequestStatus.approved &&
                      checkApproveState.isApprovedBySomebody &&
                      !checkApproveState.isApprovedByYou) {
                    FunctionalWidgets.showAwesomeDialog(
                      context,
                      dialogType: DialogType.INFO,
                      title: 'Kh??ng th??? nh???n y??u c???u',
                      desc:
                          'Y??u c???u thu gom n??y ???? ???????c nh???n b???i ng?????i thu gom kh??c.',
                      btnOkText: '????ng',
                      okRoutePress: Routes.pendingRequests,
                    );
                  } else if (checkApproveState.pendingRequestStatus ==
                      PendingRequestStatus.canceled) {
                    FunctionalWidgets.showAwesomeDialog(
                      context,
                      dialogType: DialogType.INFO,
                      title: 'Kh??ng th??? nh???n y??u c???u',
                      desc: 'Y??u c???u thu gom n??y ???? b??? h???y.',
                      btnOkText: '????ng',
                      okRoutePress: Routes.pendingRequests,
                    );
                  }
                },
                child:
                    buildBody(state.status, args.collectingRequestDetailStatus),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody(FormzStatus status,
      CollectingRequestDetailStatus collectingRequestDetailStatus) {
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
  const PendingRequestDetailBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectingRequestDetailBloc,
        CollectingRequestDetailState>(
      builder: (context, state) {
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
            // Positioned.fill(
            //   right: 50.w,
            //   top: 100.h,
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: IconButton(
            //       icon: Icon(
            //         Icons.cancel,
            //         size: 70.sp,
            //         color: Colors.grey,
            //       ),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //   ),
            // ),
            state.collectingRequestDetailStatus ==
                    CollectingRequestDetailStatus.pending
                ? SizedBox.shrink()
                : Positioned.fill(
                    right: 50.w,
                    top: 750.h,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.r),
                          color: AppColors.blueFF4F94E8,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.directions,
                            size: 90.sp,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            CommonUtils.launchMapDir(
                                state.latitude, state.longtitude);
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
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
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  getTitleRow(),
                  RequestDetailElementPattern(
                    icon: Icons.place,
                    title: '?????a ch??? thu gom',
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
                    title: 'Th???i gian h???n thu gom',
                    child: CustomText(
                      text: state.time,
                      fontSize: 47.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RequestDetailElementPattern(
                    icon: Icons.kitchen,
                    title: 'C?? ????? c???ng k???nh',
                    child: CustomText(
                      text: state.isBulky ? 'C??' : 'Kh??ng',
                      fontSize: 47.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  state.collectingRequestDetailStatus ==
                          CollectingRequestDetailStatus.approved
                      ? RequestDetailElementPattern(
                          icon: Icons.notes,
                          title: 'Ghi ch??',
                          child: CustomText(
                            text: state.note,
                            fontSize: 40.sp,
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 70.h,
                  ),
                  state.collectingRequestDetailStatus ==
                          CollectingRequestDetailStatus.pending
                      ? getApproveButton(context)
                      : getCancelAndCreateTransactionButton(context, state.id),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getCancelAndCreateTransactionButton(
      BuildContext context, String requestId) {
    return Row(
      children: [
        CustomButton(
          title: 'H???y',
          onPressed: () {
            FunctionalWidgets.showCustomModalBottomSheet(
              context: context,
              child: BlocProvider(
                create: (context) => CancelRequestBloc(requestId: requestId)
                  ..add(CancelRequestIntial()),
                child: CancelRequestWidget(),
              ),
              title: 'H???y ????n H???n',
              routeClosed: Routes.pendingRequestDetail,
            ).then((value) {
              if (value != null && value) {
                Navigator.of(context).popAndPushNamed(
                  Routes.sellerTransactionDetail,
                  arguments: SellerTransctionDetailArgs(requestId),
                );
              }
            });
          },
          width: 300.w,
          color: Colors.grey[400],
        ),
        SizedBox(
          width: 40.w,
        ),
        Expanded(
          child: BlocBuilder<CollectingRequestDetailBloc,
              CollectingRequestDetailState>(
            builder: (context, state) {
              return CustomButton(
                title: 'T???o giao d???ch',
                onPressed: () {
                  Navigator.pushNamed(context, Routes.createTransaction,
                      arguments: {
                        'collectingRequestId': state.id,
                        'collectingRequestCode': state.collectingRequestCode,
                        'sellerName': state.sellerName,
                        'sellerPhone': state.sellerPhone,
                        'sellerAvatarUrl': state.sellerAvatarUrl,
                      });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getApproveButton(BuildContext context) {
    return BlocBuilder<CollectingRequestDetailBloc,
        CollectingRequestDetailState>(
      builder: (context, state) {
        return CustomButton(
          onPressed: state.isAllowedToApprove
              ? () {
                  FunctionalWidgets.showAwesomeDialog(
                    context,
                    dialogType: DialogType.WARNING,
                    title: 'B???n ch???c ch???n nh???n ????n h??ng n??y?',
                    desc: Symbols.empty,
                    btnOkText: '?????ng ??',
                    btnOkOnpress: () {
                      Navigator.of(context).popUntil(
                          ModalRoute.withName(Routes.pendingRequestDetail));
                      context
                          .read<CheckApprovedRequestBloc>()
                          .add(ApproveCheckApproved());
                      context
                          .read<CollectingRequestDetailBloc>()
                          .add(ApproveRequestEvent());
                    },
                    isCancelBorder: true,
                    btnCancelColor: AppColors.errorButtonBorder,
                    textCancelColor: AppColors.errorButtonText,
                    btnCancelText: 'H???y',
                  );
                }
              : () {
                  if (state.requestType == CollectingRequestType.book) {
                    FunctionalWidgets.showSnackBar(
                      context,
                      'B???n ???? nh???n s??? ????n ?????t h???n t???i ??a. H??y ho??n t???t thu gom ????? ti???p t???c nh???n ????n kh??c.',
                    );
                  } else {
                    FunctionalWidgets.showSnackBar(
                      context,
                      'B???n ???? nh???n 1 ????n ?????n ngay. H??y ho??n t???t thu gom ????? ti???p t???c nh???n ????n kh??c.',
                    );
                  }
                },
          color: state.isAllowedToApprove
              ? AppColors.greenFF01C971
              : AppColors.greyFF969090,
          title: 'Nh???n ????n',
        );
      },
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
                text: 'Th??ng tin ?????t h???n',
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            getWidgetNearTitle(
              'Th??ng tin',
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
                      feedbackStatus: state.complaint.complaintStatus,
                      requestId: state.id,
                      sellingFeedback: state.complaint.complaintContent,
                      replyAdmin: state.complaint.adminReply,
                    );
                  },
                ).then((value) {
                  context
                      .read<CollectingRequestDetailBloc>()
                      .add(CollectingRequestDetailInitial(state.id));
                });
              },
            ),
            state.scrapImageUrl.isNotEmpty
                ? getWidgetNearTitle(
                    'H??nh ???nh',
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
                    'G???i',
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
        padding: EdgeInsets.only(
          right: 15.w,
          top: 20.h,
          left: 15.w,
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
            Container(
              margin: EdgeInsets.only(
                top: 5.h,
              ),
              child: CustomText(
                text: title,
                fontWeight: FontWeight.w400,
                fontSize: 28.sp,
                color: AppColors.black,
              ),
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
        vertical: 30.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RadiantGradientMask(
                child: Icon(
                  icon,
                  color: AppColors.greenFF01C971,
                  size: 60.sp,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20.w,
                  ),
                  child: CustomText(
                    text: title,
                    fontSize: 40.sp,
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
    required this.feedbackStatus,
    this.sellingFeedback,
    this.replyAdmin,
    required this.requestId,
  }) : super(key: key);
  final CollectingRequestDetailStatus collectingRequestDetailStatus;
  final String name;
  final String urlProfile;
  final Gender gender;
  final String sellerPhoneNumber;
  final int feedbackStatus;
  final String? sellingFeedback;
  final String? replyAdmin;
  final String requestId;

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
        collectingRequestDetailStatus ==
                    CollectingRequestDetailStatus.approved &&
                (feedbackStatus == ComplaintStatus.canGiveFeedback ||
                    feedbackStatus == ComplaintStatus.haveGivenFeedback ||
                    feedbackStatus == ComplaintStatus.adminReplied)
            ? complaintButton(context)
            : SizedBox.shrink(),
        closeButton(context),
      ],
    );
  }

  Widget getName() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30.h),
      child: CustomText(
        text: name,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w500,
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
        color: Colors.grey.withOpacity(0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 40.r, bottom: 40.r, left: 90.r, right: 60.r),
              padding: EdgeInsets.all(
                20.r,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: AppColors.greyFFB5B5B5,
              ),
              child: Icon(
                Icons.phone,
              ),
            ),
            CustomText(
              text: sellerPhoneNumber,
              fontSize: 50.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      child: CustomText(
        text: 'Th??ng tin kh??ch h??ng',
        textAlign: TextAlign.center,
      ),
      width: double.infinity,
    );
  }

  Widget closeButton(BuildContext context) {
    return TextButton(
      child: CustomText(
        text: '????ng',
        color: AppColors.black,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget complaintButton(BuildContext context) {
    return TextButton(
      child: CustomText(
        text: 'Ph???n h???i',
        color: AppColors.orangeFFF5670A,
      ),
      onPressed: () {
        FunctionalWidgets.showCustomModalBottomSheet(
          context: context,
          child: _getFeedbackAdminWidget(
            feedbackStatus,
            sellingFeedback,
            replyAdmin,
            requestId,
          ),
          title: 'Ph???n h???i',
        );
      },
    );
  }

  Widget _getFeedbackAdminWidget(
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return BlocProvider(
      create: (context) => FeedbackAdminBloc(
          requestId: requestId, complaintType: ComplaintType.seller),
      child: status == ComplaintStatus.canGiveFeedback
          ? FeedbackAdminWidget()
          : (status == ComplaintStatus.haveGivenFeedback ||
                  status == ComplaintStatus.adminReplied)
              ? ComplaintDoneWidget(
                  status: status,
                  sellingFeedback: sellingFeedback ?? Symbols.empty,
                  adminReply: replyAdmin,
                )
              : const SizedBox.shrink(),
    );
  }
}

class CancelRequestWidget extends StatelessWidget {
  const CancelRequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelRequestBloc, CancelRequestState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          FunctionalWidgets.showCustomDialog(context);
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            title: 'H???y y??u c???u thu gom th??nh c??ng',
            desc: 'B???n ???? h???y y??u c???u thu gom th??nh c??ng',
            btnOkText: '????ng',
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          Navigator.pop(context);

          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            title: 'H???y y??u c???u thu gom th???t b???i',
            desc: 'B???n kh??ng th??? h???y y??u c???u thu gom',
            btnOkText: '????ng',
            isOkBorder: true,
            btnOkColor: AppColors.errorButtonBorder,
            textOkColor: AppColors.errorButtonText,
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
          );
        }
      },
      child: BlocBuilder<CancelRequestBloc, CancelRequestState>(
        builder: (context, state) {
          return _buildBody(context, state.dataIntial);
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, CancelRequestDataIntial dataIntialState) {
    switch (dataIntialState) {
      case CancelRequestDataIntial.pure:
      case CancelRequestDataIntial.procerss:
        return Center(
          child: FunctionalWidgets.getLoadingAnimation(),
        );
      case CancelRequestDataIntial.done:
        return _body(context);
      default:
        return FunctionalWidgets.getErrorIcon();
    }
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScaffoldMargin.w,
            vertical: 20.h,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
          color: Colors.orange[900]!.withOpacity(0.2),
          child: Row(
            children: [
              const Icon(
                Icons.error,
                color: AppColors.orangeFFF5670A,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 40.w,
                  ),
                  child: CustomText(
                    text:
                        'Vui l??ng ch???n l?? do h???y ????n h???n. L??u ??: thao t??c n??y s??? kh??ng th??? ho??n t??c',
                    color: AppColors.orangeFFF5670A,
                    fontSize: 40.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 950.h,
          child: CommonMarginContainer(
            child: BlocBuilder<CancelRequestBloc, CancelRequestState>(
              builder: (context, state) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return RadioListTile<String>(
                      value: state.cancelReasons[index],
                      groupValue: state.cancelReason.value,
                      title: CustomText(
                        text: state.cancelReasons[index],
                      ),
                      onChanged: (value) {
                        context.read<CancelRequestBloc>().add(
                              CancelReasonChanged(value ?? Symbols.empty),
                            );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10.h,
                  ),
                  itemCount: state.cancelReasons.length,
                );
              },
            ),
          ),
        ),
        CommonMarginContainer(
          child: BlocBuilder<CancelRequestBloc, CancelRequestState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.status.isValid
                    ? () {
                        context.read<CancelRequestBloc>().add(
                              CancelRequestSubmmited(),
                            );
                      }
                    : null,
                child: CustomText(
                  text: '?????ng ??',
                  fontSize: WidgetConstants.buttonCommonFrontSize.sp,
                  fontWeight: WidgetConstants.buttonCommonFrontWeight,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    double.infinity,
                    WidgetConstants.buttonCommonHeight.h,
                  ),
                  primary: AppColors.greenFF01C971,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FeedbackAdminWidget extends StatelessWidget {
  FeedbackAdminWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackAdminBloc, FeedbackAdminState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          FunctionalWidgets.showCustomDialog(context);
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            desc: 'B???n ???? g???i ph???n h???i ?????n h??? th???ng',
            btnOkText: '????ng',
            btnOkOnpress: () {
              Navigator.of(context)
                  .popUntil(ModalRoute.withName(Routes.pendingRequestDetail));
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            desc: 'C?? l???i ?????n t??? h??? th???ng',
            btnOkText: '????ng',
            isOkBorder: true,
            btnOkColor: AppColors.errorButtonBorder,
            textOkColor: AppColors.errorButtonText,
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScaffoldMargin.w,
              vertical: 20.h,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 50.h,
            ),
            color: Colors.orange[900]!.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.orangeFFF5670A,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 40.w,
                    ),
                    child: CustomText(
                      text:
                          'Vui l??ng ??i???n th??ng tin b???n mu???n ph???n h???i v??? VeChaiXANH',
                      color: AppColors.orangeFFF5670A,
                      fontSize: 40.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CommonMarginContainer(
            child: TextField(
              onChanged: (value) {
                context.read<FeedbackAdminBloc>().add(
                      FeedbackAdminChanged(value),
                    );
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: 'Th??ng tin ph???n h???i',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              autofocus: true,
            ),
          ),
          CommonMarginContainer(
            child: BlocBuilder<FeedbackAdminBloc, FeedbackAdminState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.status.isValid
                      ? () {
                          context
                              .read<FeedbackAdminBloc>()
                              .add(FeedbackAdminSubmmited());
                        }
                      : null,
                  child: CustomText(
                    text: 'G???i',
                    fontSize: WidgetConstants.buttonCommonFrontSize.sp,
                    fontWeight: WidgetConstants.buttonCommonFrontWeight,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      double.infinity,
                      WidgetConstants.buttonCommonHeight.h,
                    ),
                    primary: AppColors.greenFF01C971,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
