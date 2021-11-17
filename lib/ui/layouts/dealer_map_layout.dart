import 'dart:typed_data';

import 'package:collector_app/blocs/dealer_search_bloc.dart';
import 'package:collector_app/constants/constants.dart';
import 'package:collector_app/log/logger.dart';
import 'package:collector_app/providers/services/dealer_service.dart';
import 'package:collector_app/ui/layouts/dealer_search_layout.dart';
import 'package:collector_app/ui/widgets/function_widgets.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class DealerMapLayout extends StatelessWidget {
  const DealerMapLayout({DealerService? dealerService, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DealerSearchBloc()..add(DealerSearchInitialEvent()),
      child: Scaffold(
        body: BlocBuilder<DealerSearchBloc, DealerSearchState>(
          builder: (context, state) {
            return state.status.isSubmissionSuccess
                ? DealerMapBody()
                : state.status.isSubmissionFailure
                    ? FunctionalWidgets.getErrorIcon()
                    : FunctionalWidgets.getLoadingAnimation();
          },
        ),
      ),
    );
  }
}

class DealerMapBody extends StatefulWidget {
  const DealerMapBody({Key? key}) : super(key: key);

  @override
  _DealerMapBodyState createState() => _DealerMapBodyState();
}

class _DealerMapBodyState extends State<DealerMapBody> {
  MapboxMapController? controller;
  Symbol? _selectedSymbol;

  DealerInfo? _dealerInfo;

  @override
  void dispose() {
    controller?.onSymbolTapped.remove(_onSymbolTapped);
    controller?.dispose();
    super.dispose();
  }

  void Function() _onStyleLoaded(DealerSearchState state) {
    return () {
      addImageFromAsset(ImagesPaths.placeSymbolName, ImagesPaths.placeSymbol);
      controller!.onSymbolTapped.add(_onSymbolTapped);
      _addAll(state.listDealers);
    };
  }

  void _onMapCreated(controller) {
    this.controller = controller;
  }

  void _onSymbolTapped(Symbol symbol) {
    try {
      if (_selectedSymbol != null) {
        _updateSelectedSymbol(
          SymbolOptions(
            iconSize: 0.7,
          ),
        );
      }
      setState(() {
        _selectedSymbol = symbol;
      });
      _updateSelectedSymbol(
        SymbolOptions(
          iconSize: 1.0,
        ),
      );

      // info

      var data = (symbol.data as Map<String, DealerInfo>)['info'];
      setState(() {
        _dealerInfo = data;
      });
      print(data);
    } catch (e) {
      AppLog.error(e);
    }
  }

  Future<void> _addAll(List<DealerInfo> dealerList) async {
    if (dealerList.isNotEmpty) {
      final List<SymbolOptions> symbolOptionsList = dealerList
          .map((i) => getSymbolOption(i.latitude, i.longtitude))
          .toList();
      controller!.addSymbols(
        symbolOptionsList,
        dealerList.map((i) => {'info': i}).toList(),
      );
    }
  }

  SymbolOptions getSymbolOption(double lat, double log) {
    LatLng geometry = LatLng(lat, log);
    return SymbolOptions(
      geometry: geometry,
      iconImage: ImagesPaths.placeSymbolName,
      iconSize: 0.7,
    );
  }

  void _updateSelectedSymbol(SymbolOptions changes) {
    controller!.updateSymbol(_selectedSymbol!, changes);
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller!.addImage(name, list);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocBuilder<DealerSearchBloc, DealerSearchState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return MapboxMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLatitude,
                  currentLongitude,
                ),
                zoom: 15.0,
              ),
              accessToken: EnvMapSettingValue.accessToken,
              onMapCreated: _onMapCreated,
              trackCameraPosition: true,
              styleString: EnvMapSettingValue.mapStype,
              onStyleLoadedCallback: _onStyleLoaded(state),
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationTrackingMode: MyLocationTrackingMode.None,
              myLocationRenderMode: MyLocationRenderMode.COMPASS,
              // onCameraIdle: _onCameraIdle(context),
            );
          },
        ),
        // Positioned(
        //   bottom: 250.h,
        //   right: 50.h,
        //   child: Container(
        //     child: IconButton(
        //       color: Colors.grey[600],
        //       icon: const Icon(Icons.my_location),
        //       onPressed: () {
        //         _animateCrurentLocation();
        //       },
        //     ),
        //     width: 150.w,
        //     height: 150.h,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.grey.withOpacity(0.5),
        //           spreadRadius: 2,
        //           blurRadius: 7,
        //           offset: const Offset(0, 3), // changes position of shadow
        //         ),
        //       ],
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),

        Padding(
          padding: EdgeInsets.only(
            top: 120.h,
            left: 60.w,
          ),
          child: Align(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 70.r,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            alignment: Alignment.topLeft,
          ),
        ),
        _dealerInfo != null
            ? Padding(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DealerWidget(
                    id: _dealerInfo!.dealerId,
                    address: _dealerInfo!.dealerAddress,
                    distance: _dealerInfo!.distanceText,
                    fromTime: _dealerInfo!.openTime,
                    toTime: _dealerInfo!.closeTime,
                    name: _dealerInfo!.dealerName,
                    urlImage: _dealerInfo!.dealerImageUrl,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 50.h,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
