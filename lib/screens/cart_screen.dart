import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: productProvider.cart.length,
        itemBuilder: (context, index) {
          final product = productProvider.cart[index];
          return Card(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Image.network(product.image, width: 50, height: 50),
              title: Text(product.title),
              subtitle: Text("\$${product.price}"),
              trailing: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  productProvider.removeFromCart(product);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
