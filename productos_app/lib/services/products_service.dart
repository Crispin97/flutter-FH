import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/product.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-2f322-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  final storage = new FlutterSecureStorage();

  File? newPictureFile; 
  
  bool isLoading = true;
  bool isSaving = false;

  ProductsService(){
    this.loadProducts();
  }

  // <List<Product>>
  Future<List<Product>> loadProducts() async{

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'product.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();

    return this.products;
  }

  Future saveOrCreateProduct(Product product) async{
    isSaving = true;
    notifyListeners();
    if(product.id == null){
      await this.createProduct(product);
    }else{
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }


  Future<String?> updateProduct(Product product) async{
    final url = Uri.https(_baseUrl, 'product/${ product.id }.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    await http.put(url, body: product.toJson());
    // final decodedData = resp.body;

    final index = products.indexWhere((prod) => prod.id == product.id);
    products[index] = product;

    return product.id;
  }

  Future<String?> createProduct(Product product) async{
    final url = Uri.https(_baseUrl, 'product.json', {
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: product.toJson());
    final decodedData = jsonDecode(resp.body);

    product.id = decodedData['name'];

    this.products.add(product);

    return product.id;
  }

  void updateSelectedProductImage(String path){
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }
  
  Future<String?> uploadImage() async{
    if(this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dc4rhud0c/image/upload?upload_preset=usrluh0b');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salio mal');
      return null;
    }

    this.newPictureFile = null;

    final decodedData = jsonDecode(resp.body);
    return decodedData['secure_url'];
  }
}