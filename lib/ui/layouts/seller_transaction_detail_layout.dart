import 'package:collector_app/blocs/seller_transaction_detail_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:collector_app/utils/extension_methods.dart';

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
            fontSize: 43.sp,
          ),
          color: AppColors.white,
          centerTitle: true,
          elevation: 0,
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
      ],
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
    return RadiantGradientMask(
      child: Icon(
        Icons.account_circle_sharp,
        color: Colors.white,
        size: 120.sp,
      ),
    );
  }

  Widget name() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return CustomText(text: state.sellerName);
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
              text: 'Mã Đơn Hẹn: $code',
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
    return CustomText(text: 'Thông tin thu gom');
  }

  Widget time() {
    return BlocBuilder<SellerTransactionDetailBloc,
        SellerTransactionDetailState>(
      builder: (context, state) {
        return RequestDetailElementPattern(
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
      builder: (context, state) {
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
        return RequestDetailElementPattern(
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
        getDivider(),
        getSubInfo(),
        getDivider(),
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
          getItemText(quantity == 0 && unit.isEmpty
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
        vertical: 8.h,
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
      color: Colors.grey[600],
    );
  }

  Widget getDivider() {
    return Divider(
      thickness: 2.5.h,
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

class RequestDetailElementPattern extends StatelessWidget {
  RequestDetailElementPattern({
    Key? key,
    required this.icon,
    required this.title,
    this.titleColor = Colors.grey,
    required this.child,
    double? contentLeftMargin,
  }) : super(key: key) {
    this.contentLeftMargin = contentLeftMargin ?? 80.w;
  }

  final IconData icon;
  final String title;
  final Color titleColor;
  final Widget child;
  late final double contentLeftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25.h,
        horizontal: 50.w,
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
                    left: 50.w,
                  ),
                  child: CustomText(
                    text: title,
                    fontSize: 36.sp,
                    color: titleColor,
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
