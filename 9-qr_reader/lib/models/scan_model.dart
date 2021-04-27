import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
class ScanModel {
    
    int id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        this.tipo,
        @required this.valor,
    }){
      if(this.valor.contains('http')){
        this.tipo = 'http';
      }else{
        this.tipo = 'geo';
      }
    }

    LatLng getLatLng(){
      final latlng = this.valor.substring(4).split(',');
      final lat = double.parse(latlng[0]);
      final lng = double.parse(latlng[1]);

      return LatLng(lat, lng);
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };
}