import 'package:collector_app/providers/services/map_service.dart';
import 'package:collector_app/utils/env_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class GoongMap extends StatefulWidget {
  const GoongMap({Key? key}) : super(key: key);

  @override
  _GoongMapState createState() => _GoongMapState();
}

class _GoongMapState extends State<GoongMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Map Seller'),
      ),
      body: MapboxMap(
        accessToken: EnvMapSettingValue.accessToken,
        styleString: EnvMapSettingValue.mapStype,
        onStyleLoadedCallback: () async {},
        initialCameraPosition:
            CameraPosition(target: LatLng(51.5, -0.09), zoom: 15.0),
        onMapCreated: (MapboxMapController controller) async {
          final result = await acquireCurrentLocation();

          // You can either use the moveCamera or animateCamera, but the former
          // causes a sudden movement from the initial to 'new' camera position,
          // while animateCamera gives a smooth animated transition
          await controller.animateCamera(
            CameraUpdate.newLatLng(result),
          );

          await controller.addCircle(
            CircleOptions(
              circleRadius: 10.0,
              circleColor: '#E50F08',
              circleOpacity: 0.8,

              // YOU NEED TO PROVIDE THIS FIELD!!!
              // Otherwise, you'll get a silent exception somewhere in the stack
              // trace, but the parameter is never marked as @required, so you'll
              // never know unless you check the stack trace
              geometry: result,
              draggable: false,
            ),
          );
        },
      ),
    );
  }
}
