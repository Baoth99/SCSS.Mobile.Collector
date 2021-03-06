import 'dart:convert';

import 'package:collector_app/blocs/check_approved_request_bloc.dart';
import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/request_book_list_bloc.dart';
import 'package:collector_app/blocs/request_now_list_bloc.dart';
import 'package:collector_app/constants/api_constants.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/ui/layouts/pending_request_detail_layout.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logging/logging.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:collector_app/utils/extension_methods.dart';

class PendingRequestLayout extends StatelessWidget {
  const PendingRequestLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RequestNowListBloc()
            ..add(
              RequestNowListInitial(),
            ),
        ),
        BlocProvider(
          create: (context) => RequestBookListBloc()
            ..add(
              RequestBookListInitial(),
            ),
        ),
      ],
      child: PendingRequestMain(),
    );
  }
}

class PendingRequestMain extends StatefulWidget {
  const PendingRequestMain({Key? key}) : super(key: key);

  @override
  _PendingRequestLayoutState createState() => _PendingRequestLayoutState();
}

class _PendingRequestLayoutState extends State<PendingRequestMain> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    init();
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  late final HubConnection hubConnection;

  @override
  void dispose() {
    hubConnection.stop();
    _refreshController.dispose();
    super.dispose();
  }

  void init() async {
// Configer the logging
    Logger.root.level = Level.ALL;
// Writes the log messages to the console
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

// If you want only to log out the message for the higer level hub protocol:
    final hubProtLogger = Logger("SignalR - hub");
// If youn want to also to log out transport messages:
    final transportProtLogger = Logger("SignalR - transport");

// Creates the connection by using the HubConnectionBuilder.
    hubConnection = HubConnectionBuilder()
        .withUrl(APIServiceURI.hubColellectingRequest,
            options: HttpConnectionOptions(
              logger: transportProtLogger,
              accessTokenFactory: () async => NetworkUtils.getBearer(),
            ))
        .configureLogging(hubProtLogger)
        .build();
// When the connection is closed, print out a message to the console.
    hubConnection.onclose((error) => print("Connection Closed"));
    hubConnection.on(
        "ReceiveCollectingRequest", _handleAClientProvidedFunction);
    await hubConnection.start();
  }

  void _handleAClientProvidedFunction(List<Object> parameters) {
    AppLog.info('Server invoked: $parameters');
    if (parameters.isNotEmpty) {
      var data = parameters[0];
      var model = collectingRequestNoticeModelFromJson(data.toString());
      AppLog.info('Server invoked: $model');

      context
          .read<CheckApprovedRequestBloc>()
          .add(CheckRequestStatusRealTime(model));
      context.read<RequestBookListBloc>().add(RequestBookIsApproved(model));
      context.read<RequestNowListBloc>().add(RequestNowIsApproved(model));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
          context: context,
          color: AppColors.greyFFB5B5B5,
          title: CustomText(text: 'Y??u c???u thu gom m???i'),
          backgroundColor: AppColors.white,
          elevation: 1,
          action: [
            IconButton(
              onPressed: () {
                context.read<RequestNowListBloc>().add(RequestNowListInitial());
                context
                    .read<RequestBookListBloc>()
                    .add(RequestBookListInitial());
              },
              icon: Icon(
                Icons.replay,
                color: AppColors.greyFF9098B1,
              ),
            ),
          ]),
      body: body(context),
    );
  }

  Widget contentDivider() {
    return Divider(
      thickness: 20.h,
      color: AppColors.greyFFEEEEEE,
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        getNowRequests(),
        Expanded(
          child: BlocBuilder<RequestBookListBloc, RequestBookListState>(
            builder: (context, state) {
              return BlocBuilder<RequestBookListBloc, RequestBookListState>(
                builder: (context, state) =>
                    BlocListener<RequestBookListBloc, RequestBookListState>(
                  listener: (context, state) {
                    if (state.refreshStatus == RefreshStatus.completed) {
                      _refreshController.refreshCompleted();
                    }
                    if (state.loadStatus == LoadStatus.idle) {
                      _refreshController.loadComplete();
                    }
                  },
                  child: _buildBookRequestScreen(
                    context,
                    state,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget getNowRequests() {
    return BlocBuilder<RequestNowListBloc, RequestNowListState>(
      builder: (context, state) {
        var listRequest = <Widget>[];

        for (var r in state.listRequest) {
          listRequest.add(
            CollectingRequest(
              bookingId: r.id,
              bulky: r.isBulky,
              cusName: r.sellerName,
              distance: r.distanceText,
              placeName: r.area,
              pendingRequestStatus: r.pendingRequestStatus,
              time: r.collectingRequestDate,
              fromTime: r.fromTime,
              toTime: r.toTime,
            ),
          );
        }

        return state.listRequest.isNotEmpty
            ? Material(
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                      // color: AppColors.white,
                      ),
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(top: 30.h, left: 45.w),
                          child: CustomText(
                            text: 'Y??u c???u ch??? ?????n ngay',
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: listRequest,
                      ),
                      state.listRequest.length > 3
                          ? InkWell(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20.h),
                                      child: CustomText(
                                        text: 'Xem t???t c??? y??u c???u',
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 30.w, bottom: 20.h),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: AppColors.greyFF9098B1,
                                      size: 80.sp,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      contentDivider(),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildBookRequestScreen(
    BuildContext context,
    RequestBookListState state,
  ) {
    try {
      switch (state.status) {
        case RequestBookListStatus.completed:
          return getBookRequests();
        case RequestBookListStatus.progress:
          return FunctionalWidgets.getLoadingAnimation();
        case RequestBookListStatus.error:
          return FunctionalWidgets.getErrorIcon();
        default:
          return const SizedBox.shrink();
      }
    } catch (e) {
      AppLog.error(e);
      return FunctionalWidgets.getErrorIcon();
    }
  }

  Widget getBookRequests() {
    return BlocBuilder<RequestBookListBloc, RequestBookListState>(
      builder: (context, state) {
        return Material(
          elevation: 0,
          child: Container(
            child: Column(
              children: [
                Row(children: [
                  Container(
                    padding: EdgeInsets.only(top: 30.h, left: 45.w),
                    child: CustomText(
                      text: 'Y??u c???u ?????t h???n',
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
                Expanded(
                  child: _buildBookRequestList(
                      context, state, state.listRequest.isNotEmpty),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookRequestList(
      BuildContext context, RequestBookListState state, bool isNotEmpty) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(
        waterDropColor: AppColors.greenFF01C971,
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
      onRefresh: _onRefreshBook(context),
      onLoading: _onLoadingBook(context),
      child: isNotEmpty
          ? ListView.separated(
              itemBuilder: (_, index) {
                var r = state.listRequest[index];
                return CollectingRequest(
                  bookingId: r.id,
                  distance: r.distanceText,
                  cusName: r.sellerName,
                  time: r.collectingRequestDate,
                  fromTime: r.fromTime,
                  toTime: r.toTime,
                  placeName: r.area,
                  bulky: r.isBulky,
                  pendingRequestStatus: r.pendingRequestStatus,
                );
              },
              separatorBuilder: (_, __) {
                return SizedBox(
                  height: 50.h,
                );
              },
              itemCount: state.listRequest.length,
            )
          : _emptyList(),
    );
  }

  void Function() _onLoadingBook(BuildContext context) {
    return () {
      context.read<RequestBookListBloc>().add(RequestBookListLoading());
    };
  }

  void Function() _onRefreshBook(BuildContext context) {
    return () {
      context.read<RequestBookListBloc>().add(RequestBookListRefresh());
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
            text: 'Kh??ng c?? y??u c???u n??o xung quanh',
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

class CollectingRequest extends StatelessWidget {
  const CollectingRequest({
    Key? key,
    required this.bookingId,
    required this.distance,
    required this.cusName,
    required this.time,
    required this.fromTime,
    required this.toTime,
    required this.placeName,
    required this.bulky,
    required this.pendingRequestStatus,
  }) : super(key: key);

  final String bookingId;
  final String distance;
  final String cusName;
  final DateTime time;
  final String fromTime;
  final String toTime;
  final String placeName;
  final bool bulky;
  final PendingRequestStatus pendingRequestStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35.h, horizontal: 100.w),
      constraints: BoxConstraints(
        minHeight: 130.h,
      ),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30.0.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyFFDADADA,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ]),
      child: Stack(
        children: [
          pendingRequestStatus == PendingRequestStatus.pending
              ? SizedBox.shrink()
              : Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30.0.r),
                    ),
                  ),
                ),
          InkWell(
            onTap: pendingRequestStatus == PendingRequestStatus.pending
                ? () {
                    context.read<CheckApprovedRequestBloc>().add(
                          AddIdCheckApprove(bookingId),
                        );
                    Navigator.of(context)
                        .pushNamed(
                      Routes.pendingRequestDetail,
                      arguments: PendingRequestDetailArgs(
                        bookingId,
                        CollectingRequestDetailStatus.pending,
                      ),
                    )
                        .then((value) {
                      context
                          .read<CheckApprovedRequestBloc>()
                          .add(RefershCheckApproved());
                    });
                  }
                : () {
                    if (pendingRequestStatus == PendingRequestStatus.approved) {
                      FunctionalWidgets.showSnackBar(context,
                          'Y??u c???u thu gom n??y ???? ???????c nh???n b???i ng?????i thu gom kh??c.');
                    } else if (pendingRequestStatus ==
                        PendingRequestStatus.canceled) {
                      FunctionalWidgets.showSnackBar(
                          context, 'Y??u c???u thu gom n??y ???? b??? h???y.');
                    }
                  },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0.r),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: bulky
                            ? AppColors.orangeFFF9CB79
                            : AppColors.greenFF66D095,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.w,
                            ),
                            child: Image.asset(
                              bulky
                                  ? ActivityLayoutConstants.bulkyImage
                                  : ActivityLayoutConstants.notBulkyImage,
                              width: 90.w,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 40.h),
                            child: CustomText(
                              text: distance,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        constraints: BoxConstraints(minHeight: 270.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getContainerColumn(
                              CustomText(
                                text: cusName,
                                color: Color(0xff4C63A9),
                                fontSize: 42.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            _getContainerColumn(
                              CustomText(
                                text:
                                    '${time.toStringPendingRequest()}, $fromTime - $toTime',
                                color: Colors.green[600],
                                fontSize: 42.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            _getContainerColumn(
                              CustomText(
                                text: placeName,
                                fontSize: 38.sp,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // isCompleted != null && isCompleted!
                    //     ? Container(
                    //   // constraints: BoxConstraints(
                    //   //   minWidth: 100.w,
                    //   // ),
                    //   width: 270.w,
                    //   child: CustomText(
                    //     text: extraInfo ?? Symbols.empty,
                    //     color: isCompleted!
                    //         ? Colors.green[600]
                    //         : AppColors.orangeFFF5670A,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    //   alignment: Alignment.center,
                    // )
                    //     : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getContainerColumn(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: child,
    );
  }
}

CollectingRequestNoticeModel collectingRequestNoticeModelFromJson(String str) =>
    CollectingRequestNoticeModel.fromJson(json.decode(str));

class CollectingRequestNoticeModel {
  CollectingRequestNoticeModel({
    required this.id,
    required this.requestType,
    required this.status,
  });

  final String id;
  final int? requestType;
  final int? status;

  factory CollectingRequestNoticeModel.fromJson(Map<String, dynamic> json) =>
      CollectingRequestNoticeModel(
        id: json["Id"],
        requestType: json["RequestType"],
        status: json["Status"],
      );
}
