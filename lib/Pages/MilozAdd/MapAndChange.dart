import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Canstants/color_const.dart';

class MapChange extends StatefulWidget {
  final Position position;

  MapChange({required this.position}) : super();

  @override
  _MapChangeState createState() => _MapChangeState();
}

class _MapChangeState extends State<MapChange> {
  // static const LatLng _center = const LatLng(45.3998323, 55.7865946);

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;

  late GoogleMapController _controller;

  late LatLng _lastMapPosition;

  late double latit;
  late double longit;

  String searchAdd = "";
  String adressName = "";

  @override
  void initState() {
    super.initState();
    _lastMapPosition =
        LatLng(widget.position.latitude, widget.position.longitude);
    _fetchLocationForY(widget.position.latitude, widget.position.longitude);
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_lastMapPosition.latitude, _lastMapPosition.longitude),
            zoom: 15,
          ),
        ),
      );
      if (_markers.length > 0) {
        MarkerId markerId = MarkerId(_markerIdVal());
        Marker marker = _markers[markerId]!;
        Marker updatedMarker = marker.copyWith(
          positionParam: _lastMapPosition,
        );
        // setState(() {
        _markers[markerId] = updatedMarker;
        // });
        _fetchLocationForY(
            _lastMapPosition.latitude, _lastMapPosition.longitude);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              initialCameraPosition:
                  CameraPosition(target: _lastMapPosition, zoom: 15.0),
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: false,
              onTap: (camera) {
                if (_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker marker = _markers[markerId]!;
                  Marker updatedMarker = marker.copyWith(
                    positionParam: camera,
                  );
                  setState(() {
                    _markers[markerId] = updatedMarker;
                  });

                  _fetchLocationForY(camera.latitude, camera.longitude);
                }
              },
            ),
            Positioned(
              top: 20,
              left: 15,
              right: 15,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: cWhiteColor),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter address',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: cTextColor2),
                    contentPadding: EdgeInsets.only(top: 15, left: 15),
                    suffixIcon: IconButton(
                      onPressed: searchnavigate,
                      icon: Icon(Icons.search),
                      iconSize: 30,
                      color: cFirstColor,
                    ),
                  ),
                  onChanged: (val) {
                    searchAdd = val;
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: cWhiteColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 4,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: cTextColor2),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/location.svg',
                            color: cFirstColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            adressName,
                            style: TextStyle(color: cFirstColor, fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Spacer(),
                    InkResponse(
                      onTap: () {
                        Navigator.pop(context, {
                          "lat": latit,
                          "lng": longit,
                          "address": adressName
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cFirstColor),
                        height: 55,
                        child: Text(
                          'Подтвердите адрес доставки',
                          style: TextStyle(color: cWhiteColor, fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 155),
        child: FloatingActionButton(
          onPressed: _onAddMarkerButtonPressed,
          elevation: 0,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: cWhiteColor,
          child: const Icon(
            Icons.my_location,
            size: 30.0,
            color: cFirstColor,
          ),
        ),
      ),
    );
  }

  // _fetchLocationForY(double lat, double lng) async {
  //   try{
  //     List<Placemark> newPlace =
  //     await GeocodingPlatform.instance.placemarkFromCoordinates(lat, lng, localeIdentifier: "en");
  //     Placemark placeMark = newPlace[0];
  //     adressName = placeMark.name!;
  //   }catch(e){
  //     print(e);
  //   }
  //   setState(() {});
  // }

  // _fetchLocationForY(double lat, double lng) async {
  //   try {
  //     final YandexGeocoder geocoder = YandexGeocoder(apiKey: 'AIzaSyAbf037ol6k0AnStgOavDCFdytuXi6dSCg');
  //
  //     final GeocodeResponse geocodeFromPoint =
  //         await geocoder.getGeocode(GeocodeRequest(
  //       geocode: PointGeocode(latitude: lat, longitude: lng),
  //       lang: Lang.enEn,
  //     ));
  //     adressName = geocodeFromPoint.firstAddress.toString();
  //     latit = lat;
  //     longit = lng;
  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  _fetchLocationForY(double lat, double lng) async {
    try {
      var placemarks = await GeocodingPlatform.instance
          .placemarkFromCoordinates(lat, lng, localeIdentifier: "en");
      adressName =
          '${placemarks.first.street!.isNotEmpty ? placemarks.first.street! : ''}';
      latit = lat;
      longit = lng;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  searchnavigate() {
    locationFromAddress(searchAdd).then((result) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(result[0].latitude, result[0].longitude),
            zoom: 15,
          ),
        ),
      );
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    if (_lastMapPosition != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = _lastMapPosition;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 2), () async {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 15.0,
            ),
          ),
        );
      });
    }
  }
}
