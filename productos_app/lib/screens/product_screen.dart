import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productSevice = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider(productSevice.selectedProduct),
      child: _ProductScreenBody(productSevice: productSevice),
    );
  }
}


class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productSevice,
  }) : super(key: key);

  final ProductsService productSevice;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(url: productSevice.selectedProduct.picture,),

                  Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white,),
                      onPressed: () => Navigator.pop(context),
                    )
                  ),

                  Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,),
                      onPressed: () async{
                        // TODO: Camara o galeria
                        final picker = new ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 100
                        );

                        if(pickedFile == null){
                          print('No se selecciono nada');
                          return;
                        }
                        productSevice.updateSelectedProductImage(pickedFile.path);
                        print('Tenemos imagen ${ pickedFile.path }');
                      },
                    )
                  ),
                ],
              ),

              _ProductForm(),

              SizedBox(height: 100)
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: productSevice.isSaving
        ? CircularProgressIndicator(color: Colors.white,)
        : Icon(Icons.save_outlined),
        onPressed: productSevice.isSaving
          ? null
          : () async{
            if(!productForm.isValidForm()) return;

            final String? imageUrl = await productSevice.uploadImage();

            if(imageUrl != null) productForm.product.picture = imageUrl;

            await productSevice.saveOrCreateProduct(productForm.product);
            // Navigator.pop(context);
          },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: _buildBoxDecoration(),
      child: Form(
        key: productFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(height: 10,),

            TextFormField(
              initialValue: product.name,
              onChanged: ( value ) => product.name = value,
              validator: (value){
                if(value== null  ||  value.length < 1){
                  return 'El nombre es obligatorio';
                }
              },
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Nombre del producto', 
                labelText: 'Nombre:'
              ),
            ),            
            SizedBox(height: 30,),


            TextFormField(
              initialValue: '${product.price}',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              onChanged: (value){
                if(double.tryParse(value) == null){
                  product.price = 0;
                }else{
                  product.price = double.parse(value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                hintText: '\$150.00', 
                labelText: 'Precio:'
              ),
            ),
            SizedBox(height: 30,),


            SwitchListTile.adaptive(
              value: product.available,
              title: Text('Disponible'),
              activeColor: Colors.white,
              activeTrackColor: Colors.indigo,
              onChanged: productFormProvider.updateAvailability
            ),
            SizedBox(height: 30,),
          ],
        )
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}