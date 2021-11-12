import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collector_app/blocs/dealer_transaction_detail_bloc.dart';
import 'package:collector_app/blocs/feedback_admin_bloc.dart';
import 'package:collector_app/blocs/feedback_dealer_transaction_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/complaint_done_widget.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/request_detail_element_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:collector_app/utils/extension_methods.dart';

class DealerTransctionDetailArgs {
  final String id;
  DealerTransctionDetailArgs(this.id);
}

class DealerTransactionDetailLayout extends StatelessWidget {
  const DealerTransactionDetailLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as DealerTransctionDetailArgs;

    return BlocProvider(
      create: (context) => DealerTransactionDetailBloc(id: args.id)
        ..add(
          DealerTransactionDetailInitial(),
        ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FunctionalWidgets.buildAppBar(
          context: context,
          title: CustomText(
            text: 'Yêu cầu thu gom',
            color: AppColors.white,
            fontSize: 43.sp,
          ),
          color: AppColors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<DealerTransactionDetailBloc,
            DealerTransactionDetailState>(
          builder: (context, state) {
            return buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, DealerTransactionDetailState state) {
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
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
      builder: (c, s) {
        return ListView(
          padding: EdgeInsets.only(
            top: kFloatingActionButtonMargin + 5.h,
            bottom: kFloatingActionButtonMargin + 48.h,
          ),
          children: [
            const RequestDetailHeader(),
            (s.feedbackStatus == FeedbackStatus.haveGivenFeedback ||
                    s.feedbackStatus == FeedbackStatus.haveNotGivenFeedbackYet)
                ? Column(
                    children: [
                      const RequestDetailDivider(),
                      const RequestDetailRating(),
                    ],
                  )
                : const SizedBox.shrink(),
            const RequestDetailDivider(),
            const DealerInfo(),
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
        child: BlocBuilder<DealerTransactionDetailBloc,
            DealerTransactionDetailState>(
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
        routeClosed: Routes.dealerTransactionDetail,
      ).then((value) {
        if (value != null && value) {
          context
              .read<DealerTransactionDetailBloc>()
              .add(DealerTransactionDetailInitial());
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
        complaintType: ComplaintType.dealer,
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

class RequestDetailHeader extends StatelessWidget {
  const RequestDetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Container(
        child: BlocBuilder<DealerTransactionDetailBloc,
            DealerTransactionDetailState>(
          builder: (context, state) {
            return _requestId(
              context,
              state.code,
            );
          },
        ),
      ),
    );
  }

  Widget _requestId(BuildContext context, String code) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.description_outlined,
          color: AppColors.greenFF61C53D,
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

class DealerInfo extends StatelessWidget {
  const DealerInfo({Key? key}) : super(key: key);

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
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
      builder: (context, state) {
        return AvatarDealerCircle(url: state.dealerImageUrl);
      },
    );
  }

  Widget name() {
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: state.dealerName,
            ),
            CustomText(
              text: state.dealerPhone,
            ),
          ],
        );
      },
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
    return CustomText(text: 'Thông tin thu gom');
  }

  Widget time() {
    return RequestDetailElementPatternHistory(
      icon: Icons.event,
      title: 'Thời gian giao dịch',
      child: bodyTime(),
    );
  }

  Widget bodyTime() {
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
      builder: (context, state) {
        return CustomText(
          text: state.transactionTime.toStringApp(),
        );
      },
    );
  }

  Widget detail() {
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
      builder: (context, state) {
        return RequestDetailElementPatternHistory(
          icon: Icons.receipt_outlined,
          title: 'Thông tin đơn hàng',
          child: bodyDetail(),
          contentLeftMargin: 0.w,
        );
      },
    );
  }

  Widget bodyDetail() {
    return Column(
      children: [
        getItems(),
        getDivider(),
        getSubInfo(),
        getDivider(),
        Row(
          children: [
            Expanded(
              child: getFinalText('Tổng cộng'),
            ),
            BlocBuilder<DealerTransactionDetailBloc,
                DealerTransactionDetailState>(
              builder: (context, state) {
                return getFinalText(state.billTotal.toAppPrice());
              },
            )
          ],
        )
      ],
    );
  }

  Widget getSubInfo() {
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
      builder: (context, state) {
        return Column(
          children: [
            getSubInfoItem(
              'Tạm tính',
              state.itemTotal.toAppPrice(),
            ),
            getSubInfoItem(
              'Tiền thưởng',
              state.totalBonus.toAppPrice(),
              postIcon: state.totalBonus > 0 ? Icons.help_outline : null,
              onPressed: state.totalBonus > 0
                  ? onHelpOutlinedPressed(context, state)
                  : null,
            ),
            getSubInfoItem(
              'Điểm thưởng',
              '${state.awardPoint} điểm',
            ),
          ],
        );
      },
    );
  }

  void Function() onHelpOutlinedPressed(
      BuildContext context, DealerTransactionDetailState state) {
    return () {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) => PromotionInfo(
            scrollController: scrollController,
            listModel: state.transaction
                .where((i) => i.isBonus)
                .map((i) => PromotionInfoModel(i.promotionCode, i.name,
                    i.bonusAmount, i.promoAppliedBonus))
                .toList(),
          ),
        ),
      );
    };
  }

  Widget getSubInfoItem(
    String name,
    String value, {
    IconData? postIcon,
    void Function()? onPressed,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                getSubInfoItemText(name),
                getPostIconSubInfoItem(
                  postIcon,
                  onPressed,
                ),
              ],
            ),
          ),
          getSubInfoItemText(value),
        ],
      ),
    );
  }

  Widget getPostIconSubInfoItem(
    IconData? postIcon,
    void Function()? onPressed,
  ) {
    double size = 50.0.r;
    return SizedBox(
      height: size,
      width: size,
      child: new IconButton(
        color: AppColors.greenFF39AC8F,
        padding: new EdgeInsets.all(0.0),
        icon: new Icon(
          postIcon,
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget getSubInfoItemText(String text) {
    return CustomText(
      text: text,
      color: Colors.grey[600],
    );
  }

  Widget getItems() {
    return BlocBuilder<DealerTransactionDetailBloc,
        DealerTransactionDetailState>(
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

  Widget getFinalText(String text) {
    return CustomText(
      text: text,
      fontSize: 48.sp,
      fontWeight: FontWeight.w500,
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
          getItemText(quantity == 0 || unit.isEmpty
              ? Symbols.minus
              : '${quantity.toStringAndRemoveFractionalIfCan()} $unit'),
          getItemText(price),
        ],
      ),
    );
  }

  Widget getItemText(String text) {
    return CustomText(
      text: text,
      fontSize: 40.sp,
      color: Colors.grey[800],
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 2.5.h,
    );
  }
}

class RequestDetailRating extends StatelessWidget {
  const RequestDetailRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        children: [
          _getText('Bạn thấy dịch vụ như thế nào?'),
          _getText('(1 là thất vọng, 5 là tuyệt vời)'),
          BlocBuilder<DealerTransactionDetailBloc,
              DealerTransactionDetailState>(
            builder: (context, state) {
              return StarRating(
                intialRating: state.ratingFeedback,
                ignoreGestures:
                    (state.feedbackStatus == FeedbackStatus.haveGivenFeedback),
                onRatingUpdate: (rating) {
                  FunctionalWidgets.showCustomModalBottomSheet(
                    context: context,
                    child: BlocProvider(
                      create: (context) => FeedbackDealerTransactionBloc(
                        transactionId: state.id,
                        rates: rating,
                      ),
                      child: Feedback(
                        state.dealerImageUrl,
                        state.dealerName,
                        state.dealerPhone,
                        rating,
                      ),
                    ),
                    routeClosed: Routes.dealerTransactionDetail,
                    title: 'Đánh giá dịch vụ',
                  ).then((value) => context
                      .read<DealerTransactionDetailBloc>()
                      .add(DealerTransactionDetailInitial()));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getText(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 40.sp,
    );
  }
}

class Feedback extends StatelessWidget {
  Feedback(this.image, this.name, this.phone, this.initialStar, {Key? key})
      : super(key: key);
  final String image;
  final String name;
  final String phone;
  final double initialStar;
  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackDealerTransactionBloc,
        FeedbackDealerTransactionState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          FunctionalWidgets.showCustomDialog(
            context,
          );
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            desc: 'Cảm ơn bạn đã đánh giá',
            btnOkText: 'Đóng',
            btnOkOnpress: () {
              Navigator.of(context).pop();
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        }
      },
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Divider(
            thickness: 50.h,
            color: Colors.grey[100],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
        ),
        CommonMarginContainer(
          child: IntrinsicHeight(
            child: Row(
              children: [
                AvatarDealerCircle(url: image),
                Container(
                  margin: EdgeInsets.only(
                    left: 50.w,
                  ),
                  child: CustomText(
                    text: name,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Divider(
            thickness: 5.h,
            color: Colors.grey[100],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 20.h,
          ),
        ),
        StarRating(
          onRatingUpdate: (value) {
            context
                .read<FeedbackDealerTransactionBloc>()
                .add(FeedbackDealerRateChanged(value));
          },
          intialRating: initialStar,
        ),
        Container(
          child: CustomText(
            text: 'Cảm ơn bạn đã đánh giá!',
            fontSize: 50.sp,
          ),
          margin: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
        ),
        CommonMarginContainer(
          child: TextField(
            onChanged: (value) {
              context.read<FeedbackDealerTransactionBloc>().add(
                    FeedbackDealerReviewChanged(value),
                  );
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'Hãy chia sẻ trải nghiệm của bạn nhé',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greenFF61C53D),
              ),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ),
        CommonMarginContainer(
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<FeedbackDealerTransactionBloc>()
                  .add(FeedbackDealerTransactionSubmmited());
            },
            child: CustomText(
              text: 'Gửi đánh giá',
              fontSize: WidgetConstants.buttonCommonFrontSize.sp,
              fontWeight: WidgetConstants.buttonCommonFrontWeight,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                WidgetConstants.buttonCommonHeight.h,
              ),
              primary: AppColors.greenFF61C53D,
            ),
          ),
        ),
      ],
    );
  }
}

class RequestDetailDivider extends StatelessWidget {
  const RequestDetailDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 4.h,
      height: 100.h,
    );
  }
}

class StarRating extends StatelessWidget {
  StarRating({
    this.ignoreGestures = false,
    this.intialRating = 0,
    required this.onRatingUpdate,
    Key? key,
  }) : super(key: key);
  final bool ignoreGestures;
  final double intialRating;
  final void Function(double) onRatingUpdate;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: intialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      ignoreGestures: ignoreGestures,
      onRatingUpdate: onRatingUpdate,
    );
  }
}

class AvatarDealerCircle extends StatelessWidget {
  const AvatarDealerCircle({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.r,
      width: 150.r,
      child: CachedNetworkImage(
        httpHeaders: {HttpHeaders.authorizationHeader: bearerToken},
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          child: Center(
            child: FunctionalWidgets.getLoadingCircle(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: AppColors.orangeFFE4625D,
        ),
      ),
    );
  }
}

class PromotionInfoModel {
  final String code;
  final String name;
  final int pricePromo;
  final int priceGet;
  PromotionInfoModel(this.code, this.name, this.pricePromo, this.priceGet);
}

class PromotionInfo extends StatelessWidget {
  const PromotionInfo({
    Key? key,
    required this.scrollController,
    required this.listModel,
  }) : super(key: key);
  final ScrollController scrollController;
  final List<PromotionInfoModel> listModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(36.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomText(
                  text: 'Khuyến mãi',
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                var m = listModel[index];
                return promotionPattern(
                  m.code,
                  m.name,
                  m.pricePromo,
                  m.priceGet,
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: listModel.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget promotionPattern(
      String code, String name, int pricePromo, int priceGet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCode(code),
        getItem(getName(name)),
        getItem(getPricePromo(pricePromo, priceGet)),
      ],
    );
  }

  TextSpan getName(String name) {
    return TextSpan(
      style: TextStyle(color: Colors.black),
      text: 'Loại phế liệu: ',
      children: [
        TextSpan(
          text: name,
          style: TextStyle(color: AppColors.orangeFFE4625D),
        ),
      ],
    );
  }

  TextSpan getPricePromo(int pricePromo, int priceGet) {
    return TextSpan(
      text: 'Thưởng ',
      children: [
        TextSpan(
          text: pricePromo.toAppPrice(),
          style: TextStyle(color: AppColors.orangeFFE4625D),
        ),
        TextSpan(
          text: ' khi bán ',
        ),
        TextSpan(
          text: priceGet.toAppPrice(),
          style: TextStyle(color: AppColors.orangeFFE4625D),
        ),
      ],
    );
  }

  Widget getCode(String code) {
    return CustomText(
      text: code,
      color: AppColors.orangeFFE4625D,
    );
  }

  Widget getItem(TextSpan text) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 40.sp,
          ),
          children: [
            TextSpan(
              text: '\u2022',
              style: TextStyle(
                fontSize: 40.sp,
              ),
            ),
            text,
          ],
        ),
      ),
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
