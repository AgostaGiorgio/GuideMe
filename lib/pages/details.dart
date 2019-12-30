import 'dart:ui';

import 'package:GuideMe/commons/Itinerary.dart';
import 'package:GuideMe/commons/itinerary_stop.dart';
import 'package:GuideMe/pages/follow_itinerary_maps.dart';
import 'package:GuideMe/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailsPage extends StatefulWidget {
  final Itinerary itinerary;

  const DetailsPage({Key key, this.itinerary}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  final Set<Marker> _markers = Set();
  final Set<Polyline> _polyline = Set();
  GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.itinerary.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 200,
              child: GoogleMap(
                mapType: MapType.terrain,
                //that needs a list<Polyline>
                polylines: _polyline,
                markers: _markers,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: widget.itinerary.stops[0].coord,
                  zoom: 13.0,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              "Descrizione",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Text(
              widget.itinerary.longDescription,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            child: Row(
              children: <Widget>[
                Icon(Icons.access_time, size: 30),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "3 ore e 40 minuti",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            padding: EdgeInsets.only(left: 18),
          ),
          Padding(
            child: Row(
              children: <Widget>[
                Icon(Icons.directions_walk, size: 30),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "7 km",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            padding: EdgeInsets.only(left: 18, top: 4),
          ),
          Padding(
            child: Row(
              children: <Widget>[
                Icon(Icons.euro_symbol, size: 30),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "0 - 30",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            padding: EdgeInsets.only(left: 18, top: 4),
          ),
          Padding(
            child: Row(
              children: <Widget>[
                Icon(Icons.restaurant, size: 30),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Ristoranti tipici",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            padding: EdgeInsets.only(left: 18, top: 4),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: IconButton(
                      icon: new Icon(
                        widget.itinerary.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 36,
                      ),
                      onPressed: () =>
                          setState(() => Utils.favourite(widget.itinerary)),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.red)),
                    borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItineraryMaps(
                                  itinerary: widget.itinerary,
                                ))),
                    child: Text("AVVIA"),
                  ),
                  SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      for (int i = 0; i < widget.itinerary.stops.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId(widget.itinerary.stops[i].coord.toString()),
          position: widget.itinerary.stops[i].coord,
          infoWindow: InfoWindow(
            title: widget.itinerary.stops[i].name,
          ),
        ));
      }

      _polyline.add(Polyline(
        polylineId: PolylineId('itinerary'),
        visible: true,
        //latlng is List<LatLng>
        points: widget.itinerary.stops.map((ItineraryStop s)=>s.coord).toList(),
        width: 2,
        color: Colors.blue,
      ));
    });
  }
}
