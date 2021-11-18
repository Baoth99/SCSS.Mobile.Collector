import 'package:collector_app/blocs/statistic_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collector_app/utils/extension_methods.dart';
import 'package:formz/formz.dart';

class StatisticLayout extends StatelessWidget {
  const StatisticLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticBloc()
        ..add(
          StatisticGet(),
        ),
      child: Scaffold(
        body: MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

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
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        switch (state.status) {
          case FormzStatus.pure:
          case FormzStatus.submissionInProgress:
            return Center(
              child: FunctionalWidgets.getLoadingAnimation(),
            );
          case FormzStatus.submissionSuccess:
            return dataPart();
          case FormzStatus.submissionFailure:
          default:
            return Center(
              child: FunctionalWidgets.getErrorIcon(),
            );
        }
      },
    );
  }

  Widget titlePart(BuildContext context) {
    return Container(
      child: CommonMarginContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 100.h,
            ),
            title(),
            date(context),
          ],
        ),
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
      child: CustomText(
        text: 'Thống kê',
        textAlign: TextAlign.left,
        color: AppColors.white,
        fontSize: 80.sp,
        fontWeight: FontWeight.w500,
      ),
      width: double.infinity,
    );
  }

  Widget date(BuildContext context) {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return InkWell(
          onTap: onDateTap(context, state),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text:
                    '${state.fromDate.toStatisticString()}  -  ${state.toDate.toStatisticString()}',
                fontSize: 55.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 80.sp,
              ),
            ],
          ),
        );
      },
    );
  }

  void Function() onDateTap(
    BuildContext context,
    StatisticState state,
  ) {
    return () {
      showDateRangePicker(
        context: context,
        firstDate: DateTime(2021, 1, 1),
        lastDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDateRange: DateTimeRange(
          start: state.fromDate,
          end: state.toDate,
        ),
        locale: Locale(
          Symbols.vietnamLanguageCode,
          Symbols.vietnamISOCode,
        ),
      ).then((value) {
        if (value != null) {
          context
              .read<StatisticBloc>()
              .add(StatisticChanged(value.start, value.end));
        }
      });
    };
  }

  Widget dataPart() {
    return CommonMarginContainer(
      child: Container(
        margin: EdgeInsets.only(top: 60.h),
        padding: EdgeInsets.only(top: 60.h, bottom: 60.h),
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
        child: Column(
          children: [
            listData(),
            divider(),
            conclusion(),
          ],
        ),
      ),
    );
  }

  Widget listData() {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              DataPattern(
                title: 'Tổng thu mua',
                price: state.statisticData.collectingTotal,
              ),
              SizedBox(
                height: 40.h,
              ),
              DataPattern(
                title: 'Tổng bán',
                price: state.statisticData.sellingTotal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget conclusion() {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ConclusionPattern(
              title: 'Đơn hoàn thành',
              quantity: state.statisticData.completeRequest,
            ),
            ConclusionPattern(
              title: 'Đơn hủy',
              quantity: state.statisticData.cancelRequest,
            ),
          ],
        );
      },
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40.h),
      child: Divider(
        thickness: 4.h,
        indent: 50.w,
        endIndent: 50.w,
      ),
    );
  }
}

class ConclusionPattern extends StatelessWidget {
  const ConclusionPattern({
    Key? key,
    required this.title,
    required this.quantity,
  }) : super(key: key);
  final String title;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 48.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: 30.h,
          ),
          CustomText(
            text: quantity.toString(),
            fontSize: 70.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class DataPattern extends StatelessWidget {
  const DataPattern({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);
  final String title;
  final int price;

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 53.sp,
            fontWeight: FontWeight.w500,
          ),
          CustomText(
            text: price.toAppPrice(),
            fontSize: 53.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
