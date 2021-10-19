import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DealerSearchLayout extends StatelessWidget {
  const DealerSearchLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        color: AppColors.greyFFB5B5B5,
        title: CustomText(text: 'Vựa thu gom'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _body(context),
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
            child: mainResults(),
          ),
        ),
      ],
    );
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
            child: ListView.separated(
              itemBuilder: (context, index) => DealerWidget(
                id: 'fsfsdf',
                distance: '2.1km',
                fromTime: '08:00',
                toTime: '17:00',
                name: 'Thu mua phế liệu Bảo Minh',
                urlImage:
                    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
                address:
                    '589 Đường số 18, Bình Hưng Hoà, Bình Tân, Thành phố Hồ Chí Minh, Việt Nam',
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 20.h,
              ),
              itemCount: 10,
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
              child: Image.network(
                urlImage,
                fit: BoxFit.cover,
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
