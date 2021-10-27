import 'package:collector_app/blocs/home_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/layouts/home_layout.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class ApprovedRequestLayout extends StatelessWidget {
  const ApprovedRequestLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //initial
    context.read<HomeBloc>().add(HomeInitial());
    context.read<HomeBloc>().add(HomeSearch(Symbols.empty));

    //
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        color: AppColors.greyFFB5B5B5,
        title: CustomText(text: 'Đơn đã nhận'),
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
            child: SearchWidget(),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        Expanded(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return mainResult(state.status);
            },
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
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                var listView = state.listCollectingRequestModel;
                var searchValue = state.searchValue.trim();
                if (searchValue.isNotEmpty) {
                  listView = listView
                      .where((r) => r.sellerPhone.contains(searchValue))
                      .toList();
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    var r = listView[index];

                    return CollectingRequest(
                      bookingId: r.id,
                      distance: r.distanceText,
                      bulky: r.isBulky,
                      cusName: r.sellerName,
                      time: CommonUtils.combineTimeToDateString(r.dayOfWeek,
                          r.collectingRequestDate, r.fromTime, r.toTime),
                      placeTitle: r.collectingAddressName,
                      placeName: r.collectingAddress,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20.h,
                  ),
                  itemCount: listView.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

//   @override
//   _SearchWidgetState createState() => _SearchWidgetState();
// }

// class _SearchWidgetState extends State<SearchWidget> {
  // Timer? _debounce;

  // @override
  // void dispose() {
  //   _debounce?.cancel();
  //   super.dispose();
  // }

  Function(String)? _onChanged(BuildContext context) {
    return (value) {
      context.read<HomeBloc>().add(HomeSearch(value));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: _onChanged(context),
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 50.h,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: Icon(Icons.search),
              focusColor: Colors.transparent,
              hintText: 'Tìm kiếm đơn hàng',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
