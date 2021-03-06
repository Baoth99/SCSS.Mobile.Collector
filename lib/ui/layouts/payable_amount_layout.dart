import 'package:collector_app/blocs/payable_amount_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/ui/widgets/arrow_back_button.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:collector_app/utils/extension_methods.dart';

class PayableAmountLayout extends StatelessWidget {
  const PayableAmountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PayableAmountBloc()..add(PayableAmountGet()),
      child: Scaffold(
        body: BlocBuilder<PayableAmountBloc, PayableAmountState>(
          builder: (context, state) {
            return MainPayableAmount();
          },
        ),
      ),
    );
  }
}

class MainPayableAmount extends StatelessWidget {
  const MainPayableAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titlePart(context),
        buildDataPart(),
      ],
    );
  }

  Widget buildDataPart() {
    return BlocBuilder<PayableAmountBloc, PayableAmountState>(
      builder: (context, state) {
        switch (state.status) {
          case FormzStatus.pure:
          case FormzStatus.submissionInProgress:
            return Center(
              child: FunctionalWidgets.getLoadingAnimation(),
            );
          case FormzStatus.submissionSuccess:
            return dataPart(state);
          case FormzStatus.submissionFailure:
          default:
            return Center(
              child: FunctionalWidgets.getErrorIcon(),
            );
        }
      },
    );
  }

  Widget dataPart(PayableAmountState state) {
    return CommonMarginContainer(
      child: Container(
        margin: EdgeInsets.only(top: 60.h),
        padding: EdgeInsets.only(top: 70.h, bottom: 70.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.0.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: state.listPayableAmount.isNotEmpty
            ? Column(
                children: [
                  CustomText(
                      text: 'T???ng c???ng',
                    fontSize: 58.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyFF969090,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 80.h),
                    child: CustomText(
                      text: state.listPayableAmount[state.chosenIndex].amount
                          .toAppPrice(),
                      fontSize: 98.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.w
                    ),
                    child: CustomText(
                      text:
                          '* Ph?? ???????c t???ng h???p t??? c??c giao d???ch c???a b???n theo chu k??? m???i th??ng',
                      color: AppColors.greyFF969090,
                      fontSize: 35.sp,
                    ),
                  ),
                ],
              )
            : emptyList(),
      ),
    );
  }

  Widget emptyList() {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
        ),
        Image.asset(
          ImagesPaths.emptyActivityList,
          height: 200.h,
        ),
        Container(
          child: CustomText(
            text: 'Kh??ng c?? th??ng tin n??o',
            fontSize: 40.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 100.w,
            vertical: 50.w,
          ),
        ),
      ],
    );
  }

  Widget titlePart(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 100.h,
          ),
          title(),
          chooseDate(),
        ],
      ),
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
      height: 500.h,
      width: double.infinity,
    );
  }

  Widget title() {
    return Container(
      child: Row(
        children: [
          ArrowBackIconButton(
            color: Colors.white,
          ),
          SizedBox(
            width: 50.w,
          ),
          CustomText(
            text: 'Ph?? d???ch v???',
            textAlign: TextAlign.left,
            color: AppColors.white,
            fontSize: 80.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
      width: double.infinity,
    );
  }

  Widget chooseDate() {
    var dropDownColor = Colors.white;
    return BlocBuilder<PayableAmountBloc, PayableAmountState>(
      builder: (context, state) {
        return state.status.isSubmissionSuccess
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 250.w,
                ),
                child: DropdownSearch<PayableAmount>(
                  mode: Mode.BOTTOM_SHEET,
                  items: state.listPayableAmount,
                  label: null,
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<PayableAmountBloc>()
                          .add(PayableMonthChanged(value));
                    } else {
                      AppLog.error('Value is null');
                    }
                  },
                  dropDownButton: Icon(
                    Icons.arrow_drop_down,
                    color: dropDownColor,
                  ),
                  dropdownSearchDecoration:
                      InputDecoration(border: InputBorder.none),
                  dropdownBuilder: (context, selectedItem) {
                    if (selectedItem != null) {
                      return CustomText(
                        text: selectedItem.timePeriod,
                        color: dropDownColor,
                        fontSize: 55.sp,
                        fontWeight: FontWeight.w500,
                      );
                    }
                    return Container();
                  },
                  itemAsString: (item) {
                    if (item != null) {
                      return item.timePeriod;
                    }
                    return Symbols.empty;
                  },
                  selectedItem: state.listPayableAmount.isNotEmpty
                      ? state.listPayableAmount.first
                      : null,
                  emptyBuilder: (context, searchEntry) => Center(
                    child: CustomText(text: 'Kh??ng c?? th??ng tin'),
                  ),
                ),
              )
            : state.status.isSubmissionFailure
                ? FunctionalWidgets.getErrorIcon()
                : FunctionalWidgets.getLoadingAnimation();
      },
    );
  }
}
