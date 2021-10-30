import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collector_app/blocs/dealer_transaction_bloc.dart';
import 'package:collector_app/blocs/seller_transaction_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/common_scaffold_title.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collector_app/utils/extension_methods.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActivityLayout extends StatelessWidget {
  const ActivityLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const CommonScaffoldTitle('Hoạt động của tôi'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottom: TabBar(
            indicatorColor: Colors.green[600],
            labelColor: Colors.green[600],
            labelStyle: TextStyle(
              fontSize: 44.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: Colors.grey[600],
            tabs: [
              const Tab(
                text: 'Lịch Sử Thu Mua',
              ),
              const Tab(
                text: 'Lịch Sử Bán',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const SellerActivityLayout(),
            const DealerActivityLayout(),
          ],
        ),
      ),
    );
  }
}

class SellerActivityLayout extends StatelessWidget {
  const SellerActivityLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SellerTransactionBloc()
        ..add(
          SellerTransactionInitial(),
        ),
      child: Scaffold(
        body: CommonMarginContainer(
          child: body(),
        ),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget body() {
    return BlocBuilder<SellerTransactionBloc, SellerTransactionState>(
      builder: (context, state) => buildBody(context, state),
    );
  }

  Widget buildBody(
    BuildContext context,
    SellerTransactionState state,
  ) {
    try {
      switch (state.status) {
        case SellerTransactionStatus.completed:
          return SellerTransactionList();
        case SellerTransactionStatus.progress:
          return FunctionalWidgets.getLoadingAnimation();
        case SellerTransactionStatus.error:
          return FunctionalWidgets.getErrorIcon();
        default:
          return const SizedBox.shrink();
      }
    } catch (e) {
      AppLog.error(e);
      return FunctionalWidgets.getErrorIcon();
    }
  }
}

class SellerTransactionList extends StatefulWidget {
  const SellerTransactionList({Key? key}) : super(key: key);

  @override
  _SellerTransactionListState createState() => _SellerTransactionListState();
}

class _SellerTransactionListState extends State<SellerTransactionList> {
  late final RefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerTransactionBloc, SellerTransactionState>(
      builder: (context, state) =>
          BlocListener<SellerTransactionBloc, SellerTransactionState>(
        listener: (context, state) {
          if (state.refreshStatus == RefreshStatus.completed) {
            _refreshController.refreshCompleted();
          }
          if (state.loadStatus == LoadStatus.idle) {
            _refreshController.loadComplete();
          }
        },
        child: _buildCommonPullToResfresh(
            context, state, state.listSellerTransaction.isNotEmpty),
      ),
    );
  }

  Widget _buildCommonPullToResfresh(
      BuildContext context, SellerTransactionState state, bool isNotEmpty) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(
        waterDropColor: AppColors.greenFF61C53D,
        failed: SizedBox.shrink(),
        complete: SizedBox.shrink(),
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("");
          } else {
            body = Text("");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh(context),
      onLoading: _onLoading(context),
      child: isNotEmpty
          ? ListView.separated(
              padding: EdgeInsets.only(
                top: kFloatingActionButtonMargin + 5.h,
                bottom: kFloatingActionButtonMargin + 48.h,
              ),
              itemBuilder: (context, index) => _buildActivity(
                state,
                index,
              ),
              separatorBuilder: (context, index) => const SizedBox.shrink(),
              itemCount: state.listSellerTransaction.length,
            )
          : _emptyList(),
    );
  }

  Widget _buildActivity(
    SellerTransactionState state,
    int index,
  ) {
    var a = state.listSellerTransaction[index];
    return SellerActivity(
      id: a.id,
      name: a.name,
      datetime: a.time,
      price: a.price,
      status: a.status,
    );
  }

  void Function() _onLoading(BuildContext context) {
    return () {
      context.read<SellerTransactionBloc>().add(SellerTransactionLoading());
    };
  }

  void Function() _onRefresh(BuildContext context) {
    return () {
      context.read<SellerTransactionBloc>().add(SellerTransactionRefresh());
    };
  }

  Widget _emptyList() {
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
            text: 'Chưa có yêu cầu',
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
}

class SellerActivity extends StatelessWidget {
  const SellerActivity({
    Key? key,
    required this.id,
    required this.name,
    required this.datetime,
    this.price = 0,
    required this.status,
  }) : super(key: key);

  final String id;
  final String name;
  final String datetime;
  final int price;
  final int status;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: main(context),
      margin: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 40.h,
        horizontal: 30.w,
      ),
      color: Colors.white,
    );
  }

  Widget main(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          RadiantGradientMask(
            child: Icon(
              Icons.account_circle_sharp,
              color: Colors.white,
              size: 120.sp,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: name),
                CustomText(text: datetime),
                _getPrice(context, status),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _getHeaderStatus(context, status),
            ],
          )
        ],
      ),
    );
  }

  Widget _getPrice(BuildContext context, int status) {
    switch (status) {
      case ActivityLayoutConstants.completed:
        return CustomText(text: price.toAppPrice());
      case ActivityLayoutConstants.cancelBySeller:
      case ActivityLayoutConstants.cancelBySystem:
      case ActivityLayoutConstants.cancelByCollect:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getHeaderStatus(BuildContext context, int status) {
    switch (status) {
      case ActivityLayoutConstants.cancelBySeller:
      case ActivityLayoutConstants.cancelBySystem:
        return _getStatusTextHeader('Bị hủy', AppColors.orangeFFF5670A);
      case ActivityLayoutConstants.cancelByCollect:
        return _getStatusTextHeader('Đã hủy', AppColors.orangeFFF5670A);
      case ActivityLayoutConstants.completed:
        return _getStatusTextHeader('Hoàn thành', AppColors.greenFF61C53D);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getStatusTextHeader(
    String text,
    Color color,
  ) {
    return CustomText(
      text: text,
      color: color,
    );
  }
}

class DealerActivityLayout extends StatelessWidget {
  const DealerActivityLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DealerTransactionBloc()
        ..add(
          DealerTransactionInitial(),
        ),
      child: Scaffold(
        body: CommonMarginContainer(
          child: body(),
        ),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget body() {
    return BlocBuilder<DealerTransactionBloc, DealerTransactionState>(
      builder: (context, state) => buildBody(context, state),
    );
  }

  Widget buildBody(
    BuildContext context,
    DealerTransactionState state,
  ) {
    try {
      switch (state.status) {
        case DealerTransactionStatus.completed:
          return DealerTransactionList();
        case DealerTransactionStatus.progress:
          return FunctionalWidgets.getLoadingAnimation();
        case DealerTransactionStatus.error:
          return FunctionalWidgets.getErrorIcon();
        default:
          return const SizedBox.shrink();
      }
    } catch (e) {
      AppLog.error(e);
      return FunctionalWidgets.getErrorIcon();
    }
  }
}

class DealerTransactionList extends StatefulWidget {
  const DealerTransactionList({Key? key}) : super(key: key);

  @override
  _DealerTransactionListState createState() => _DealerTransactionListState();
}

class _DealerTransactionListState extends State<DealerTransactionList> {
  late final RefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealerTransactionBloc, DealerTransactionState>(
      builder: (context, state) =>
          BlocListener<DealerTransactionBloc, DealerTransactionState>(
        listener: (context, state) {
          if (state.refreshStatus == RefreshStatus.completed) {
            _refreshController.refreshCompleted();
          }
          if (state.loadStatus == LoadStatus.idle) {
            _refreshController.loadComplete();
          }
        },
        child: _buildCommonPullToResfresh(
            context, state, state.listDealerTransaction.isNotEmpty),
      ),
    );
  }

  Widget _buildCommonPullToResfresh(
      BuildContext context, DealerTransactionState state, bool isNotEmpty) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(
        waterDropColor: AppColors.greenFF61C53D,
        failed: SizedBox.shrink(),
        complete: SizedBox.shrink(),
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("");
          } else {
            body = Text("");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh(context),
      onLoading: _onLoading(context),
      child: isNotEmpty
          ? ListView.separated(
              padding: EdgeInsets.only(
                top: kFloatingActionButtonMargin + 5.h,
                bottom: kFloatingActionButtonMargin + 48.h,
              ),
              itemBuilder: (context, index) => _buildActivity(
                state,
                index,
              ),
              separatorBuilder: (context, index) => const SizedBox.shrink(),
              itemCount: state.listDealerTransaction.length,
            )
          : _emptyList(),
    );
  }

  Widget _buildActivity(
    DealerTransactionState state,
    int index,
  ) {
    var a = state.listDealerTransaction[index];
    return DealerActivity(
      id: a.id,
      dealerName: a.dealerName,
      dealerUrl: a.dealerImage,
      price: a.price,
      time: a.time,
    );
  }

  void Function() _onLoading(BuildContext context) {
    return () {
      context.read<DealerTransactionBloc>().add(DealerTransactionLoading());
    };
  }

  void Function() _onRefresh(BuildContext context) {
    return () {
      context.read<DealerTransactionBloc>().add(DealerTransactionRefresh());
    };
  }

  Widget _emptyList() {
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
            text: 'Chưa có yêu cầu',
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
}

class DealerActivity extends StatelessWidget {
  const DealerActivity({
    Key? key,
    required this.id,
    required this.dealerName,
    required this.dealerUrl,
    required this.time,
    required this.price,
  }) : super(key: key);

  final String id;
  final String dealerName;
  final String dealerUrl;
  final String time;
  final int price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //detail
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 200.h,
          maxHeight: 500.h,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 20.h,
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
                  imageUrl: dealerUrl,
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
                    CustomText(text: dealerName),
                    CustomText(text: time),
                    Container(
                      child: CustomText(
                        text: price.toAppPrice(),
                        textAlign: TextAlign.right,
                      ),
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
