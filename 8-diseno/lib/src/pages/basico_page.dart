import 'package:flutter/material.dart';

class BasicoPage extends StatelessWidget {

  final estiloTitulo = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 18.0, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _crearImagen(),
            _crearTitulo(),
            _crearAcciones(),
            _crearTexto(),
            _crearTexto(),
            _crearTexto(),
            _crearTexto(),
          ]
        ),
      ),
    );
  }


  Widget _crearImagen(){
    return Image(
      image: NetworkImage('https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80'),
      height: 200.0,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _crearTitulo(){
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Lago con un bosque', style: estiloTitulo),
                  SizedBox(height: 7.0),
                  Text('Un bosque en Canada', style: estiloSubTitulo)
                ],
              ),
            ),

            Icon(Icons.star, color: Colors.red, size: 30.0),
            Text('41', style: TextStyle(fontSize: 20.0))
          ],
        ),
      ),
    );
  }

  Widget _crearAcciones(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _accion(Icons.call, 'CALL'),
        _accion(Icons.near_me, 'ROUTE'),
        _accion(Icons.share, 'SHARE'),
      ],
    );
  }

  Widget _accion(IconData icon, String texto){
    return Column(
      children: <Widget>[
        Icon(icon, color: Colors.blue, size: 40.0),
        SizedBox(height: 15.0,),
        Text(texto, style: TextStyle(color: Colors.blue, fontSize: 15.0),)
      ],
    );
  }

  Widget _crearTexto(){
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Text(
          'Qui ea adipisicing ullamco elit ad minim mollit non est eu nisi cupidatat sit. Magna fugiat sunt id sint cillum eiusmod culpa et tempor ut ullamco pariatur cupidatat adipisicing. Anim tempor veniam consequat culpa laborum mollit sint consectetur eu excepteur consequat occaecat. Lorem cillum nostrud velit minim commodo ut incididunt.',
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}