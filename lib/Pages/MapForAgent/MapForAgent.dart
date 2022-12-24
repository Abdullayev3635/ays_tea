import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapForAgent extends StatefulWidget {
  final String lat;
  final String lng;
  final String name;

  const MapForAgent({
    required this.lat,
    required this.lng,
    required this.name,
  }) : super();

  @override
  _MapForAgentState createState() => _MapForAgentState();
}

class _MapForAgentState extends State<MapForAgent> {
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(
              double.parse(widget.lat == "" ? "40.3998261" : widget.lat),
              double.parse(widget.lng == "" ? "71.7865557" : widget.lng)),
          infoWindow: InfoWindow(
            title: widget.name,
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 0),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(
                          widget.lat == "" ? "40.3998261" : widget.lat),
                      double.parse(
                          widget.lng == "" ? "71.7865557" : widget.lng)),
                  zoom: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
