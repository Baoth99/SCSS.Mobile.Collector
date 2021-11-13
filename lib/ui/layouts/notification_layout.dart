import 'package:collector_app/blocs/collecting_request_detail_bloc.dart';
import 'package:collector_app/blocs/notification_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/ui/layouts/dealer_transaction_detail_layout.dart';
import 'package:collector_app/ui/layouts/pending_request_detail_layout.dart';
import 'package:collector_app/ui/layouts/seller_transaction_detail_layout.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/common_scaffold_title.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>().add(NotificationInitial());
    return Scaffold(
      // backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const CommonScaffoldTitle('Thông báo'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: CommonMarginContainer(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return state.screenStatus.isSubmissionSuccess
                ? getBody()
                : state.screenStatus.isSubmissionInProgress
                    ? FunctionalWidgets.getLoadingAnimation()
                    : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget getBody() {
    try {
      return NotificationBody();
    } catch (e) {
      AppLog.error(e);
      return FunctionalWidgets.getErrorIcon();
    }
  }
}

class NotificationBody extends StatefulWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state.refreshStatus == RefreshStatus.completed) {
          _refreshController.refreshCompleted();
        }
        if (state.loadStatus == LoadStatus.idle) {
          _refreshController.loadComplete();
        }
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
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
            onRefresh: onRefresh(context),
            onLoading: onLoading(context),
            child: state.listNotificationData.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(
                      top: kFloatingActionButtonMargin + 5.h,
                      bottom: kFloatingActionButtonMargin + 48.h,
                    ),
                    itemBuilder: (context, index) {
                      return NotificationElement(
                        state.listNotificationData[index].id,
                        state.listNotificationData[index].isRead,
                        state.listNotificationData[index].title,
                        state.listNotificationData[index].body,
                        state.listNotificationData[index].time,
                        index,
                        state.listNotificationData[index].screenId,
                        state.listNotificationData[index].screenDataId,
                        state.listNotificationData[index].notiType,
                      );
                    },
                    separatorBuilder: (context, index) => _divider(),
                    itemCount: state.listNotificationData.length,
                  )
                : emptyList(),
          );
        },
      ),
    );
  }

  void Function() onLoading(BuildContext context) {
    return () {
      context.read<NotificationBloc>().add(NotificationLoading());
    };
  }

  void Function() onRefresh(BuildContext context) {
    return () {
      context.read<NotificationBloc>().add(NotificationRefresh());
    };
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
            text: 'Chưa có thông báo',
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

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Divider(
        thickness: 1.h,
        color: AppColors.greyFFEEEEEE,
      ),
    );
  }
}

class NotificationElement extends StatefulWidget {
  NotificationElement(
    this.id,
    this.isRead,
    this.title,
    this.content,
    this.time,
    this.index,
    this.screenId,
    this.screenDataId,
    this.notiType, {
    Key? key,
  }) : super(key: key);

  final String id;
  final bool isRead;
  final String title;
  final String content;
  final String time;
  final int index;
  final int? screenId;
  final String? screenDataId;
  final int notiType;

  @override
  _NotificationElementState createState() => _NotificationElementState();
}

class _NotificationElementState extends State<NotificationElement> {
  bool isRead = false;
  @override
  void initState() {
    super.initState();
    isRead = widget.isRead;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NotificationBloc>().add(
              NotificationRead(widget.id, widget.index),
            );

        setState(() {
          isRead = true;
        });

        if (widget.screenId != null) {
          switch (widget.screenId) {
            case 1:
            case 2:
              if (widget.screenDataId != null) {
                if (widget.notiType == ActivityLayoutConstants.approved) {
                  Navigator.of(context).pushNamed(
                    Routes.pendingRequestDetail,
                    arguments: PendingRequestDetailArgs(widget.screenDataId!,
                        CollectingRequestDetailStatus.approved),
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    Routes.sellerTransactionDetail,
                    arguments: SellerTransctionDetailArgs(
                      widget.screenDataId!,
                    ),
                  );
                }
              }
              break;
            case 3:
              Navigator.pushNamed(
                context,
                Routes.dealerTransactionDetail,
                arguments: DealerTransctionDetailArgs(
                  widget.screenDataId!,
                ),
              );
              break;
            default:
          }
        }
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.w),
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                // color: AppColors.greenFF61C53D.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment
                      .bottomRight, // 10% of the width, so there are ten blinds.
                  colors: <Color>[
                    isRead
                        ? AppColors.greenFF39AC8F.withOpacity(0.6)
                        : AppColors.greenFF39AC8F.withOpacity(0.9),
                    isRead
                        ? AppColors.greenFF61C53D.withOpacity(0.6)
                        : AppColors.greenFF61C53D.withOpacity(0.9),
                  ], // red to yellow
                ),
              ),
              child: Icon(
                isRead ? Icons.drafts_outlined : Icons.email_outlined,
                color: AppColors.white,
              ),
            ),
            Container(
              child: const VerticalDivider(color: Colors.white, width: 14),
              margin: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.title,
                    fontSize: 47.sp,
                    color: isRead ? AppColors.greyFF939393 : AppColors.black,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    child: CustomText(
                      text: widget.content,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w400,
                      color: isRead
                          ? AppColors.black.withOpacity(0.7)
                          : AppColors.black,
                      fontSize: 37.sp,
                    ),
                  ),
                  CustomText(
                    text: widget.time,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
