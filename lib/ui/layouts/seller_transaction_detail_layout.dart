import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collector_app/blocs/feedback_admin_bloc.dart';
import 'package:collector_app/blocs/seller_transaction_detail_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/complaint_done_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:collector_app/ui/widgets/request_detail_element_pattern.dart';
import 'package:collector_app/utils/custom_formats.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:collector_app/utils/extension_methods.dart';

import 'activity_layout.dart';

class SellerTransctionDetailArgs {
  final String id;
  SellerTransctionDetailArgs(this.id);
}

class SellerTransactionDetailLayout extends StatelessWidget {
  const SellerTransactionDetailLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as SellerTransctionDetailArgs;

    return BlocProvider(
      create: (context) => SellerTransactionDetailBloc(id: args.id)
        ..add(
          SellerTransactionDetailInitial(),
        ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FunctionalWidgets.buildAppBar(
          context: context,
          title: CustomText(
            text: 'Yêu cầu thu gom',
            color: AppColors.white,
            fontSize: 50.sp,
          ),
          color: AppColors.white,
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment
                    .centerLeft, // 10% of the width, so there are ten blinds.
                colors: <Color>[
                  AppColors.greenFF61C53D.withOpacity(0.5),
                  AppColors.greenFF39AC8F.withOpacity(0.5),
                ], // red to yellow
                tileMode:
                TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
          ),
        ),
        body: BlocBuilder<SellerTransactionDetailBloc,
            SellerTransactionDetailState>(
          builder: (context, state) {
            return buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, SellerTransactionDetailState state) {
    switch (state.stateStatus) {
      case FormzStatus.submissionInProgress:
        return FunctionalWidgets.getLoadingAnimation();
      case FormzStatus.submissionSuccess:
        return body(context);
      case FormzStatus.submissionFailure:
        return Center(
          child: FunctionalWidgets.getErrorIcon(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget body(BuildContext context) {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, s) {
        return ListView(
          padding: EdgeInsets.only(
            top: kFloatingActionButtonMargin + 5.h,
            bottom: kFloatingActionButtonMargin + 48.h,
          ),
          children: [
            const RequestDetailHeader(),
            const RequestDetailDivider(),
            const SellerInfo(),
            const RequestDetailDivider(),
            const RequestDetailBill(),
            s.complaint.complaintStatus == ComplaintStatus.canGiveFeedback ||
                    s.complaint.complaintStatus ==
                        ComplaintStatus.haveGivenFeedback ||
                    s.complaint.complaintStatus == ComplaintStatus.adminReplied
                ? _getFeedbackToAdmin(context)
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  Widget _getFeedbackToAdmin(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(
        top: 40.h,
      ),
      child: CommonMarginContainer(
        child: BlocBuilder<SellerTransactionDetailBloc,
            SellerTransactionDetailState>(
          builder: (context, state) {
            return TextButton(
              onPressed: _feedbackAdminPressed(
                context,
                state.complaint.complaintStatus,
                state.complaint.complaintContent,
                state.complaint.adminReply,
                state.id,
              ),
              child: const CustomText(
                text: 'Phản hồi',
                color: AppColors.orangeFFF5670A,
              ),
              style: TextButton.styleFrom(
                primary: AppColors.orangeFFF5670A,
              ),
            );
          },
        ),
      ),
    );
  }

  void Function() _feedbackAdminPressed(
    BuildContext context,
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return () {
      FunctionalWidgets.showCustomModalBottomSheet(
        context: context,
        child: _getFeedbackAdminWidget(
          status,
          sellingFeedback,
          replyAdmin,
          requestId,
        ),
        title: 'Phản hồi',
        routeClosed: Routes.sellerTransactionDetail,
      ).then((value) {
        if (value != null && value) {
          context
              .read<SellerTransactionDetailBloc>()
              .add(SellerTransactionDetailInitial());
        }
      });
    };
  }

  Widget _getFeedbackAdminWidget(
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return BlocProvider(
      create: (context) => FeedbackAdminBloc(
        requestId: requestId,
        complaintType: ComplaintType.seller,
      ),
      child: status == ComplaintStatus.canGiveFeedback
          ? ComplaintWidget()
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

class SellerInfo extends StatelessWidget {
  const SellerInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Row(
        children: [
          avatar(),
          name(),
        ],
      ),
    );
  }

  Widget avatar() {
    return AvatarRadiantGradientMask(
      child: Icon(
        Icons.account_circle_sharp,
        color: Colors.white,
        size: 130.sp,
      ),
    );
  }

  Widget name() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(
            left: 30.w,
          ),
          child: CustomText(
              text: state.sellerName,
            fontSize: 40.sp,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}

class RequestDetailHeader extends StatelessWidget {
  const RequestDetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Container(
        child: BlocBuilder<SellerTransactionDetailBloc,
            SellerTransactionDetailState>(
          builder: (context, state) {
            return _requestId(
              context,
              state.collectingRequestCode,
            );
          },
        ),
      ),
    );
  }

  Widget _requestId(BuildContext context, String code) {
    return Row(
      children: <Widget>[
        RadiantGradientMask(
          child: Icon(
            Icons.description_outlined,
            color: AppColors.greenFF01C971,
            size: 60.sp,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: CustomText(
              text: 'Mã Đơn: $code',
              fontWeight: FontWeight.w500,
              fontSize: 35.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class RequestDetailBill extends StatelessWidget {
  const RequestDetailBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(),
          time(),
          detail(),
        ],
      ),
    );
  }

  Widget title() {
    return CustomText(
        text: 'Thông tin thu gom',
      fontSize: 40.sp,
      fontWeight: FontWeight.w500,
    );
  }

  Widget time() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return RequestDetailElementPatternHistory(
          icon: Icons.event,
          title: buildTitleTime(state.status),
          child: bodyTime(),
        );
      },
    );
  }

  String buildTitleTime(int status) {
    switch (status) {
      case ActivityLayoutConstants.completed:
        return 'Thời gian thu gom';
      case ActivityLayoutConstants.cancelByCollect:
      case ActivityLayoutConstants.cancelBySeller:
      case ActivityLayoutConstants.cancelBySystem:
        return 'Thời gian hủy';
      default:
        return Symbols.empty;
    }
  }

  Widget bodyTime() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state){
        return CustomText(
          text: state.doneActivityTime,
        );
      },
    );
  }

  Widget detail() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return RequestDetailElementPatternHistory(
          icon: Icons.receipt_outlined,
          title: buildTitleDetail(state.status),
          titleColor: state.status == ActivityLayoutConstants.completed
              ? Colors.grey
              : AppColors.orangeFFE4625D,
          child: state.status == ActivityLayoutConstants.completed
              ? bodyDetail()
              : SizedBox.shrink(),
          contentLeftMargin: 0.w,
        );
      },
    );
  }

  String buildTitleDetail(int status) {
    switch (status) {
      case ActivityLayoutConstants.completed:
        return 'Thông tin đơn hàng';
      case ActivityLayoutConstants.cancelByCollect:
        return 'Yêu cầu thu gom đã hủy';
      case ActivityLayoutConstants.cancelBySeller:
      case ActivityLayoutConstants.cancelBySystem:
        return 'Yêu cầu thu gom bị hủy';
      default:
        return Symbols.empty;
    }
  }

  Widget bodyDetail() {
    return Column(
      children: [
        getItems(),
        // getDivider(),
        Container(
            margin: EdgeInsets.only(top: 25.h, bottom: 15.h),
            child: getSubInfo()
        ),
        _getDottedDivider(),
        Row(
          children: [
            Expanded(
              child: getFinalText('Khách hàng nhận'),
            ),
            BlocBuilder<SellerTransactionDetailBloc,
                SellerTransactionDetailState>(
              builder: (context, state) {
                return getFinalText(state.billTotal.toAppPrice());
              },
            )
          ],
        )
      ],
    );
  }

  Widget getFinalText(String text) {
    return CustomText(
      text: text,
      fontSize: 48.sp,
      fontWeight: FontWeight.w500,
    );
  }

  Widget getItems() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return Column(
          children: state.transaction
              .map(
                (e) => getItem(
                  e.name,
                  e.quantity,
                  e.unitInfo,
                  e.total.toAppPrice(),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget getItem(String name, double quantity, String unit, String price) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 50.w,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 15.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: getItemText(
              name.isNotEmpty ? name : 'Chưa phân loại',
            ),
            width: 350.w,
          ),
          SizedBox(
            width: 60,
            child: getItemText(
              quantity == 0 || unit.isEmpty
                  ? Symbols.minus
                  : '${CustomFormats.quantityFormat.format(quantity).replaceAll(RegExp(r'\.'), ',')} $unit',
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 80,
            child: getItemText(
              price,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget getItemText(String text, {TextAlign? textAlign}) {
    return CustomText(
      text: text,
      fontSize: 40.sp,
      color: Colors.grey[800],
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget getSubInfo() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return Column(
          children: [
            getSubInfoItem(
              'Tạm tính',
              state.itemTotal.toAppPrice(),
            ),
            getSubInfoItem(
              'Phí dịch vụ',
              '-${state.serviceFee.toAppPrice()}',
            ),
          ],
        );
      },
    );
  }

  Widget getSubInfoItem(String name, String value) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: getSubInfoItemText(name),
          ),
          getSubInfoItemText(value),
        ],
      ),
    );
  }

  Widget getSubInfoItemText(String text) {
    return CustomText(
      text: text,
      color: AppColors.black,
      fontSize: 38.sp,
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 2.5.h,
    );
  }

  _getDottedDivider() {
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
      child: DottedLine(
        direction: Axis.horizontal,
        dashGapLength: 3.0,
        dashColor: AppColors.greyFFB5B5B5,
      ),
    );
  }

}

class RequestDetailDivider extends StatelessWidget {
  const RequestDetailDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 20.h,
      height: 100.h,
      color: AppColors.greyFFEEEEEE,
    );
  }
}

class ComplaintWidget extends StatelessWidget {
  ComplaintWidget({Key? key}) : super(key: key);

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
            desc: 'Bạn đã gửi phản hồi đến hệ thống',
            btnOkText: 'Đóng',
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            desc: 'Có lỗi đến từ hệ thống',
            btnOkText: 'Đóng',
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
                          'Vui lòng điền thông tin bạn muốn phản hồi về VeChaiXANH',
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
                hintText: 'Thông tin phản hồi',
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
                    text: 'Gửi',
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
