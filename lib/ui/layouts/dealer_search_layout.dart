import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collector_app/blocs/dealer_search_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class DealerSearchLayout extends StatelessWidget {
  const DealerSearchLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DealerSearchBloc()..add(DealerSearchInitialEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: FunctionalWidgets.buildAppBar(
          context: context,
          color: AppColors.greyFFB5B5B5,
          title: CustomText(text: 'Vựa thu gom'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
          child: CommonMarginContainer(
            child: searchBar(),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        Expanded(
          child: CommonMarginContainer(
            child: BlocBuilder<DealerSearchBloc, DealerSearchState>(
              builder: (context, state) {
                return mainResult(state.status);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget mainResult(FormzStatus status) {
    switch (status) {
      case FormzStatus.submissionSuccess:
        return mainResults();
      case FormzStatus.submissionInProgress:
        return FunctionalWidgets.getLoadingAnimation();
      case FormzStatus.submissionFailure:
        return FunctionalWidgets.getErrorIcon();
      default:
        return Container();
    }
  }

  Widget mainResults() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            child: CustomText(
              text: 'Các vựa thu gom gần bạn',
              fontWeight: FontWeight.w500,
              fontSize: 50.sp,
            ),
          ),
          Expanded(
            child: BlocBuilder<DealerSearchBloc, DealerSearchState>(
              builder: (context, state) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var d = state.listDealers[index];
                    return DealerWidget(
                      id: d.dealerId,
                      distance: d.distanceText,
                      fromTime: d.openTime,
                      toTime: d.closeTime,
                      name: d.dealerName,
                      urlImage: d.dealerImageUrl,
                      address: d.dealerAddress,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20.h,
                  ),
                  itemCount: state.listDealers.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 50.h,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: Icon(Icons.search),
              focusColor: Colors.transparent,
              hintText: 'Tìm kiếm',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 60.w,
          ),
          child: Row(
            children: [
              Icon(
                Icons.map_outlined,
              ),
              CustomText(text: 'Bản đồ'),
            ],
          ),
        ),
      ],
    );
  }
}

class DealerWidget extends StatelessWidget {
  const DealerWidget({
    required this.id,
    required this.name,
    required this.address,
    required this.fromTime,
    required this.toTime,
    required this.distance,
    required this.urlImage,
    Key? key,
  }) : super(key: key);
  final String id;
  final String name;
  final String address;
  final String fromTime;
  final String toTime;
  final String distance;
  final String urlImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 200.h,
        maxHeight: 500.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30.w,
        vertical: 30.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
            Radius.circular(30.0.r) //                 <--- border radius here
            ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              height: 230.r,
              width: 230.r,
              child: CachedNetworkImage(
                httpHeaders: {HttpHeaders.authorizationHeader: bearerToken},
                imageUrl: urlImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
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
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomText(text: name),
                  CustomText(text: address),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(text: 'Mở cửa: $fromTime - $toTime'),
                      ),
                      CustomText(
                        text: distance,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
