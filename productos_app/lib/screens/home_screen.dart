import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/services/services.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if(productService.isLoading) return LoadingScreen();
    final products = [...productService.products];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }, 
          icon: Icon(Icons.login_outlined)
        ),
        title: Text('Productos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount:products.length,
        itemBuilder: (_, index) => GestureDetector(
          onTap: (){
            productService.selectedProduct = productService.products[index].copy();
            Navigator.of(context).pushNamed('product');
          },
          child: ProductCard(product: products[index],)
        )
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          productService.selectedProduct = new Product(
            available: false, 
            name: '', 
            price: 0.0
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}