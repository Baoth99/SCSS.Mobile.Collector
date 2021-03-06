import 'dart:async';

import 'package:collector_app/blocs/home_bloc.dart';
import 'package:collector_app/blocs/main_bloc.dart';
import 'package:collector_app/blocs/notification_bloc.dart';
import 'package:collector_app/blocs/profile_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/services/firebase_service.dart';
import 'package:collector_app/ui/layouts/account_layout.dart';
import 'package:collector_app/ui/layouts/activity_layout.dart';
import 'package:collector_app/ui/layouts/home_layout.dart';
import 'package:collector_app/ui/layouts/notification_layout.dart';
import 'package:collector_app/ui/layouts/statistic_layout.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final Timer _timer;
  // late final Timer _timer5;

  @override
  void initState() {
    super.initState();
    FirebaseNotification.getNotificationAfterTerminated();
    // Get number of  unread notifcation count
    context.read<NotificationBloc>().add(NotificationUncountGet());

    initProfileBloc();
    setBearerToken();
  }

  void setBearerToken() async {
    NetworkUtils.getBearerToken().then((value) => bearerToken = value);
  }

  void initProfileBloc() {
    //profile
    context.read<ProfileBloc>().add(ProfileClear());
    context.read<ProfileBloc>().add(ProfileInitial());
    context.read<ProfileBloc>().add(UpdateCoordinate());

    //home
    context.read<HomeBloc>().add(HomeInitial());
    try {
      _timer = Timer.periodic(
        const Duration(minutes: 1),
        (timer) {
          try {
            context.read<ProfileBloc>().add(ProfileInitial());
            context.read<ProfileBloc>().add(UpdateCoordinate());
          } catch (e) {
            AppLog.error(e);
          }
        },
      );
    } catch (e) {
      AppLog.error(e);
    }
    // try {
    //   _timer5 = Timer.periodic(
    //     const Duration(minutes: 10),
    //     (timer) {
    //       try {
    //         context.read<HomeBloc>().add(HomeFetch());
    //       } catch (e) {
    //         AppLog.error(e);
    //       }
    //     },
    //   );
    // } catch (e) {
    //   AppLog.error(e);
    // }
  }

  @override
  void dispose() {
    _timer.cancel();
    // _timer5.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (context) => MainBloc()..add(MainInitial()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              return BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.greenFF01C971,
                unselectedFontSize: 23.sp,
                selectedFontSize: 26.sp,
                currentIndex: state.screenIndex,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.statistic
                            ? Icons.analytics
                            : Icons.analytics_outlined,
                      ),
                    ),
                    label: 'Th???ng k??',
                  ),
                  BottomNavigationBarItem(
                    icon: BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, sno) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            RadiantGradientMask(
                              child: Icon(
                                state.screenIndex ==
                                        MainLayoutConstants.notification
                                    ? Icons.notifications
                                    : Icons.notifications_outlined,
                              ),
                            ),
                            sno.unreadCount > 0
                                ? Positioned(
                                    // draw a red marble
                                    top: -25.0.h,
                                    right: -20.0.w,
                                    child: Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          color: Colors.white,
                                          text: sno.unreadCount <= 99
                                              ? '${sno.unreadCount}'
                                              : '99+',
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        );
                      },
                    ),
                    label: 'Th??ng b??o',
                  ),
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.home
                            ? Icons.home
                            : Icons.home_outlined,
                      ),
                    ),
                    label: 'Trang ch???',
                  ),
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.activity
                            ? Icons.history
                            : Icons.history_outlined,
                      ),
                    ),
                    label: 'Ho???t ?????ng',
                  ),
                  BottomNavigationBarItem(
                    icon: RadiantGradientMask(
                      child: Icon(
                        state.screenIndex == MainLayoutConstants.account
                            ? Icons.person
                            : Icons.person_outline,
                      ),
                    ),
                    label: 'T??i kho???n',
                  ),
                ],
                onTap: (value) {
                  if (MainLayoutConstants.mainTabs.contains(value)) {
                    context.read<MainBloc>().add(MainBarItemTapped(value));
                  }
                },
              );
            },
          ),
        ),
        body: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            int index = state.screenIndex;
            switch (index) {
              case MainLayoutConstants.statistic:
                return const StatisticLayout();
              case MainLayoutConstants.notification:
                return const NotificationLayout();
              case MainLayoutConstants.home:
                return const HomeLayout();
              case MainLayoutConstants.activity:
                return const ActivityLayout();
              case MainLayoutConstants.account:
                return const AccountLayout();
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
