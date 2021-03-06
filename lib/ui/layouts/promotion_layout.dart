import 'package:collector_app/blocs/promotion_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/extension_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromotionArgs {
  final String id;
  PromotionArgs(this.id);
}

class PromotionLayout extends StatelessWidget {
  const PromotionLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PromotionArgs;
    return BlocProvider(
      create: (context) =>
          PromotionBloc(dealerId: args.id)..add(PromotionInitial()),
      child: Scaffold(
        appBar: FunctionalWidgets.buildAppBar(
          elevation: 1,
          context: context,
          title: CustomText(
              text: 'Ưu đãi',
            color: AppColors.black,
            fontSize: 60.sp,
          ),
          color: AppColors.greyFFB5B5B5,
          backgroundColor: AppColors.white,
        ),
        body: buildBody(),
      ),
    );
  }

  Widget body() {
    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context, state) {
        return state.listPromotion.isEmpty
            ? emptyList()
            : ListView.separated(
                itemBuilder: (context, index) {
                  var m = state.listPromotion[index];
                  return PromotionCard(
                    name: m.promotionName,
                    bonusAmount: m.bonusAmount,
                    appliedAmount: m.appliedAmount,
                    appliedScrapCategory: m.appliedScrapCategory,
                    from: m.appliedFromTime,
                    to: m.appliedToTime,
                  );
                },
                separatorBuilder: (context, index) {
                  return seperator();
                },
                itemCount: state.listPromotion.length,
              );
      },
    );
  }

  Widget seperator() {
    return Container(
      height: 10.h,
      color: AppColors.greyFFEEEEEE,
    );
  }

  Widget buildBody() {
    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context, state) {
        switch (state.status) {
          case FormzStatus.pure:
          case FormzStatus.submissionInProgress:
            return Center(
              child: FunctionalWidgets.getLoadingAnimation(),
            );
          case FormzStatus.submissionSuccess:
            return body();
          default:
            return Center(
              child: FunctionalWidgets.getErrorIcon(),
            );
        }
      },
    );
  }

  Widget emptyList() {
    return Container(
      width: double.infinity,
      child: Column(
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
              text: 'Vựa không có ưu đãi nào',
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
      ),
    );
  }
}

class PromotionCard extends StatelessWidget {
  const PromotionCard({
    Key? key,
    required this.name,
    required this.bonusAmount,
    required this.appliedAmount,
    required this.appliedScrapCategory,
    required this.from,
    required this.to,
  }) : super(key: key);

  final String name;
  final int bonusAmount;
  final int appliedAmount;
  final String appliedScrapCategory;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
          top: 35.h,
          right: 50.w,
          bottom: 35.h,
          left: 70.w
      ),
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: name,
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    CustomText(
                        text: 'Loại phế liệu: ',
                      fontSize: 43.sp,
                    ),
                    CustomText(
                        text: appliedScrapCategory,
                      fontSize: 43.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.orangeFFF5670A,
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    CustomText(
                        text: 'Thưởng ',
                      fontSize: 43.sp,
                    ),
                    CustomText(
                        text: bonusAmount.toAppPrice(),
                      color: AppColors.orangeFFF5670A,
                      fontSize: 43.sp,
                    ),
                    CustomText(
                        text: ' khi bán đủ ',
                      fontSize: 43.sp,
                    ),
                    CustomText(
                        text: appliedAmount.toAppPrice(),
                      color: AppColors.orangeFFF5670A,
                      fontSize: 43.sp,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                CustomText(
                    text: 'Thời gian: $from đến $to'
                )
                // Text('${bonusAmount.toAppPrice()} thưởng'),
                // Text(
                //     '$appliedScrapCategory tối thiếu ${appliedAmount.toAppPrice()}'),
                // Text('$from - $to'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
