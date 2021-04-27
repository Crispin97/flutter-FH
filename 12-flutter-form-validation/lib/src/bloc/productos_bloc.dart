import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';

class ProductosBloc{
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();
  List<ProductoModel> productos;

  Stream<List<ProductoModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarProductos() async{
    productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void agregarProductos(ProductoModel producto) async{
    _cargandoController.sink.add(true);

    final id = await _productosProvider.crearProducto(producto);
    producto.id = id;
    productos.add(producto);
    _productosController.sink.add(productos);

    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async{
    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void editarProducto(ProductoModel producto) async{
    _cargandoController.sink.add(true);

    await _productosProvider.editarProducto(producto);
    final posicion = productos.indexWhere((prod) => prod.id==producto.id);
    productos [posicion] = producto;
    _productosController.sink.add(productos);
    
    _cargandoController.sink.add(false);
  }
  
  void borrarProducto(String id) async{
    await _productosProvider.borrarProducto(id);
  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }
}