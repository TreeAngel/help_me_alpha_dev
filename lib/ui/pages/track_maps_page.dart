import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';

class TrackMaps extends StatelessWidget {
  const TrackMaps({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final colorScheme = appTheme.colorScheme;
    
    final mapControler = MapController();

    return Scaffold(
      body: OSMFlutter(
        controller: mapControler,
        osmOption: OSMOption(
          userTrackingOption: UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: ZoomOption(
            initZoom: 8,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: RoadOption(
            roadColor: Colors.yellowAccent,
          ),
            
            // markerOption: MarkerOption(
            //     defaultMarker: MarkerIcon(
            //         icon: Icon(
            //           Icons.person_pin_circle,
            //           color: Colors.blue,
            //           size: 56,
            //         ),
            //     )
            // ),
        ),
      )
    );
  }
}