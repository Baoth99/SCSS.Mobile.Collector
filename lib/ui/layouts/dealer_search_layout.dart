import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collector_app/blocs/dealer_detail_bloc.dart';
import 'package:collector_app/blocs/dealer_search_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/ui/widgets/common_margin_container.dart';
import 'package:collector_app/ui/widgets/custom_text_widget.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/common_utils.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

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
            child: SearchWidget(),
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
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Function(String)? _onChanged(BuildContext context) {
    return (value) {
      // check if _debounce exist
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 1500),
        () {
          context.read<DealerSearchBloc>().add(
                DealerSearch(value),
              );
        },
      );
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
        InkWell(
          child: Container(
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
          onTap: () {
            Navigator.of(context).pushNamed(Routes.dealerMap);
          },
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

  Widget _divider() {
    return Container(
      child: Divider(
        thickness: 3.h,
        color: AppColors.greyFFEEEEEE,
      ),
    );
  }

  Widget dealerImage(BuildContext context) {
    return BlocProvider(
      create: (context) => DealerDetailBloc()..add(DealerDetailInitial(id)),
      child: Stack(alignment: Alignment.topRight, children: [
        BlocBuilder<DealerDetailBloc, DealerDetailState>(
            builder: (context, state) {
          return Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50.r),
              ),
              child: Container(
                height: 830.h,
                width: 1230.w,
                color: Colors.white,
                child:
                    state.status.isPure || state.status.isSubmissionInProgress
                        ? Center(
                            child: FunctionalWidgets.getLoadingCircle(),
                          )
                        : CachedNetworkImage(
                            httpHeaders: {
                              HttpHeaders.authorizationHeader: bearerToken
                            },
                            imageUrl: state.dealerImageUrl,
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
            ),
          );
        }),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: 20.h, right: 20.w),
            child: Image.asset(
              ImagesPaths.closeIcon,
              width: 80.w,
            ),
          ),
        )
      ]),
    );
  }

  Widget dealerInfo() {
    return BlocProvider(
      create: (context) => DealerDetailBloc()..add(DealerDetailInitial(id)),
      child: BlocBuilder<DealerDetailBloc, DealerDetailState>(
          builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                blurRadius: 1.0,
                spreadRadius: 0.0,
                offset: Offset(1.0, 1.0), // shadow direction: bottom right
              )
            ],
          ),
          padding: EdgeInsets.all(40.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: state.dealerName,
                fontSize: 55.sp,
                fontWeight: FontWeight.w600,
                // overflow: TextOverflow.ellipsis,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  children: [
                    CustomText(
                      text: state.rate.toStringAsFixed(1),
                      fontWeight: FontWeight.w400,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.orangeFFF5670A,
                            size: 45.sp,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CustomText(
                text: 'Giờ mở cửa: ' + state.openTime + ' - ' + state.closeTime,
                fontSize: 45.sp,
                color: AppColors.black.withOpacity(0.7),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget dealerContact() {
    return BlocProvider(
      create: (context) => DealerDetailBloc()..add(DealerDetailInitial(id)),
      child: BlocBuilder<DealerDetailBloc, DealerDetailState>(
        builder: (context, state) {
          return state.status.isSubmissionSuccess
              ? Container(
                  color: AppColors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _divider(),
                      InkWell(
                        onTap: () {
                          if (state.latitude != null &&
                              state.longtitude != null) {
                            CommonUtils.launchMapDir(
                                state.latitude!, state.longtitude!);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 20.h, bottom: 20.h, left: 80.w, right: 40.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 40.w),
                                child: Image.asset(
                                  ImagesPaths.directionIcon,
                                  width: 120.w,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: state.dealerAddress,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      _divider(),
                      InkWell(
                        onTap: () {
                          CommonUtils.launchTelephone(state.dealerPhone);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 20.h, bottom: 20.h, left: 80.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 40.w),
                                child: Image.asset(
                                  ImagesPaths.phoneIcon,
                                  width: 120.w,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: state.dealerPhone,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      _divider(),
                      Container(
                        padding: EdgeInsets.only(
                            top: 20.h, bottom: 20.h, left: 80.w),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 40.w),
                              child: Image.asset(
                                ImagesPaths.promotionIcon,
                                width: 120.w,
                              ),
                            ),
                            Expanded(
                              child: CustomText(
                                text: 'Khuyến mãi',
                                // overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      _divider(),
                      Container(
                        width: 1000.w,
                        height: 1000.h,
                        margin: EdgeInsets.only(
                            top: 30.h, bottom: 330.h, left: 50.w, right: 50.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: DealerMap(),
                        ),
                      ),
                    ],
                  ),
                )
              : FunctionalWidgets.getLoadingAnimation();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //detail
        showModalBottomSheet<void>(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.r),
          )),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.96,
              minChildSize: 0.85,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50.r),
                  )),
                  child: ListView(
                    controller: scrollController,
                    children: <Widget>[
                      dealerImage(context),
                      dealerInfo(),
                      dealerContact()
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
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
                          child:
                              CustomText(text: 'Mở cửa: $fromTime - $toTime'),
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
      ),
    );
  }
}

class DealerMap extends StatefulWidget {
  const DealerMap({Key? key}) : super(key: key);

  @override
  _DealerMapState createState() => _DealerMapState();
}

class _DealerMapState extends State<DealerMap> {
  MapboxMapController? controller;

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void Function() _onStyleLoaded(double? lat, double? lag) {
    return () {
      addImageFromAsset(ImagesPaths.placeSymbolName, ImagesPaths.placeSymbol);
      if (lat != null && lag != null) {
        _add(lat, lag);
      }
    };
  }

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
  }

  Future<void> _add(double lat, double lag) async {
    controller!.addSymbols([]..add(getSymbolOption(lat, lag)));
  }

  SymbolOptions getSymbolOption(double lat, double log) {
    LatLng geometry = LatLng(lat, log);
    return SymbolOptions(
      geometry: geometry,
      iconImage: ImagesPaths.placeSymbolName,
      iconSize: 0.7,
    );
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DealerDetailBloc, DealerDetailState>(
      builder: (context, state) {
        return MapboxMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              state.status.isSubmissionSuccess
                  ? state.latitude
                  : currentLatitude,
              state.status.isSubmissionSuccess
                  ? state.longtitude
                  : currentLongitude,
            ),
            zoom: 15.0,
          ),
          accessToken: EnvMapSettingValue.accessToken,
          onMapCreated: _onMapCreated,
          trackCameraPosition: true,
          styleString: EnvMapSettingValue.mapStype,
          onStyleLoadedCallback:
              _onStyleLoaded(state.latitude, state.longtitude),
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: false,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.None,
          myLocationRenderMode: MyLocationRenderMode.COMPASS,
          onMapClick: (point, coordinates) {
            if (state.latitude != null && state.longtitude != null) {
              CommonUtils.launchMapDir(state.latitude!, state.longtitude!);
            }
          },
          // onCameraIdle: _onCameraIdle(context),
        );
      },
    );
  }
}
