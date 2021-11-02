import 'package:collector_app/blocs/statistic_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
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
        backgroundColor: Colors.grey,
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
      color: Colors.green,
      height: 400.h,
      width: double.infinity,
    );
  }

  Widget title() {
    return Container(
      child: CustomText(
        text: 'Thống kê',
        textAlign: TextAlign.left,
      ),
      width: double.infinity,
    );
  }

  Widget date(BuildContext context) {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        return InkWell(
          onTap: onDateTap(context, state),
          child: CustomText(
              text:
                  '${state.fromDate.toStatisticString()} - ${state.toDate.toStatisticString()}'),
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
        constraints: BoxConstraints(
          minHeight: 300.h,
        ),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
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
        return Column(
          children: [
            DataPattern(
              title: 'Tổng thu mua',
              price: state.statisticData.collectingTotal,
            ),
            DataPattern(
              title: 'Tổng bán',
              price: state.statisticData.sellingTotal,
            ),
          ],
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
    return Divider(
      thickness: 4.h,
      indent: 50.w,
      endIndent: 50.w,
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
          ),
          CustomText(
            text: quantity.toString(),
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
          ),
          CustomText(
            text: price.toAppPrice(),
          ),
        ],
      ),
    );
  }
}
