import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  final center = LatLng(19.434851, -99.060538);
  String selectedStyle = 'mapbox://styles/crispin97/cklwln2ao5h5n17o03aihduad';

  final oscuroStyle = 'mapbox://styles/crispin97/cklwlkve340v017m1hs028g0e';
  final streetStyle = 'mapbox://styles/crispin97/cklwln2ao5h5n17o03aihduad';


  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _crearMapa(),
      floatingActionButton: _botonesFlotantes(),
    );
  }

  Column _botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        //ZoomIn
        FloatingActionButton(
          child: Icon(Icons.sentiment_very_dissatisfied),
          onPressed: (){
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              textField: 'Montaña creada aqui',
              textOffset: Offset(0,2),
              iconImage: 'networkImage'
              // iconImage: 'attraction-15',
              // iconSize: 3
            ));
          },
        ),

        SizedBox(height: 5,),

        //ZoomIn
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: (){
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
        ),

        SizedBox(height: 5,),

        //ZoomOut
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: (){
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),

        SizedBox(height: 5,),

        //Cambiar Estilo
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen),
          onPressed: (){
            if(selectedStyle == oscuroStyle){
              selectedStyle = streetStyle;
            }else{
              selectedStyle = oscuroStyle;
            }
            _onStyleLoaded();
            setState((){});
          },
        )
      ],
    );
  }

  MapboxMap _crearMapa(){
    return MapboxMap(
      accessToken: 'pk.eyJ1IjoiY3Jpc3Bpbjk3IiwiYSI6ImNrbHdrMDYzejAybTkydm8ycHg2Y3YwZ3YifQ.HJIIilpqSb2_AZwgDJv3Rg',
      onMapCreated: _onMapCreated,
      initialCameraPosition: 
        CameraPosition(
          target: center,
          zoom: 14
        ),
      // onStyleLoadedCallback: onStyleLoadedCallback,
      styleString: selectedStyle,
    );
  }
}